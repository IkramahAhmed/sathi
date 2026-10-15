import 'dart:async';

/// A tap on a notification, or on one of its buttons.
class NotificationTap {
  const NotificationTap(this.payload, {this.actionId});

  final String? payload;

  /// The button that was tapped; null for a tap on the notification itself.
  final String? actionId;
}

/// Broadcasts taps to the UI layer.
///
/// The plugin callback is a plain function (it can run before any widget
/// exists), so taps are funnelled through this process-wide bus.
final StreamController<NotificationTap> notificationTapBus = StreamController<NotificationTap>.broadcast();
