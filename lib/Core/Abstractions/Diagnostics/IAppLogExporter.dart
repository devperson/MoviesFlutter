abstract class IAppLogExporter
{
  Future<LogSharingResult> ShareLogs();
}

class LogSharingResult
{
  final bool Success;
  final Exception? ExceptionValue;

  LogSharingResult(this.Success, { this.ExceptionValue });
}
