import '../../../Abstractions/Diagnostics/IErrorTrackingService.dart';
import '../../../Abstractions/Diagnostics/IFileLogger.dart';
import '../../../Abstractions/Diagnostics/ILoggingService.dart';
import '../../../Abstractions/Diagnostics/IPlatformOutput.dart';
import '../../../Abstractions/Essentials/IPreferences.dart';
import '../Utils/LazyInjected.dart';

class AppLoggingService implements ILoggingService
{
    int RowNumber = 0;
    final String ENTER_TAG = "➡Enter";
    final String EXIT_TAG = "🏃Exit";
    final String INDICATOR_TAG = "⏱Indicator_";
    final String HANDLED_ERROR = "💥Handled Exception: ";
    final String UNHANDLED_ERROR = "💥Crash Unhandled: ";

    int AppLaunchCount = 0;
    @override
    Exception? LastError;
    @override
    bool get HasError => LastError != null;

    final _errorTrackingService = LazyInjected<IErrorTrackingService>();
    final _fileLogger = LazyInjected<IFileLogger>();
    final _preferences = LazyInjected<IPreferences>();
    final _platformConsole = LazyInjected<IPlatformOutput>();

    AppLoggingService()
    {
        _errorTrackingService.Value.OnServiceError.AddListener(ErrorTrackingService_OnError);

        _fileLogger.Value.Init();
        AppLaunchCount = GetLaunchCount();
    }

    void ErrorTrackingService_OnError(Object? ex)
    {
        if (ex is Exception)
            LogError(ex, "Error happens in IErrorTrackingService", true);
    }

    @override
    void TrackError(Exception ex, [Map<String, String>? data])
    {
        TrackInternal(ex, true, data);
    }

    @override
    void LogUnhandledError(Exception ex)
    {
        TrackInternal(ex, false);
    }

    void TrackInternal(Exception ex, bool handled, [Map<String, String>? data])
    {
        SafeCall(() {
            LastError = ex;
            LogError(ex, "", handled);

            if (handled)
            {
                // In Dart, async operations don't block, similar to GlobalScope.launch
                Future(() {
                    try
                    {
                        _errorTrackingService.Value.TrackError(ex, AdditionalData: null);
                    }
                    catch (ex)
                    {
                        if (ex is Exception)
                            LogError(ex, "Failed to track error");
                    }
                });
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
    void LogError(Exception ex, [String message = "", bool handled = true])
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
            formatted.write(ex.toString()); // Dart doesn't have stackTraceToString on Exception directly usually, but toString captures message. For stacktrace need the stacktrace object.

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
    void LogMethodStarted(String className, String methodName, [List<Object?>? args])
    {
        SafeCall(() {
            final debugMethodName = GetMethodNameWithParameters(className, methodName, args);
            Log("$ENTER_TAG $debugMethodName");
        });
    }

    @override
    void LogMethodFinished(String methodName)
    {
        Log("$EXIT_TAG $methodName");
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
    String GetLogsFolder()
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
        catch (ex)
        {
            if (ex is Exception)
                LogError(ex, "Failed to get App Log");
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
        catch (ex)
        {
            if (ex is Exception)
                LogError(ex, "Failed to get App Log");
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
            _platformConsole.Value.Error(stackTrace.toString());
        }
    }

    String GetMethodNameWithParameters(String className, String? funcName, [List<Object?>? args])
    {
        final itemsCount = 10;
        final argsString = args?.map((arg) {
            if (arg == null) return "null";

            if (arg is Iterable) // List, Set, etc.
            {
                final typeName = arg.runtimeType.toString();
                final preview = arg.take(itemsCount).join(", ");
                return "$typeName[${arg.length}] { $preview }";
            }
            // Array in Dart is List mostly, or specific TypedData, treated as Iterable usually
            else
            {
                final typeName = arg.runtimeType.toString();
                final valueString = arg.toString();
                return "$typeName: $valueString";
            }
        }).join(", ");

        return "$className.${funcName ?? "?"}($argsString)";
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
    void LogMethodStarted(String className, String methodName, [List<Object?>? args])
    {
        if (canLog)
        {
            logger.LogMethodStarted(className, methodName, args);
        }
    }
}
