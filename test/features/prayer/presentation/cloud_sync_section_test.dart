import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/app/providers.dart';
import 'package:saathi/core/storage/app_database.dart';
import 'package:saathi/core/sync/cloud_api.dart';
import 'package:saathi/core/sync/sync_config.dart';
import 'package:saathi/features/prayer/presentation/widgets/cloud_sync_section.dart';
import 'package:saathi/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../support/fakes.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late FakeCloudServer server;
  late FakeSecretStore secrets;
  late AppDatabase db;

  Future<void> pumpSection(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    server = FakeCloudServer();
    secrets = FakeSecretStore();
    db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await tester.binding.setSurfaceSize(const Size(420, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          secretStoreProvider.overrideWithValue(secrets),
          appDatabaseProvider.overrideWithValue(db),
          cloudApiProvider.overrideWithValue(server),
        ],
        child: const MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          home: Scaffold(body: SingleChildScrollView(child: CloudSyncSection())),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> enterAndSubmit(WidgetTester tester, String text, String button) async {
    await tester.enterText(find.byType(TextField), text);
    await tester.tap(find.widgetWithText(FilledButton, button));
    await tester.pumpAndSettle();
  }

  testWidgets('starts off: no key, no address, no sync controls', (tester) async {
    await pumpSection(tester);
    expect(find.text('Cloud backup'), findsOneWidget);
    expect(tester.widget<SwitchListTile>(find.byKey(const ValueKey('sync-switch'))).value, isFalse);
    expect(find.text('Not set'), findsOneWidget);
    expect(find.byKey(const ValueKey('sync-key')), findsNothing);
    expect(find.byKey(const ValueKey('sync-now')), findsNothing);
    expect(secrets.values, isEmpty, reason: 'no key is made until the user turns sync on');
  });

  testWidgets('turning it on creates a key, hidden by default, and says the address is missing', (tester) async {
    await pumpSection(tester);
    await tester.tap(find.byKey(const ValueKey('sync-switch')));
    await tester.pumpAndSettle();

    final key = secrets.values.values.single;
    expect(isValidSyncKey(key), isTrue);
    expect(find.byKey(const ValueKey('sync-key')), findsOneWidget);
    expect(find.text(key), findsNothing, reason: 'the key is masked until revealed');
    expect(find.textContaining(key.substring(key.length - 4)), findsOneWidget);
    expect(find.text('Set the server address first'), findsOneWidget);
    expect(server.syncCalls, 0);

    await tester.tap(find.byKey(const ValueKey('sync-key-toggle')));
    await tester.pump();
    expect(find.text(key), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('sync-key-toggle')));
    await tester.pump();
    expect(find.text(key), findsNothing);
  });

  testWidgets('the server address is validated, then saved, and a first sync runs', (tester) async {
    await pumpSection(tester);
    await tester.tap(find.byKey(const ValueKey('sync-switch')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('sync-server')));
    await tester.pumpAndSettle();
    await enterAndSubmit(tester, 'ftp://nope', 'Save');
    expect(find.text('Enter an https:// address'), findsOneWidget, reason: 'the dialog stays open on bad input');

    await enterAndSubmit(tester, 'https://api.test', 'Save');
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('https://api.test'), findsOneWidget);
    expect(server.syncCalls, 1);
    expect(find.textContaining('Last synced'), findsOneWidget);
  });

  testWidgets('a rejected key is explained in plain words and sync can be retried', (tester) async {
    await pumpSection(tester);
    await tester.tap(find.byKey(const ValueKey('sync-switch')));
    await tester.pumpAndSettle();
    server.failWith = const CloudApiException(CloudErrorKind.unauthorized, 'no', statusCode: 401);
    await tester.tap(find.byKey(const ValueKey('sync-server')));
    await tester.pumpAndSettle();
    await enterAndSubmit(tester, 'https://api.test', 'Save');
    expect(find.text('The server did not accept this key.'), findsOneWidget);

    server.failWith = const CloudApiException(CloudErrorKind.network, 'offline');
    await tester.tap(find.byKey(const ValueKey('sync-now')));
    await tester.pumpAndSettle();
    expect(find.text('No connection. It will try again later.'), findsOneWidget);

    server.failWith = null;
    await tester.tap(find.byKey(const ValueKey('sync-now')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Last synced'), findsOneWidget);
  });

  testWidgets('pending changes are counted while offline', (tester) async {
    await pumpSection(tester);
    await db.prayerLogsDao.markDone('2026-10-15', 'fajr', DateTime.utc(2026, 10, 15, 1));
    await db.prayerLogsDao.markDone('2026-10-15', 'asr', DateTime.utc(2026, 10, 15, 11));
    await tester.tap(find.byKey(const ValueKey('sync-switch')));
    await tester.pumpAndSettle();
    server.failWith = const CloudApiException(CloudErrorKind.network, 'offline');
    await tester.tap(find.byKey(const ValueKey('sync-server')));
    await tester.pumpAndSettle();
    await enterAndSubmit(tester, 'https://api.test', 'Save');
    expect(find.textContaining('2 waiting to upload'), findsOneWidget);
  });

  testWidgets('using a key from another phone validates it and replaces this phone\'s key', (tester) async {
    await pumpSection(tester);
    await tester.tap(find.byKey(const ValueKey('sync-switch')));
    await tester.pumpAndSettle();
    final original = secrets.values.values.single;

    await tester.tap(find.byKey(const ValueKey('sync-use-key')));
    await tester.pumpAndSettle();
    await enterAndSubmit(tester, 'too-short', 'Use this key');
    expect(find.text('That does not look like a valid key'), findsOneWidget);

    final other = 'Q' * 43;
    await enterAndSubmit(tester, '  $other  ', 'Use this key');
    expect(find.byType(AlertDialog), findsNothing);
    expect(secrets.values.values.single, other);
    expect(secrets.values.values.single, isNot(original));
  });

  testWidgets('deleting cloud data asks first, erases it, forgets the key and keeps local data', (tester) async {
    await pumpSection(tester);
    await db.prayerLogsDao.markDone('2026-10-15', 'fajr', DateTime.utc(2026, 10, 15, 1));
    await tester.tap(find.byKey(const ValueKey('sync-switch')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('sync-server')));
    await tester.pumpAndSettle();
    await enterAndSubmit(tester, 'https://api.test', 'Save');
    final key = secrets.values.values.single;
    expect(server.rowsFor(key), 1);

    await tester.ensureVisible(find.byKey(const ValueKey('sync-delete')));
    await tester.tap(find.byKey(const ValueKey('sync-delete')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(server.rowsFor(key), 1, reason: 'cancel changes nothing');

    await tester.tap(find.byKey(const ValueKey('sync-delete')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(server.rowsFor(key), 0);
    expect(secrets.values, isEmpty);
    expect(find.byKey(const ValueKey('sync-key')), findsNothing);
    expect(tester.widget<SwitchListTile>(find.byKey(const ValueKey('sync-switch'))).value, isFalse);
    expect(await db.prayerLogsDao.doneFor('2026-10-15'), {'fajr'}, reason: 'the phone keeps its own log');
  });

  testWidgets('if the cloud cannot be reached, deleting does not forget the key', (tester) async {
    await pumpSection(tester);
    await tester.tap(find.byKey(const ValueKey('sync-switch')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('sync-server')));
    await tester.pumpAndSettle();
    await enterAndSubmit(tester, 'https://api.test', 'Save');
    server.failWith = const CloudApiException(CloudErrorKind.network, 'offline');

    await tester.ensureVisible(find.byKey(const ValueKey('sync-delete')));
    await tester.tap(find.byKey(const ValueKey('sync-delete')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(secrets.values, isNotEmpty, reason: 'the key is the only way to delete later');
    expect(find.byKey(const ValueKey('sync-key')), findsOneWidget);
  });
}
