import '../../../Abstractions/Diagnostics/IFileLogger.dart';

class MockFileLogger implements IFileLogger
{
  @override
  void Error(String Message) {
    // TODO: implement Error
  }

  @override
  Future<List<int>?> GetCompressedLogsSync(bool GetOnlyLastSession) {
    // TODO: implement GetCompressedLogsSync
    throw UnimplementedError();
  }

  @override
  String GetCurrentLogFileName() {
    // TODO: implement GetCurrentLogFileName
    throw UnimplementedError();
  }

  @override
  Future<List<String>> GetLogListAsync() {
    // TODO: implement GetLogListAsync
    throw UnimplementedError();
  }

  @override
  String GetLogsFolder() {
    // TODO: implement GetLogsFolder
    throw UnimplementedError();
  }

  @override
  void Info(String Message) {
    // TODO: implement Info
  }

  @override
  void Init() {
    // TODO: implement Init
  }

  @override
  void Warn(String Message) {
    // TODO: implement Warn
  }
  
}