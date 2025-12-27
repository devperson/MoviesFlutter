import '../../../Abstractions/Diagnostics/ILoggingService.dart';
import '../Utils/LazyInjected.dart';

class LoggableService
{
    final loggingService = LazyInjected<ILoggingService>();
    late ILogging specificLogger;
    bool specificLoggerInitialized = false;

    void LogMethodStart(String methodName, [List<Object?>? args])
    {
        try
        {
            final className = this.runtimeType.toString();
            loggingService.Value.LogMethodStarted(className, methodName, args);
        }
        catch (ex, stackTrace)
        {
            print(stackTrace.toString());
        }
    }

    void InitSpecificlogger(String key)
    {
        if(specificLoggerInitialized == false)
        {
            specificLogger = loggingService.Value.CreateSpecificLogger(key);
            specificLoggerInitialized = true;
        }
    }

    void SpecificLogMethodStart(String methodName, [List<Object?>? args])
    {
        try
        {
            final className = this.runtimeType.toString();
            specificLogger.LogMethodStarted(className, methodName, args);
        }
        catch (ex, stackTrace)
        {
            print(stackTrace.toString());
        }
    }
}
