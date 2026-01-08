import 'dart:core';

import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';

class Some<T>
{
  final T? _Value;
  final AppException? Error;

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

  static Some<T> FromError<T>(AppException Ex)
  {
    return Some<T>._(null, Ex);
  }
}