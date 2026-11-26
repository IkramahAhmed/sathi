import 'entities/expense_category.dart';
import 'entities/income_source.dart';

const _expenseWords = <ExpenseCategory, Set<String>>{
  ExpenseCategory.food: {
    'chai', 'tea', 'lunch', 'dinner', 'breakfast', 'nashta', 'khana', 'food', 'biryani', 'burger',
    'pizza', 'restaurant', 'cafe', 'coffee', 'juice', 'snack', 'snacks', 'doodh', 'milk', 'roti',
    'naan', 'sabzi', 'fruit', 'fruits', 'chicken', 'meat', 'gosht', 'bakery', 'cake', 'samosa',
    'foodpanda', 'kfc', 'mcdonald', 'hardees', 'subway', 'dominos', 'savour', 'icecream',
  },
  ExpenseCategory.transport: {
    'petrol', 'diesel', 'fuel', 'cng', 'rickshaw', 'careem', 'uber', 'indrive', 'bykea', 'taxi',
    'bus', 'parking', 'toll', 'ride', 'pso', 'shell', 'train', 'flight', 'airblue',
  },
  ExpenseCategory.rent: {'rent', 'kiraya', 'kirayah'},
  ExpenseCategory.health: {
    'dawai', 'dawa', 'medicine', 'medicines', 'doctor', 'hospital', 'clinic', 'pharmacy', 'lab',
    'dvago', 'dentist', 'checkup', 'medical',
  },
  ExpenseCategory.bills: {
    'bijli', 'electricity', 'electric', 'kelectric', 'lesco', 'iesco', 'fesco', 'mepco', 'gepco',
    'sngpl', 'ssgc', 'sui', 'gas', 'wapda', 'water', 'pani', 'wifi', 'internet', 'ptcl',
    'stormfiber', 'nayatel', 'jazz', 'zong', 'telenor', 'ufone', 'load', 'recharge', 'bill',
    'utility', 'netflix', 'subscription', 'school', 'fees', 'tuition',
  },
  ExpenseCategory.shopping: {
    'kapray', 'kapra', 'clothes', 'shirt', 'shoes', 'daraz', 'mart', 'grocery', 'groceries',
    'imtiaz', 'carrefour', 'naheed', 'alfatah', 'shopping', 'amazon', 'sapphire', 'khaadi',
    'outfitters',
  },
};

const _incomeWords = <IncomeSource, Set<String>>{
  IncomeSource.salary: {'salary', 'tankhwah', 'tankhah', 'payroll'},
  IncomeSource.freelance: {'freelance', 'upwork', 'fiverr', 'client'},
  IncomeSource.business: {'business', 'sale', 'sales', 'dukaan', 'commission'},
  IncomeSource.gift: {'gift', 'eidi', 'salami'},
};

/// Short words must match a whole word ("gas" must not match "vegas");
/// longer ones may appear inside a merchant name ("FOODPANDA-PK").
bool _mentions(String text, Set<String> words) {
  final tokens = RegExp(r'[a-z0-9]+').allMatches(text).map((m) => m.group(0)!).toSet();
  for (final w in words) {
    if (w.length <= 4 ? tokens.contains(w) : text.contains(w)) return true;
  }
  return false;
}

String _normalise(String text) => text.toLowerCase().replaceAll('-', '').replaceAll("'", '');

/// The most likely category for [text], or `other`.
ExpenseCategory guessExpenseCategory(String text) {
  final t = _normalise(text);
  for (final entry in _expenseWords.entries) {
    if (_mentions(t, entry.value)) return entry.key;
  }
  return ExpenseCategory.other;
}

/// The most likely income source for [text], or `other`.
IncomeSource guessIncomeSource(String text) {
  final t = _normalise(text);
  for (final entry in _incomeWords.entries) {
    if (_mentions(t, entry.value)) return entry.key;
  }
  return IncomeSource.other;
}

class QuickEntry {
  const QuickEntry({
    required this.amount,
    required this.note,
    required this.isIncome,
    required this.category,
    required this.incomeSource,
  });

  final double amount;
  final String note;
  final bool isIncome;
  final ExpenseCategory category;
  final IncomeSource incomeSource;

  /// The category key stored in the database.
  String get categoryKey => isIncome ? incomeSource.name : category.name;
}

final _number = RegExp(r'(\d[\d,]*(?:\.\d+)?)\s*(k|lac|lakh|lakhs)?(?![a-z0-9])');
final _currency = RegExp(r'\b(rs\.?|pkr|rupees|rupay|rupaye)(?![a-z])|₨');
const _incomeHints = {'salary', 'tankhwah', 'tankhah', 'income', 'bonus', 'freelance', 'received', 'mila', 'mili', 'commission', 'eidi'};

/// Turns "250 chai", "chai 250", "rs 1,500 petrol", "5k grocery" or "+50000 salary"
/// into an entry. Returns null when there is no amount.
QuickEntry? parseQuickAdd(String input) {
  final raw = input.trim();
  if (raw.isEmpty) return null;
  final lower = raw.toLowerCase();

  RegExpMatch? best;
  double bestValue = 0;
  for (final m in _number.allMatches(lower)) {
    var value = double.tryParse(m.group(1)!.replaceAll(',', ''));
    if (value == null) continue;
    final unit = m.group(2);
    if (unit == 'k') value *= 1000;
    if (unit == 'lac' || unit == 'lakh' || unit == 'lakhs') value *= 100000;
    if (value > bestValue) {
      best = m;
      bestValue = value;
    }
  }
  if (best == null || bestValue <= 0) return null;

  final note = (lower.substring(0, best.start) + lower.substring(best.end))
      .replaceAll(_currency, ' ')
      .replaceAll('+', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  final display = note.isEmpty ? '' : note[0].toUpperCase() + note.substring(1);

  final tokens = RegExp(r'[a-z]+').allMatches(lower).map((m) => m.group(0)!).toSet();
  final isIncome = lower.startsWith('+') || tokens.any(_incomeHints.contains);

  return QuickEntry(
    amount: bestValue,
    note: display,
    isIncome: isIncome,
    category: guessExpenseCategory(lower),
    incomeSource: guessIncomeSource(lower),
  );
}
