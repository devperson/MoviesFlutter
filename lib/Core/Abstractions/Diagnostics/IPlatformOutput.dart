abstract interface class IPlatformOutput
{
    bool IsInited = false;
    void Init();
    void Info(String message);
    void Warn(String message);
    void Error( String message, {
      Object? error,
      StackTrace? stackTrace,
    });
}
