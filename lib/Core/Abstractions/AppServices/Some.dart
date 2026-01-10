import 'dart:core';

import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';

abstract interface class ISome
{
  bool get Success;
  AppException? get Error;
}

class Some<T> implements ISome
{
  final T? _Value;
  final AppException? _error;

  @override
  AppException? get Error => _error;

  @override
  bool get Success=>_Value != null;

  T get ValueOrThrow
  {
    if (_Value == null)
    {
      throw StateError("value is null");
    }

    return _Value as T;
  }

  Some._(this._Value, [ this._error ]);

  static Some<T> FromValue<T>(T? Value)
  {
    return Some<T>._(Value);
  }

  static Some<T> FromError<T>(AppException Ex)
  {
    return Some<T>._(null, Ex);
  }
}