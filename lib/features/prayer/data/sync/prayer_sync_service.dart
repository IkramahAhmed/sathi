import 'dart:async';

import '../../../../core/storage/daos.dart';
import '../../../../core/sync/cloud_api.dart';
import '../../../../core/sync/sync_config.dart';
import '../../../../core/sync/sync_models.dart';
import '../../../../core/utils/clock.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/result.dart';

/// Uploads local prayer ticks and downloads other devices' ticks.
///
/// Drift stays the source of truth and the app works offline; this only runs
/// when there is a connection and silently does nothing otherwise.
class PrayerSyncService {
  PrayerSyncService({
    required this._logs,
    required this._api,
    required this._config,
    this._clock = systemClock,
  });

  final PrayerLogsDao _logs;
  final CloudApi _api;
  final SyncConfigStore _config;
  final Clock _clock;

  /// Each pull starts this many changes before the saved position. Two devices
  /// syncing at the same moment can briefly commit out of order; the overlap
  /// makes sure nothing is missed, and re-applying a change is harmless.
  static const int overlap = 20;
  static const int _maxRounds = 50;

  Future<Result<SyncReport>>? _inFlight;

  /// Runs one sync. A call made while one is already running shares its result.
  Future<Result<SyncReport>> syncNow() => _inFlight ??= _run().whenComplete(() => _inFlight = null);

  Future<Result<SyncReport>> _run() async {
    final config = await _config.load();
    final uri = config.uri;
    final key = config.key;
    if (!config.enabled || uri == null || key == null || !isValidSyncKey(key)) {
      return const Result.failure(AppFailure('Cloud sync is not set up.'));
    }

    var cursor = _config.cursor;
    // Only the first request of a run starts early (the overlap). Later pages
    // of the same run continue exactly where the previous page ended, otherwise
    // a page smaller than the overlap would be fetched again and again.
    var from = cursor > overlap ? cursor - overlap : 0;
    var pushed = 0;
    var pulled = 0;
    var applied = 0;

    try {
      for (var round = 0; round < _maxRounds; round++) {
        final dirty = await _logs.dirtyRows();
        final response = await _api.sync(
          baseUrl: uri,
          key: key,
          cursor: from,
          changes: [
            for (final r in dirty)
              SyncChange(date: r.date, prayer: r.prayer, done: r.done, updatedAt: r.updatedAt.toUtc()),
          ],
        );

        // Only after the server confirmed. A row edited again meanwhile has a
        // newer updatedAt, so it stays dirty and goes up next round.
        for (final r in dirty) {
          await _logs.markClean(r.date, r.prayer, r.updatedAt);
        }
        pushed += dirty.length;

        for (final c in response.changes) {
          pulled++;
          final changed = await _logs.applyRemote(
            date: c.date,
            prayer: c.prayer,
            done: c.done,
            updatedAt: c.updatedAt,
          );
          if (changed) applied++;
        }

        from = response.cursor;
        if (response.cursor > cursor) cursor = response.cursor;
        await _config.setCursor(cursor);

        final moreToUpload = dirty.length >= 500;
        if (!response.hasMore && !moreToUpload) break;
      }
      final now = _clock();
      await _config.setLastSyncAt(now);
      return Result.success(SyncReport(pushed: pushed, pulled: pulled, applied: applied, at: now));
    } on CloudApiException catch (error) {
      appLog.info('Sync did not complete: $error');
      return Result.failure(AppFailure(error.message, cause: error));
    } catch (error, stackTrace) {
      appLog.warning('Sync failed unexpectedly', error, stackTrace);
      return Result.failure(AppFailure('Sync failed.', cause: error, stackTrace: stackTrace));
    }
  }

  /// Number of local changes waiting to upload.
  Future<int> pendingCount() => _logs.dirtyCount();
}
