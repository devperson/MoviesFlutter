import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';

abstract interface class ILogging
{
  void Log(String Message);
  void LogWarning(String Message);
  void LogMethodStarted(String ClassName, String MethodName, [Map<String, Object?>? args]);
  void LogMethodFinished(String ClassName, String MethodName, [Map<String, Object?>? args]);
}

abstract interface class ILoggingService extends ILogging
{
  Object? get LastError;
  set LastError(Object? Value);
  bool get HasError;
  StackTrace? LastStackTrace;
  bool get IsInited;

  Future<void> InitAsync();
  void LogMethodStarted2(String MethodName);
  void Header(String HeaderMessage);
  void LogIndicator(String Name, String Message);
  void LogError(Object Ex, StackTrace stackTrace, [String Message = "", bool Handled = true ]);
  void LogException(AppException exception);
  void TrackError(Object Ex, StackTrace stackTrace, [Map<String, String>? Data]);
  void LogUnhandledError(Exception Ex, StackTrace stackTrace);
  Future<List<int>?> GetCompressedLogFileBytes(bool GetOnlyLastSession);
  Future<String> GetSomeLogTextAsync();
  Future<String> GetLogsFolder();
  String GetCurrentLogFileName();
  Future<List<int>?> GetLastSessionLogBytes();
  ILogging CreateSpecificLogger(String Key);
}

abstract class SpecificLoggingKeys
{
  static const String LogEssentialServices = 'LogEssentialServices';
  static const String LogUIServices        = 'LogUIServices';
  static const String LogUIControlsKey     = 'LogUIControlsKey';
  static const String LogUIPageKey         = 'LogUIPageKey';
  static const String LogUINavigationKey   = 'LogUINavigationKey';
  static const String LogUITableCells      = 'LogUITableCells';
}
