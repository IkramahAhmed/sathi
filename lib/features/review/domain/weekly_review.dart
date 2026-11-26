import '../../../core/storage/app_database.dart';
import '../../khata/domain/month_trend.dart';
import '../../prayer/domain/entities/pause_range.dart';
import '../../prayer/domain/entities/prayer_name.dart';
import '../../prayer/domain/entities/prayer_stats.dart';
import '../../udhaar/domain/dues.dart';

String _key(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// How the last seven completed days went: money, prayers, tasks, fasts and debts.
class WeeklyReview {
  const WeeklyReview({
    required this.from,
    required this.to,
    required this.spent,
    required this.previousSpent,
    required this.biggestRiseKey,
    required this.biggestRise,
    required this.prayed,
    required this.possible,
    required this.weakest,
    required this.weakestDone,
    required this.countedDays,
    required this.tasksDone,
    required this.tasksOverdue,
    required this.fastsKept,
    required this.fastsMissed,
    required this.dues,
    required this.owedToMe,
    required this.iOwe,
  });

  /// First and last day covered (both included).
  final DateTime from;
  final DateTime to;

  final double spent;
  final double previousSpent;
  final String? biggestRiseKey;
  final double biggestRise;

  final int prayed;
  final int possible;
  final PrayerName? weakest;
  final int weakestDone;
  final int countedDays;

  final int tasksDone;
  final int tasksOverdue;

  final int fastsKept;
  final int fastsMissed;

  final List<UdhaarDue> dues;
  final double owedToMe;
  final double iOwe;

  double get change => spent - previousSpent;

  /// Change against the week before, or null when that week had no spending.
  double? get percent => previousSpent > 0 ? change / previousSpent * 100 : null;

  bool get hasMoney => spent > 0 || previousSpent > 0;
  bool get hasPrayers => countedDays > 0;
  bool get hasTasks => tasksDone > 0 || tasksOverdue > 0;
  bool get hasFasts => fastsKept > 0 || fastsMissed > 0;
  bool get hasDebts => dues.isNotEmpty || owedToMe > 0 || iOwe > 0;
  bool get isEmpty => !hasMoney && !hasPrayers && !hasTasks && !hasFasts && !hasDebts;
}

/// Builds the review for the seven days before [today] (yesterday and the six
/// days before it), compared with the seven days before those. Today is left
/// out because it is not over yet.
WeeklyReview buildWeeklyReview({
  required DateTime today,
  required List<Expense> expenses,
  required Map<String, Set<PrayerName>> doneByDate,
  required List<PauseRange> pauses,
  required DateTime trackingStart,
  required List<Task> tasks,
  required List<FastLog> fasts,
  required List<UdhaarContact> contacts,
  required List<UdhaarEntry> udhaarEntries,
}) {
  final day = DateTime(today.year, today.month, today.day);
  final from = DateTime(day.year, day.month, day.day - 7);
  final to = DateTime(day.year, day.month, day.day - 1);
  final prevFrom = _key(DateTime(day.year, day.month, day.day - 14));
  final prevTo = _key(DateTime(day.year, day.month, day.day - 8));
  final fromKey = _key(from);
  final toKey = _key(to);

  bool inRange(String d, String a, String b) => d.compareTo(a) >= 0 && d.compareTo(b) <= 0;

  final counted = expenses.where((e) => e.source != 'vault').toList();
  final trend = compareMonths(
    counted.where((e) => inRange(e.date, fromKey, toKey)).toList(),
    counted.where((e) => inRange(e.date, prevFrom, prevTo)).toList(),
  );

  // Eight days ending today: the stats leave today out, which gives the seven we want.
  final stats = computePrayerStats(
    doneByDate: doneByDate,
    pauses: pauses,
    today: day,
    start: trackingStart,
    window: 8,
  );

  final tasksDone = tasks.where((t) {
    final at = t.completedAt;
    return t.isCompleted && at != null && inRange(_key(at.toLocal()), fromKey, toKey);
  }).length;
  final todayKey = _key(day);
  final tasksOverdue = tasks
      .where((t) => !t.isCompleted && t.dueDate != null && t.dueDate!.compareTo(todayKey) < 0)
      .length;

  final weekFasts = fasts.where((f) => inRange(f.date, fromKey, toKey));

  final balances = <int, double>{};
  for (final e in udhaarEntries) {
    balances[e.contactId] = (balances[e.contactId] ?? 0) + (e.type == 'gave' ? e.amount : -e.amount);
  }
  var owedToMe = 0.0;
  var iOwe = 0.0;
  for (final c in contacts) {
    final b = balances[c.id] ?? 0;
    if (b > 0) owedToMe += b;
    if (b < 0) iOwe += -b;
  }

  return WeeklyReview(
    from: from,
    to: to,
    spent: trend.current,
    previousSpent: trend.previous,
    biggestRiseKey: trend.biggestRise?.key,
    biggestRise: trend.biggestRise?.change ?? 0,
    prayed: stats.prayed,
    possible: stats.days * PrayerName.obligatory.length,
    weakest: stats.weakest,
    weakestDone: stats.weakest == null ? 0 : stats.done[stats.weakest] ?? 0,
    countedDays: stats.days,
    tasksDone: tasksDone,
    tasksOverdue: tasksOverdue,
    fastsKept: weekFasts.where((f) => f.status == 'kept').length,
    fastsMissed: weekFasts.where((f) => f.status == 'missed').length,
    dues: upcomingUdhaarDues(contacts: contacts, entries: udhaarEntries, today: day).take(3).toList(),
    owedToMe: owedToMe,
    iOwe: iOwe,
  );
}
