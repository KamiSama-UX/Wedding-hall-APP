// api_error_handler.dart
import 'api_error_handler.dart';

abstract class Result<T> {
  const Result();

  R when<R>({
    required R Function(T data) success,
    required R Function(ErrorHandler error) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else if (this is Failure<T>) {
      return failure((this as Failure<T>).error);
    } else {
      throw Exception('Unknown result type');
    }
  }
}

class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final ErrorHandler error;

  const Failure(this.error);
}
