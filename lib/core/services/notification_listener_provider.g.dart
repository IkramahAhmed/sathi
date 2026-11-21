// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_listener_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationListenerStream)
final notificationListenerStreamProvider =
    NotificationListenerStreamProvider._();

final class NotificationListenerStreamProvider
    extends $FunctionalProvider<AsyncValue<void>, void, Stream<void>>
    with $FutureModifier<void>, $StreamProvider<void> {
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
    r'e29c2b287188c0130a7b303b4f56ff23b27dfae6';
