import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/services/notification_capture_service.dart';
import 'package:saathi/core/storage/app_database.dart';

NotificationTransaction? parse(String body, {String pkg = 'invo8.meezan.mb', String title = 'Meezan Bank'}) =>
    parseNotification(packageName: pkg, title: title, body: body, timeMs: 1763900000000);

void main() {
  group('ignores things that are not transactions', () {
    test("Saathi's own confirmation notification", () {
      expect(
        parseNotification(
          packageName: 'com.ikramah.saathi',
          title: 'Meezan transaction saved',
          body: '-Rs 500 added to your Bank tab',
          timeMs: 0,
        ),
        isNull,
      );
    });

    test('OTP', () => expect(parse('Your OTP for transaction of Rs 5,000 is 482913'), isNull));
    test('failed transaction', () => expect(parse('Your transaction of PKR 500 was unsuccessful'), isNull));
    test('declined card', () => expect(parse('Card purchase of Rs 1,200 declined. Insufficient funds'), isNull));
    test('future debit', () => expect(parse('Rs 5,000 will be debited tomorrow for your installment'), isNull));
    test('bill due reminder', () => expect(parse('Your K-Electric bill of Rs 3,400 is due on 25 Nov'), isNull));
    test('balance only', () => expect(parse('Your available balance is PKR 45,000.00'), isNull));
    test('"Rs" inside a word', () => expect(parse('Office hours 9 to 5. Offers 50% off'), isNull));
  });

  group('amount', () {
    test('ignores the balance that follows', () {
      expect(parse('PKR 500 debited from A/C **4521. Avl Bal PKR 45,000.00')!.amount, 500);
    });
    test('ignores the balance that comes first', () {
      expect(parse('Avl Bal PKR 45,000 after debit of PKR 500')!.amount, 500);
    });
    test('ignores the fee', () {
      expect(parse('Fee Rs 15 charged. Rs 5,000 transferred from your A/C to Ali')!.amount, 5000);
    });
    test('decimals and commas', () => expect(parse('Rs.1,500.50 debited')!.amount, 1500.5));
    test('no space after PKR', () => expect(parse('PKR5000 credited to your account')!.amount, 5000));
    test('amount before currency', () => expect(parse('5,000 PKR received from Ali')!.amount, 5000));
    test('slash-dash format', () => expect(parse('Aap ke account mein 2500/- jama ho gaye')!.amount, 2500));
  });

  group('direction', () {
    test('outgoing transfer that mentions "credited to" the receiver is a debit', () {
      expect(parse('PKR 500 debited from your A/C **4521 and credited to ALI KHAN')!.isCredit, isFalse);
    });
    test('incoming IBFT is a credit', () {
      expect(parse('PKR 5,000 credited to your A/C **4521 from ALI KHAN via IBFT')!.isCredit, isTrue);
    });
    test('"sent you" is a credit', () {
      expect(parse('Ali sent you Rs 500', pkg: 'com.jazzcash.android', title: 'JazzCash')!.isCredit, isTrue);
    });
    test('"you have sent" is a debit', () {
      expect(parse('You have sent Rs 500 to Ali', pkg: 'com.jazzcash.android', title: 'JazzCash')!.isCredit, isFalse);
    });
    test('card spend is a debit', () => expect(parse('Rs 1,200 spent at KFC using debit card')!.isCredit, isFalse));
    test('bill payment received by biller is a debit', () {
      expect(parse('Your payment of Rs 3,400 has been received by K-Electric')!.isCredit, isFalse);
    });
    test('refund is a credit even with "purchase" in it', () {
      expect(parse('Refund of Rs 800 for your purchase at Daraz')!.isCredit, isTrue);
    });
    test('reversal of a failed transaction is kept as a credit', () {
      final tx = parse('Your failed transaction of Rs 500 has been reversed');
      expect(tx, isNotNull);
      expect(tx!.isCredit, isTrue);
    });
    test('Roman Urdu "jama" is a credit', () => expect(parse('Rs 2000 aap ke account mein jama')!.isCredit, isTrue));
  });

  group('bank name', () {
    test('known package', () => expect(parse('Rs 500 debited')!.bankName, 'Meezan'));
    test('SMS sender title', () {
      expect(parse('Rs 500 debited', pkg: 'com.google.android.apps.messaging', title: 'MEEZAN')!.bankName, 'MEEZAN');
    });
    test('long title falls back to package', () {
      expect(
        parse('Rs 500 debited', pkg: 'com.example.wallet', title: 'Dear customer your transaction alert')!.bankName,
        'wallet',
      );
    });
  });

  // Real notifications captured on a device (names and account numbers changed).
  group('real-world notifications', () {
    const sms = 'com.google.android.apps.messaging';

    test('NayaPay outgoing', () {
      final tx = parse("Rs. 1 sent to ALI KHAN. Your wallet's seen better days.",
          pkg: 'com.nayapay.app', title: 'Off it goes')!;
      expect((tx.bankName, tx.amount, tx.isCredit), ('NayaPay', 1.0, false));
    });

    test('Meezan Raast incoming', () {
      final tx = parse(
          'PKR 1.00 received from ALI KHAN AC# xxxPYMT PK00NAYA00000000 as RAAST payment to your '
          'AC# 0100000000 of UP MORH BR KHI on 21-Nov-2026 at 20:56')!;
      expect((tx.bankName, tx.amount, tx.isCredit), ('Meezan', 1.0, true));
    });

    test('Meezan app debit with helpline number', () {
      final tx = parse('PKR 500.00 has been debited at 01:51 on 23-Nov-2026 TID:014120, '
          'If you have not done this transaction, please inform us at 021111331331')!;
      expect((tx.amount, tx.isCredit), (500.0, false));
    });

    test('Meezan SMS from 8079 is labelled Meezan', () {
      final tx = parse('PKR 1,000.00 has been debited at 01:46 on 23-Nov-2026, '
          'If you have not done this transaction, please inform us at 021111331331', pkg: sms, title: '8079')!;
      expect((tx.bankName, tx.amount, tx.isCredit), ('Meezan', 1000.0, false));
    });

    test('Splitwise debt summary is ignored', () {
      expect(parse('You owe PKR350.00. See your total balance →', pkg: 'com.Splitwise.SplitwiseMobile', title: 'Gs'),
          isNull);
    });

    test('debt summary from any app is ignored', () {
      expect(parse('You owe PKR350.00', pkg: 'com.example.split', title: 'Trip'), isNull);
    });

    test('WhatsApp chat with an amount is ignored', () {
      expect(parse('bhai Rs. 500 bhej do', pkg: 'com.whatsapp', title: 'Ahmed'), isNull);
    });

    test('SMS promo with no money verb is ignored', () {
      expect(parse('Flat Rs. 200 off on your next order! Use code SAVE200', pkg: sms, title: 'DARAZ'), isNull);
    });
  });

  group('bank dedup', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    final t0 = DateTime(2026, 11, 23, 23, 58);

    ExpensesCompanion entry(double amount, String type, DateTime at, String note) => ExpensesCompanion.insert(
          amount: amount,
          category: 'other',
          type: Value(type),
          note: Value(note),
          date: '${at.year}-${at.month.toString().padLeft(2, '0')}-${at.day.toString().padLeft(2, '0')}',
          source: const Value('bank'),
          createdAt: at,
        );

    test('app push then SMS a minute later across midnight is saved once', () async {
      expect(await db.expensesDao.addIfNew(entry(500, 'expense', t0, 'Meezan: push')), isTrue);
      expect(
        await db.expensesDao.addIfNew(entry(500, 'expense', t0.add(const Duration(minutes: 3)), 'MEEZAN: sms')),
        isFalse,
      );
    });

    test('two real payments of the same amount hours apart are both saved', () async {
      expect(await db.expensesDao.addIfNew(entry(500, 'expense', t0, 'JazzCash: a')), isTrue);
      expect(await db.expensesDao.addIfNew(entry(500, 'expense', t0.add(const Duration(hours: 2)), 'JazzCash: b')),
          isTrue);
    });

    test('same amount in and out are different transactions', () async {
      expect(await db.expensesDao.addIfNew(entry(500, 'expense', t0, 'a')), isTrue);
      expect(await db.expensesDao.addIfNew(entry(500, 'income', t0, 'b')), isTrue);
    });

    test('a manual entry never blocks a bank capture', () async {
      await db.expensesDao.add(ExpensesCompanion.insert(
        amount: 500,
        category: 'food',
        date: '2026-11-23',
        createdAt: t0,
      ));
      expect(await db.expensesDao.addIfNew(entry(500, 'expense', t0, 'Meezan: push')), isTrue);
    });
  });
}
