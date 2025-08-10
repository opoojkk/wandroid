class Result<T> {
  final T? _data;
  final Object? _error;

  Result._(this._data, this._error);

  factory Result.success(T data) => Result._(data, null);
  factory Result.failure(Object error) => Result._(null, error);

  Result<T> onSuccess(void Function(T data) action) {
    if (_error == null && _data != null) {
      action(_data as T);
    }
    return this;
  }

  Result<T> onFailure(void Function(Object error) action) {
    if (_error != null) {
      action(_error!);
    }
    return this;
  }

  bool get isSuccess => _error == null;
  bool get isFailure => _error != null;
}
