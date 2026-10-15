import 'dart:convert';

import '../../../../core/sync/sync_config.dart';
import '../../domain/entities/prayer_name.dart';
import '../../domain/entities/streaks.dart';

/// Remembers which prayers the user chose "stop reminders" for, so a later
/// re-plan does not bring the reminders back. Entries older than a week are dropped.
class ReminderMuteStore {
  const ReminderMuteStore(this._store);

  final KeyValueStore _store;

  static const _key = 'reminders_muted';

  static String keyFor(DateTime date, PrayerName prayer) => '${dateKey(date)}|${prayer.name}';

  Set<String> _read() {
    final raw = _store.getString(_key);
    if (raw == null) return {};
    try {
      return {...(jsonDecode(raw) as List<dynamic>).cast<String>()};
    } catch (_) {
      return {};
    }
  }

  Future<void> mute(DateTime date, PrayerName prayer, {required DateTime today}) async {
    final cutoff = dateKey(DateTime(today.year, today.month, today.day - 7));
    final next = _read().where((k) => k.compareTo(cutoff) >= 0).toSet()..add(keyFor(date, prayer));
    await _store.setString(_key, jsonEncode(next.toList()..sort()));
  }

  Future<void> unmute(DateTime date, PrayerName prayer) async {
    final next = _read()..remove(keyFor(date, prayer));
    await _store.setString(_key, jsonEncode(next.toList()..sort()));
  }

  bool isMuted(DateTime date, PrayerName prayer) => _read().contains(keyFor(date, prayer));
}
