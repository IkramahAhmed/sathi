import 'dart:async';

/// Broadcasts the payload of a tapped notification to the UI layer.
///
/// The plugin callback is a plain function (it can run before any widget
/// exists), so taps are funnelled through this process-wide bus.
final StreamController<String?> notificationTapBus = StreamController<String?>.broadcast();
