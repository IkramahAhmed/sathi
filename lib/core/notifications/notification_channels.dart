import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../features/prayer/domain/entities/calc_method.dart';
import 'notification_scheduler.dart';

/// Android notification channels.
///
/// Android caches a channel's sound and audio stream for good, so neither may
/// change on an existing channel. To change one, add a new channel instead.
abstract final class NotificationChannels {
  static const String preReminder = 'pre_reminder';
  static const String jamaatReminder = 'jamaat_reminder';
  static const String prayerEnding = 'prayer_ending';
  // Alarm-volume variant of the ending channel — plays even in silent mode,
  // heard at the alarm volume instead of the media volume.
  static const String prayerEndingAlarm = 'prayer_ending_alarm';
  static const String sehriReminder = 'sehri_reminder';
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

  /// The channel to use for the azan: the alarm-volume variant when the user
  /// chose that, otherwise the normal one.
  static String azanChannelFor(AzanSound sound, {required bool alarm}) =>
      alarm ? sound.alarmChannelId : sound.channelId;

  /// iOS plays notification sounds for at most 30 seconds, so the full azan
  /// uses the short clip there.
  static String _iosSoundFile(AzanSound sound) =>
      '${sound == AzanSound.full ? AzanSound.short.channelId : sound.channelId}.caf';

  static AzanSound? _soundFor(String channelId) => AzanSound.values
      .where((s) => s.channelId == channelId || s.alarmChannelId == channelId)
      .firstOrNull;

  static bool _isAlarmChannel(String id) =>
      AzanSound.values.any((s) => !s.isSilent && s.alarmChannelId == id) ||
      id == prayerEndingAlarm;

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
        // The same sounds on the alarm volume: heard in silent mode and not tied
        // to the media volume.
        for (final sound in AzanSound.values.where((s) => !s.isSilent))
          AndroidNotificationChannel(
            sound.alarmChannelId,
            '${nameFor(sound)}, alarm volume',
            description: 'Prayer time alerts that play on the alarm volume',
            importance: Importance.max,
            sound: RawResourceAndroidNotificationSound(sound.channelId),
            audioAttributesUsage: AudioAttributesUsage.alarm,
          ),
        const AndroidNotificationChannel(
          preReminder,
          'Prayer reminders',
          description: 'A heads-up shortly before each prayer',
          importance: Importance.high,
        ),
        const AndroidNotificationChannel(
          jamaatReminder,
          'Jama\'at reminders',
          description: 'Time to leave for the mosque',
          importance: Importance.high,
        ),
        AndroidNotificationChannel(
          prayerEnding,
          'Prayer time ending',
          description: 'Reminders that a prayer\'s time is about to end',
          importance: Importance.max,
          sound: RawResourceAndroidNotificationSound(AzanSound.short.channelId),
          enableVibration: true,
        ),
        // Alarm-volume version: rings at alarm volume, heard even in silent mode.
        AndroidNotificationChannel(
          prayerEndingAlarm,
          'Prayer time ending (alarm volume)',
          description: 'Persistent prayer reminders that ring at alarm volume until you pray',
          importance: Importance.max,
          sound: RawResourceAndroidNotificationSound(AzanSound.short.channelId),
          enableVibration: true,
          audioAttributesUsage: AudioAttributesUsage.alarm,
        ),
        const AndroidNotificationChannel(
          sehriReminder,
          'Sehri reminder',
          description: 'Alert before sehri time ends during Ramadan',
          importance: Importance.max,
          enableVibration: true,
        ),
      ];

  /// Per-notification details for a given channel id.
  static NotificationDetails detailsFor(String channelId, {List<AlarmAction> actions = const []}) {
    final sound = _soundFor(channelId);
    final isReminder = channelId == preReminder || channelId == jamaatReminder;
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
        audioAttributesUsage: _isAlarmChannel(channelId)
            ? AudioAttributesUsage.alarm
            : AudioAttributesUsage.notification,
        category: AndroidNotificationCategory.reminder,
        channelBypassDnd: false,
        fullScreenIntent: false,
        actions: [
          for (final a in actions)
            AndroidNotificationAction(a.id, a.label, showsUserInterface: a.opensApp, cancelNotification: true),
        ],
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
