import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../features/prayer/domain/entities/calc_method.dart';

/// Android notification channels.
///
/// Android caches a channel's sound for good, so a channel's sound must never
/// change. To change a sound, add a new channel with a new id instead.
abstract final class NotificationChannels {
  static const String preReminder = 'pre_reminder';
  static const String drawableIcon = 'ic_stat_saathi';

  /// Channels from earlier versions. They are deleted on start so they do not
  /// linger in the system settings. (`azan_makkah` and `azan_madina` played
  /// placeholder tones.)
  static const List<String> legacyChannelIds = ['azan_makkah', 'azan_madina'];

  static String nameFor(AzanSound sound) => switch (sound) {
        AzanSound.beep => 'Azan (beep)',
        AzanSound.full => 'Azan (full)',
        AzanSound.short => 'Azan (short)',
        AzanSound.silent => 'Azan (silent)',
      };

  /// iOS plays notification sounds for at most 30 seconds, so the full azan
  /// uses the short clip there.
  static String _iosSoundFile(AzanSound sound) =>
      '${sound == AzanSound.full ? AzanSound.short.channelId : sound.channelId}.caf';

  /// Every channel the app uses.
  static List<AndroidNotificationChannel> all() => [
        for (final sound in AzanSound.values)
          AndroidNotificationChannel(
            sound.channelId,
            nameFor(sound),
            description: 'Prayer time alerts',
            importance: Importance.max,
            playSound: !sound.isSilent,
            sound: sound.isSilent ? null : RawResourceAndroidNotificationSound(sound.channelId),
            enableVibration: !sound.isSilent,
          ),
        const AndroidNotificationChannel(
          preReminder,
          'Prayer reminders',
          description: 'A heads-up shortly before each prayer',
          importance: Importance.high,
        ),
      ];

  /// Per-notification details for a given channel id.
  static NotificationDetails detailsFor(String channelId) {
    final sound = AzanSound.values.where((s) => s.channelId == channelId).firstOrNull;
    final isReminder = channelId == preReminder;
    final channel = all().firstWhere((c) => c.id == channelId, orElse: () => all().first);
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        icon: drawableIcon,
        importance: isReminder ? Importance.high : Importance.max,
        priority: isReminder ? Priority.high : Priority.max,
        playSound: channel.playSound,
        sound: channel.sound,
        enableVibration: channel.enableVibration,
        category: AndroidNotificationCategory.reminder,
        channelBypassDnd: false,
        fullScreenIntent: false,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBanner: true,
        presentList: true,
        presentSound: sound == null ? true : !sound.isSilent,
        sound: (sound == null || sound.isSilent) ? null : _iosSoundFile(sound),
        interruptionLevel: InterruptionLevel.timeSensitive,
      ),
    );
  }
}
