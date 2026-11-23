// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_listener_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drains the native capture queue on start and whenever the listener pings.

@ProviderFor(notificationListenerStream)
final notificationListenerStreamProvider =
    NotificationListenerStreamProvider._();

/// Drains the native capture queue on start and whenever the listener pings.

final class NotificationListenerStreamProvider
    extends $FunctionalProvider<AsyncValue<void>, void, Stream<void>>
    with $FutureModifier<void>, $StreamProvider<void> {
  /// Drains the native capture queue on start and whenever the listener pings.
  NotificationListenerStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationListenerStreamProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationListenerStreamHash();

  @$internal
  @override
  $StreamProviderElement<void> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<void> create(Ref ref) {
    return notificationListenerStream(ref);
  }
}

String _$notificationListenerStreamHash() =>
    r'be4be7d03f243ebd23f2f19c24b9816bdc967950';
