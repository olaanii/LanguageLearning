import '../error/failures.dart';

class Result<T> {
  final T? _data;
  final Failure? _failure;
  final bool _isSuccess;

  const Result._success(this._data) : _failure = null, _isSuccess = true;

  const Result._failure(this._failure) : _data = null, _isSuccess = false;

  factory Result.success(T data) => Result._success(data);
  factory Result.failure(Failure failure) => Result._failure(failure);

  bool get isSuccess => _isSuccess;
  bool get isFailure => !_isSuccess;

  T? get data => _data;
  Failure? get failure => _failure;
}
