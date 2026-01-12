import '../../../Abstractions/Diagnostics/IErrorTrackingService.dart';
import '../../../Abstractions/Diagnostics/IFileLogger.dart';
import '../../../Abstractions/Diagnostics/ILoggingService.dart';
import '../../../Abstractions/Diagnostics/IPlatformOutput.dart';
import '../../../Abstractions/Essentials/IPreferences.dart';
import '../Utils/LazyInjected.dart';
import '../../../Abstractions/Common/AppException.dart';

class F_LoggingService implements ILoggingService
{
    int RowNumber = 0;
    final String ENTER_TAG = "➡Enter";
    final String EXIT_TAG = "🏃Exit";
    final String INDICATOR_TAG = "⏱Indicator_";
    final String HANDLED_ERROR = "💥Handled Exception: ";
    final String UNHANDLED_ERROR = "💥Crash Unhandled: ";

    int AppLaunchCount = 0;
    @override
    Object? LastError;
    @override
    bool get HasError => LastError != null;

    final _errorTrackingService = LazyInjected<IErrorTrackingService>();
    final _fileLogger = LazyInjected<IFileLogger>();
    final _preferences = LazyInjected<IPreferences>();
    final _platformConsole = LazyInjected<IPlatformOutput>();
    var _isInited = false;

    @override
    bool get IsInited => _isInited;

    @override
    Future<void> InitAsync() async
    {
      if(_isInited) {
        _platformConsole.Value.Warn("F_LoggingService.InitAsync(): Ignoring this method because it is already initilized");
        return;
      }
      _isInited = true;

      //_errorTrackingService.Value.OnServiceError.AddListener(ErrorTrackingService_OnError);
      await _fileLogger.Value.InitAsync();
      _platformConsole.Value.Init();
      //AppLaunchCount = GetLaunchCount();
    }

    void ErrorTrackingService_OnError(Object? ex)
    {
      if(ex != null)
        LogError(ex, StackTrace.current, "Error happens in IErrorTrackingService", true);
    }

    @override
    void TrackError(Object ex, StackTrace stackTrace, [Map<String, String>? data])
    {
        TrackInternal(ex, stackTrace, true, data);
    }

    @override
    void LogUnhandledError(Object ex, StackTrace stackTrace)
    {
        TrackInternal(ex, stackTrace, false);
    }

    void TrackInternal(Object ex, StackTrace stackTrace, bool handled, [Map<String, String>? data])
    {
        SafeCall(() {
            LastError = ex;
            LogError(ex, stackTrace, "", handled);

            if (handled)
            {
              try
              {
                _errorTrackingService.Value.TrackError(ex, stackTrace, additionalData: null);
              }
              catch (ex, stackTrace)
              {
                LogError(ex, stackTrace, "Failed to track error");
              }
            }
        });
    }

    @override
    void Log(String message)
    {
        SafeCall(() {
            RowNumber++;
            final tag = GetLogAppTag(AppLaunchCount, RowNumber);
            final formatted = "$tag INFO:$message";
            _fileLogger.Value.Info(formatted);
            _platformConsole.Value.Info(formatted);
        });
    }

    @override
    void LogWarning(String message)
    {
        SafeCall(() {
            RowNumber++;
            final tag = GetLogAppTag(AppLaunchCount, RowNumber);
            final formatted = "$tag WARNING:$message";
            _fileLogger.Value.Warn(formatted);
            _platformConsole.Value.Warn(formatted);
        });
    }

    @override
    void LogError(Object ex, StackTrace stackTrace, [String message = "", bool handled = true])
    {
        SafeCall(() {
            RowNumber++;
            final tag = GetLogAppTag(AppLaunchCount, RowNumber);

            final formatted = StringBuffer();
            formatted.write("$tag ERROR: ");
            if (handled)
                formatted.write(HANDLED_ERROR);
            else
                formatted.write(UNHANDLED_ERROR);

            if (message.isNotEmpty)
            {
                formatted.write(": $message - ");
            }
            formatted.write(ex.ToExceptionString(stackTrace));

            _fileLogger.Value.Warn(formatted.toString());
            _platformConsole.Value.Error(formatted.toString());
        });
    }

    @override
    ILogging CreateSpecificLogger(String key)
    {
        final specLogger = ConditionalLogger(key, this, _preferences.Value);
        return specLogger;
    }

    @override
    void Header(String headerMessage)
    {
        SafeCall(() {
            _fileLogger.Value.Info(headerMessage);
            _platformConsole.Value.Info(headerMessage);
        });
    }

    @override
    void LogMethodStarted2(String methodName) {
       Log("$ENTER_TAG $methodName");
    }

    @override
    void LogMethodStarted(String className, String methodName, [Map<String, Object?>? args])
    {
        SafeCall(() {
            final debugMethodName = GetMethodNameWithParameters(className, methodName, args);
            Log("$ENTER_TAG $debugMethodName");
        });
    }

