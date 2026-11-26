import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../prayer/data/datasources/adhan_calculator.dart';
import '../../prayer/domain/entities/prayer_name.dart';
import '../../prayer/presentation/providers/prayer_providers.dart';
import '../data/task_reminders.dart';

/// Finds a prayer's start time on any date, from the user's current settings.
final prayerTimeResolverProvider = Provider<PrayerTimeResolver>((ref) {
  final settings = ref.watch(currentSettingsProvider);
  const calculator = AdhanCalculator();
  return (date, prayer) {
    final name = PrayerName.values.where((p) => p.name == prayer).firstOrNull;
    if (name == null) return null;
    return calculator.compute(date, settings).times[name];
  };
});
