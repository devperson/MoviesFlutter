import 'dart:core';

import 'package:intl/intl.dart';
import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/ILoggingService.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IPlatformOutput.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/LazyInjected.dart';

class MockLoggingService implements ILoggingService
{
  // ---------- constants ----------

  static const String ENTER_TAG = "➡Enter";
  static const String EXIT_TAG = "🏃Exit";
  static const String INDICATOR_TAG = "⏱Indicator_";

  // ---------- state ----------

  final _platformOutput = LazyInjected<IPlatformOutput>();

  @override
  Object? LastError;

  @override
  bool get HasError
  {
    return LastError != null;
  }

  // ---------- helpers ----------
  final DateFormat _timeFormatter = DateFormat("HH:mm:ss");
  String _getFormattedDate()
  {
    final now = DateTime.now();
    final time = _timeFormatter.format(now);
    final micros = now.microsecond.toString().padLeft(6, '0');

    return "$time:$micros";
  }

  // ---------- ILogging ----------

  @override
  void Log(String message)
  {
    _platformOutput.Value.Info("${_getFormattedDate()}_$message");
  }

  @override
  void LogWarning(String message)
  {
    _platformOutput.Value.Warn("${_getFormattedDate()}WARNING: $message");
  }

  // ---------- ILoggingService ----------

  @override
  void LogError(Object ex, StackTrace stacktrace, [String message = "", bool handled = true])
  {
    _platformOutput.Value.Error("ERROR: $message,💥Handled Exception: ${ex.ToExceptionString(stacktrace)}");
  }

  @override
  void TrackError(Object ex, StackTrace stacktrace, [Map<String, String>? data])
  {
    LastError = ex;
    _platformOutput.Value.Error("💥Handled Exception: ${ex.ToExceptionString(stacktrace)}");
  }

  @override
  void LogUnhandledError(Object ex, StackTrace stackTrace)
  {
    LastError = ex;
    _platformOutput.Value.Error("💥Unhandled Exception: ${ex.ToExceptionString(stackTrace)}");
  }

  @override
  void Header(String headerMessage)
  {
    throw UnimplementedError();
  }

  @override
  void LogMethodStarted(String className, String methodName, [List<Object?>? args])
  {
    _platformOutput.Value.Info("${_getFormattedDate()}_$ENTER_TAG $className.$methodName()");
  }

  @override
  void LogMethodStarted2(String methodName)
  {
    _platformOutput.Value.Info("${_getFormattedDate()}_$ENTER_TAG $methodName");
  }

  @override
  void LogMethodFinished(String methodName)
  {
    _platformOutput.Value.Info("${_getFormattedDate()}_$EXIT_TAG $methodName");
  }

  @override
  void LogIndicator(String name, String message)
  {
    throw UnimplementedError();
  }

  // ---------- file / diagnostics ----------

  @override
  Future<List<int>> GetCompressedLogFileBytes(bool getOnlyLastSession) async
  {
    throw UnimplementedError();
  }

  @override
  Future<String> GetSomeLogTextAsync() async
  {
    throw UnimplementedError();
  }

  @override
  Future<String> GetLogsFolder()
  {
    throw UnimplementedError();
  }

  @override
  String GetCurrentLogFileName()
  {
    throw UnimplementedError();
  }

  @override
  Future<List<int>> GetLastSessionLogBytes() async
  {
    throw UnimplementedError();
  }

  @override
  ILogging CreateSpecificLogger(String key)
  {
    throw UnimplementedError();
  }

  @override
  Future<void> InitAsync() async
  {

  }
}
