import 'package:controlx/core/error/failure.dart';

class Result<T> {
  final T? data;
  final Failure? failure;

  const Result._({this.data, this.failure});

  factory Result.success(T data) => Result._(data: data);

  factory Result.failure(Failure failure) => Result._(failure: failure);

  bool get isSuccess => data != null;

  bool get isFailure => failure != null;

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    if (data != null) {
      return onSuccess(data as T);
    } else {
      return onFailure(failure as Failure);
    }
  }
}
