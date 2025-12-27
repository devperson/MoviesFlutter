abstract interface class ILogging
{
  void Log(String Message);
  void LogWarning(String Message);
  void LogMethodStarted(String ClassName, String MethodName, [ List<Object?>? Args ]);
}

abstract interface class ILoggingService extends ILogging
{
  Exception? get LastError;
  set LastError(Exception? Value);
  bool get HasError;

  void LogMethodStarted2(String MethodName);
  void Header(String HeaderMessage);
  void LogMethodFinished(String MethodName);
  void LogIndicator(String Name, String Message);
  void LogError(Exception Ex, [String Message = "", bool Handled = true ]);
  void TrackError(Exception Ex, [Map<String, String>? Data]);
  void LogUnhandledError(Exception Ex);
  Future<List<int>?> GetCompressedLogFileBytes(bool GetOnlyLastSession);
  Future<String> GetSomeLogTextAsync();
  String GetLogsFolder();
  String GetCurrentLogFileName();
  Future<List<int>?> GetLastSessionLogBytes();
  ILogging CreateSpecificLogger(String Key);
}
