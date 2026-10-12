import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saathi/core/notifications/notification_channels.dart';
import 'package:saathi/features/prayer/domain/entities/calc_method.dart';

void main() {
  test('there is one channel per sound plus a pre-reminder channel', () {
    final ids = NotificationChannels.all().map((c) => c.id).toList();
    expect(ids, [
      'azan_beep',
      'azan_full',
      'azan_short',
      'azan_silent',
      'pre_reminder',
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
        expect((channel.sound! as RawResourceAndroidNotificationSound).sound, channel.id);
      }
    }
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