    @override
    void LogMethodFinished(String className, String methodName, [Map<String, Object?>? args])
    {
      SafeCall(() {
        final debugMethodName = GetMethodNameWithResult(className, methodName, args);
        Log("$EXIT_TAG $debugMethodName");
      });
    }

    @override
    void LogIndicator(String name, String message)
    {
        SafeCall(() {
            final msg = "********************************${INDICATOR_TAG}${name}*************************************";
            _fileLogger.Value.Info(msg);
            _platformConsole.Value.Info(msg);
        });
    }

    @override
    Future<String> GetSomeLogTextAsync() async
    {
        final lines = await _fileLogger.Value.GetLogListAsync();
        return lines.join("\n");
    }

    @override
    Future<String> GetLogsFolder()
    {
        return _fileLogger.Value.GetLogsFolder();
    }

    @override
    String GetCurrentLogFileName()
    {
       return _fileLogger.Value.GetCurrentLogFileName();
    }

    @override
    Future<List<int>?> GetLastSessionLogBytes() async
    {
        try
        {
            return await _fileLogger.Value.GetCompressedLogsSync(true);
        }
        catch (ex, stackTrace)
        {
            LogError(ex, stackTrace, "Failed to get App Log");
            return null;
        }
    }

    @override
    Future<List<int>?> GetCompressedLogFileBytes(bool getOnlyLastSession) async
    {
        try
        {
            return await _fileLogger.Value.GetCompressedLogsSync(getOnlyLastSession);
        }
        catch (ex, stackTrace)
        {
            LogError(ex, stackTrace, "Failed to get App Log");
            return null;
        }
    }

    int GetLaunchCount()
    {
        var launchCount = _preferences.Value.Get<int>("AppLaunchCount", 0);
        launchCount += 1; // Logic slightly adapted: original kotlin logic incremented if not null, but get returns default if not found.

        _preferences.Value.Set("AppLaunchCount", launchCount);
        return launchCount;
    }

    String GetLogAppTag(int appLaunchCount, int rowNumber)
    {
        final now = DateTime.now();

        final millis = now.millisecond;
        final millisStr = millis.toString().padLeft(3, '0');

        final timeStr = "${now.hour.toString().padLeft(2, '0')}:${
            now.minute.toString().padLeft(2, '0')}:${
            now.second.toString().padLeft(2, '0')}.$millisStr";

        return "S($appLaunchCount)_R($rowNumber)_D($timeStr)";
    }

    void SafeCall(void Function() action)
    {
        try
        {
            action();
        }
        catch (ex, stackTrace)
        {
          _platformConsole.Value.Error(ex.ToExceptionString(stackTrace));
        }
    }

    String GetMethodNameWithParameters(String className, String funcName, Map<String, Object?>? args)
    {
      final itemsCount = 10;

      var argsString = args?.entries.map((e) {
        final value = e.value;

        if (value == null) {
          return '${e.key}: null';
        }

        if (value is Iterable) {
          final preview = value.take(itemsCount).join(', ');
          return '${e.key}: ${value.runtimeType}[${value.length}] { $preview }';
        }

        return '${e.key}: $value';
      }).join(', ');

      if(argsString == null)
        argsString = '';

      return '$className.$funcName($argsString)';
    }

    String GetMethodNameWithResult(String className, String funcName, Map<String, Object?>? args)
    {
      final itemsCount = 10;
      final argsString = args?.entries.map((e) {
        final value = e.value;

        if (value == null) {
          return '${e.key}: null';
        }

        if (value is Iterable) {
          final preview = value.take(itemsCount).join(', ');
          return '${e.key}: ${value.runtimeType}[${value.length}] { $preview }';
        }

        return '${e.key}: $value';
      }).join(', ');

      return "$className.$funcName(); $argsString";
    }


}

class ConditionalLogger implements ILogging
{
    final String key;
    final ILogging logger;
    final IPreferences preferences;
    late final bool canLog;

    ConditionalLogger(this.key, this.logger, this.preferences)
    {
         canLog = preferences.Get(key, false);
    }

    @override
    void Log(String message)
    {
        if (canLog)
        {
            logger.Log(message);
        }
    }

    @override
    void LogWarning(String message)
    {
        if (canLog)
        {
            logger.LogWarning(message);
        }
    }

    @override
    void LogMethodStarted(String className, String methodName, [Map<String, Object?>? args])
    {
        if (canLog)
        {
            logger.LogMethodStarted(className, methodName, args);
        }
    }

  @override
  void LogMethodFinished(String className, String methodName, [Map<String, Object?>? args])
  {
    if (canLog)
    {
      logger.LogMethodFinished(className, methodName, args);
    }
  }
}
