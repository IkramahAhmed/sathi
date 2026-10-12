import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../features/prayer/domain/entities/calc_method.dart';

/// Android notification channels.
///
/// Android caches a channel's sound for good, so a channel's sound must never
/// change. To change a sound, add a new channel with a new id instead.
abstract final class NotificationChannels {
  static const String preReminder = 'pre_reminder';
  static const String drawableIcon = 'ic_stat_saathi';

  static String nameFor(AzanSound sound) => switch (sound) {
        AzanSound.beep => 'Azan (beep)',
        AzanSound.makkah => 'Azan (Makkah)',
        AzanSound.madina => 'Azan (Madina)',
        AzanSound.silent => 'Azan (silent)',
      };

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
        sound: (sound == null || sound.isSilent) ? null : '${sound.channelId}.caf',
        interruptionLevel: InterruptionLevel.timeSensitive,
      ),
    );
  }
}
