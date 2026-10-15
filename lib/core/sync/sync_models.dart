/// One prayer tick (or un-tick) as sent to and received from the cloud.
class SyncChange {
  const SyncChange({
    required this.date,
    required this.prayer,
    required this.done,
    required this.updatedAt,
  });

  factory SyncChange.fromJson(Map<String, dynamic> json) => SyncChange(
        date: json['date'] as String,
        prayer: json['prayer'] as String,
        done: json['done'] as bool,
        updatedAt: DateTime.parse(json['updatedAt'] as String).toUtc(),
      );

  /// Calendar date, `yyyy-MM-dd`.
  final String date;
  final String prayer;
  final bool done;
  final DateTime updatedAt;

  Map<String, Object> toJson() => {
        'date': date,
        'prayer': prayer,
        'done': done,
        'updatedAt': updatedAt.toUtc().toIso8601String(),
      };
}

/// The server's answer to a sync call.
class SyncResponse {
  const SyncResponse({
    required this.serverTime,
    required this.cursor,
    required this.changes,
    required this.hasMore,
  });

  factory SyncResponse.fromJson(Map<String, dynamic> json) => SyncResponse(
        serverTime: DateTime.parse(json['serverTime'] as String).toUtc(),
        cursor: (json['cursor'] as num).toInt(),
        changes: [
          for (final c in json['changes'] as List<dynamic>) SyncChange.fromJson(c as Map<String, dynamic>),
        ],
        hasMore: json['hasMore'] as bool,
      );

  final DateTime serverTime;
  final int cursor;
  final List<SyncChange> changes;
  final bool hasMore;
}

/// What one full sync run did.
class SyncReport {
  const SyncReport({required this.pushed, required this.pulled, required this.applied, required this.at});

  /// Local changes uploaded.
  final int pushed;

  /// Changes received from the server.
  final int pulled;

  /// Received changes that actually changed this phone.
  final int applied;
  final DateTime at;
}
