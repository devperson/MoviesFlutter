import '../../Core/Abstractions/Diagnostics/ILoggingService.dart';

class LoggingService implements ILoggingService
{
  @override
  Exception? LastError;

  @override
  ILogging CreateSpecificLogger(String Key) {
    // TODO: implement CreateSpecificLogger
    throw UnimplementedError();
  }

  @override
  Future<List<int>?> GetCompressedLogFileBytes(bool GetOnlyLastSession) {
    // TODO: implement GetCompressedLogFileBytes
    throw UnimplementedError();
  }

  @override
  String GetCurrentLogFileName() {
    // TODO: implement GetCurrentLogFileName
    throw UnimplementedError();
  }

  @override
  Future<List<int>?> GetLastSessionLogBytes() {
    // TODO: implement GetLastSessionLogBytes
    throw UnimplementedError();
  }

  @override
  String GetLogsFolder() {
    // TODO: implement GetLogsFolder
    throw UnimplementedError();
  }

  @override
  Future<String> GetSomeLogTextAsync() {
    // TODO: implement GetSomeLogTextAsync
    throw UnimplementedError();
  }

  @override
  // TODO: implement HasError
  bool get HasError => throw UnimplementedError();

  @override
  void Header(String HeaderMessage) {
    // TODO: implement Header
  }

  @override
  void Log(String Message) {
    // TODO: implement Log
  }

  @override
  void LogError(Exception Ex, [String Message = "", bool Handled = true]) {
    // TODO: implement LogError
  }

  @override
  void LogIndicator(String Name, String Message) {
    // TODO: implement LogIndicator
  }

  @override
  void LogMethodFinished(String MethodName) {
    // TODO: implement LogMethodFinished
  }

  @override
  void LogMethodStarted(String ClassName, String MethodName, [List<Object?>? Args]) {
    // TODO: implement LogMethodStarted
  }

  @override
  void LogMethodStarted2(String MethodName) {
    // TODO: implement LogMethodStarted2
  }

  @override
  void LogUnhandledError(Exception Ex) {
    // TODO: implement LogUnhandledError
  }

  @override
  void LogWarning(String Message) {
    // TODO: implement LogWarning
  }

  @override
  void TrackError(Exception Ex, [Map<String, String>? Data]) {
    // TODO: implement TrackError
  }

}