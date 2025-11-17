/// Result type for error handling
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

final class Failure<T> extends Result<T> {
  final String message;
  final Object? error;
  const Failure(this.message, [this.error]);
}

extension ResultExtensions<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  
  T? get valueOrNull => switch (this) {
    Success(value: final v) => v,
    Failure() => null,
  };
  
  String? get errorMessage => switch (this) {
    Success() => null,
    Failure(message: final m) => m,
  };
  
  Result<R> map<R>(R Function(T) mapper) => switch (this) {
    Success(value: final v) => Success(mapper(v)),
    Failure(message: final m, error: final e) => Failure(m, e),
  };
}


