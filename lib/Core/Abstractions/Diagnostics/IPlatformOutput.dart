abstract interface class IPlatformOutput
{
    void Info(String message);
    void Warn(String message);
    void Error( String message, {
      Object? error,
      StackTrace? stackTrace,
    });
}
