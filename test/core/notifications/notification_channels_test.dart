import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/notifications/notification_channels.dart';
import 'package:saathi/core/notifications/notification_scheduler.dart';
import 'package:saathi/features/prayer/domain/entities/calc_method.dart';

void main() {
  test('there is a channel per sound, an alarm-volume variant of each audible one, and the reminder channels', () {
    final ids = NotificationChannels.all().map((c) => c.id).toList();
    expect(ids, [
      'azan_beep',
      'azan_full',
      'azan_short',
      'azan_silent',
      'azan_beep_alarm',
      'azan_full_alarm',
      'azan_short_alarm',
      'pre_reminder',
      'jamaat_reminder',
      'prayer_ending',
      'prayer_ending_alarm',
      'sehri_reminder',
    ]);
    expect(ids.toSet().length, ids.length, reason: 'channel ids are unique');
  });

  test('every audible channel uses its own raw sound; silent has none', () {
    for (final channel in NotificationChannels.all()) {
      if (channel.id == 'azan_silent') {
        expect(channel.playSound, isFalse);
        expect(channel.sound, isNull);
      } else if (channel.id.startsWith('azan_')) {
        expect(channel.playSound, isTrue);
        // The alarm-volume variants play the same file as their base channel.
        expect((channel.sound! as RawResourceAndroidNotificationSound).sound, channel.id.replaceAll('_alarm', ''));
      }
    }
  });

  test('alarm-volume channels use the alarm audio stream and the same sound files', () {
    for (final sound in AzanSound.values.where((s) => !s.isSilent)) {
      final normal = NotificationChannels.all().firstWhere((c) => c.id == sound.channelId);
      final alarm = NotificationChannels.all().firstWhere((c) => c.id == sound.alarmChannelId);
      expect(alarm.audioAttributesUsage, AudioAttributesUsage.alarm, reason: sound.name);
      expect(normal.audioAttributesUsage, AudioAttributesUsage.notification, reason: sound.name);
      expect((alarm.sound! as RawResourceAndroidNotificationSound).sound, sound.channelId);
      expect(alarm.importance, Importance.max);
    }
    expect(AzanSound.silent.alarmChannelId, 'azan_silent', reason: 'silent has no alarm variant');
  });

  test('azanChannelFor picks by the alarm switch', () {
    expect(NotificationChannels.azanChannelFor(AzanSound.full, alarm: false), 'azan_full');
    expect(NotificationChannels.azanChannelFor(AzanSound.full, alarm: true), 'azan_full_alarm');
    expect(NotificationChannels.azanChannelFor(AzanSound.silent, alarm: true), 'azan_silent');
  });

  test('the ending channel is loud and never bypasses Do Not Disturb', () {
    final c = NotificationChannels.all().firstWhere((c) => c.id == NotificationChannels.prayerEnding);
    expect(c.importance, Importance.max);
    expect(c.bypassDnd, isFalse);
    expect(c.sound, isNotNull);
  });

  test('the ending alarm channel uses alarm volume and plays on the alarm stream', () {
    final c = NotificationChannels.all().firstWhere((c) => c.id == NotificationChannels.prayerEndingAlarm);
    expect(c.importance, Importance.max);
    expect(c.audioAttributesUsage, AudioAttributesUsage.alarm);
    expect(c.sound, isNotNull);
    expect(c.enableVibration, isTrue);
    expect(c.bypassDnd, isFalse);
    final details = NotificationChannels.detailsFor(NotificationChannels.prayerEndingAlarm);
    expect(details.android!.audioAttributesUsage, AudioAttributesUsage.alarm);
  });

  test('notification buttons are built from the alarm actions', () {
    final d = NotificationChannels.detailsFor(
      'prayer_ending',
      actions: const [
        AlarmAction(id: 'take_photo', label: 'Take photo', opensApp: true),
        AlarmAction(id: 'stop_reminders', label: 'Stop'),
      ],
    ).android!;
    expect(d.actions!.map((a) => a.id), ['take_photo', 'stop_reminders']);
    expect(d.actions!.first.showsUserInterface, isTrue);
    expect(d.actions!.last.showsUserInterface, isFalse);
  });

  test('azan channels are max importance and never bypass Do Not Disturb', () {
    for (final channel in NotificationChannels.all().where((c) => c.id.startsWith('azan_'))) {
      expect(channel.importance, Importance.max);
      expect(channel.bypassDnd, isFalse);
    }
  });

  test('bundled raw sound files exist for every audible azan sound', () {
    final raw = Directory('android/app/src/main/res/raw');
    final names = raw.listSync().map((f) => f.uri.pathSegments.last).toList();
    for (final sound in AzanSound.values.where((s) => !s.isSilent)) {
      expect(
        names.any((n) => RegExp('^${sound.channelId}\\.(mp3|wav|ogg|m4a)\$').hasMatch(n)),
        isTrue,
        reason: 'no raw file for ${sound.channelId} in $names',
      );
      expect(RegExp(r'^[a-z0-9_]+$').hasMatch(sound.channelId), isTrue,
          reason: 'Android raw resources must be lowercase a-z, 0-9, _');
    }
  });

  test('release resource shrinking keeps the icon and every sound referenced by name', () {
    final keep = File('android/app/src/main/res/raw/keep.xml').readAsStringSync();
    expect(keep, contains('@drawable/${NotificationChannels.drawableIcon}'));
    for (final sound in AzanSound.values.where((s) => !s.isSilent)) {
      expect(keep, contains('@raw/${sound.channelId}'), reason: '${sound.channelId} would be stripped');
    }
    expect(File('android/app/src/main/res/drawable/${NotificationChannels.drawableIcon}.xml').existsSync(),
        isTrue);
  });

  test('notification details use the full-screen-free, max-priority azan settings', () {
    final details = NotificationChannels.detailsFor('azan_full').android!;
    expect(details.channelId, 'azan_full');
    expect(details.fullScreenIntent, isFalse);
    expect(details.importance, Importance.max);
    expect(details.channelBypassDnd, isFalse);
  });

  test('legacy placeholder channels are scheduled for deletion, not recreated', () {
    expect(NotificationChannels.legacyChannelIds, ['azan_makkah', 'azan_madina']);
    final current = NotificationChannels.all().map((c) => c.id);
    expect(current.any(NotificationChannels.legacyChannelIds.contains), isFalse);
  });

  test('iOS uses the short clip for the full azan (30 second limit) and has a caf for each', () {
    final full = NotificationChannels.detailsFor('azan_full').iOS!;
    expect(full.sound, 'azan_short.caf');
    expect(NotificationChannels.detailsFor('azan_short').iOS!.sound, 'azan_short.caf');
    expect(NotificationChannels.detailsFor('azan_beep').iOS!.sound, 'azan_beep.caf');
    expect(NotificationChannels.detailsFor('azan_silent').iOS!.sound, isNull);
    for (final name in ['azan_short.caf', 'azan_beep.caf']) {
      expect(File('ios/Runner/Sounds/$name').existsSync(), isTrue, reason: name);
    }
  });

  test('unknown channel ids fall back to the first channel instead of throwing', () {
    expect(NotificationChannels.detailsFor('does_not_exist').android!.channelId, 'azan_beep');
  });
}
