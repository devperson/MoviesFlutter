abstract interface class IFileLogger
{
  Future<void> InitAsync();

  void Info(String Message);

  void Warn(String Message);

  void Error(String Message);

  Future<List<int>?> GetCompressedLogsSync(bool GetOnlyLastSession);

  Future<List<String>> GetLogListAsync();

  Future<String> GetLogsFolder();

  String GetCurrentLogFileName();
}
