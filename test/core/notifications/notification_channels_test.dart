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
      'azan_makkah',
      'azan_madina',
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
    for (final sound in AzanSound.values.where((s) => !s.isSilent)) {
      final wav = File('android/app/src/main/res/raw/${sound.channelId}.wav');
      expect(wav.existsSync(), isTrue, reason: '${wav.path} is missing');
      expect(RegExp(r'^[a-z0-9_]+$').hasMatch(sound.channelId), isTrue,
          reason: 'Android raw resources must be lowercase a-z, 0-9, _');
    }
  });

  test('notification details use the full-screen-free, max-priority azan settings', () {
    final details = NotificationChannels.detailsFor('azan_makkah').android!;
    expect(details.channelId, 'azan_makkah');
    expect(details.fullScreenIntent, isFalse);
    expect(details.importance, Importance.max);
    expect(details.channelBypassDnd, isFalse);
  });

  test('unknown channel ids fall back to the first channel instead of throwing', () {
    expect(NotificationChannels.detailsFor('does_not_exist').android!.channelId, 'azan_beep');
  });
}
