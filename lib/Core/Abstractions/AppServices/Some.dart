import 'dart:core';

class Some<T>
{
  final T? _Value;
  final Exception? Error;

  bool get Success
  {
    return _Value != null;
  }

  T get ValueOrThrow
  {
    if (_Value == null)
    {
      throw StateError("value is null");
    }

    return _Value as T;
  }

  Some._(this._Value, [ this.Error ]);

  static Some<T> FromValue<T>(T? Value)
  {
    return Some<T>._(Value);
  }

  static Some<T> FromError<T>(Exception Ex)
  {
    return Some<T>._(null, Ex);
  }
}