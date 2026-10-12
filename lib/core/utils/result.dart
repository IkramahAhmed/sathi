/// A failure carried by [Result]. Use cases never throw to the UI; they
/// return one of these instead.
class AppFailure {
  const AppFailure(this.message, {this.cause, this.stackTrace});

  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() => 'AppFailure($message${cause == null ? '' : ', $cause'})';
}

/// Sealed success / failure result used by every use case.
sealed class Result<T> {
  const Result();

  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(AppFailure failure) = Failure<T>;

  bool get isSuccess => this is Success<T>;

  /// The value when successful, otherwise `null`.
  T? get valueOrNull => switch (this) {
        Success<T>(:final value) => value,
        Failure<T>() => null,
      };

  /// The failure when unsuccessful, otherwise `null`.
  AppFailure? get failureOrNull => switch (this) {
        Success<T>() => null,
        Failure<T>(:final failure) => failure,
      };

  R when<R>({
    required R Function(T value) success,
    required R Function(AppFailure failure) failure,
  }) =>
      switch (this) {
        Success<T>(value: final v) => success(v),
        Failure<T>(failure: final f) => failure(f),
      };
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

final class Failure<T> extends Result<T> {
  const Failure(this.failure);
  final AppFailure failure;
}

/// Runs [body] and converts any thrown error into a [Failure].
Future<Result<T>> guard<T>(Future<T> Function() body, {String? message}) async {
  try {
    return Result.success(await body());
  } catch (error, stackTrace) {
    return Result.failure(
      AppFailure(message ?? error.toString(), cause: error, stackTrace: stackTrace),
    );
  }
}
