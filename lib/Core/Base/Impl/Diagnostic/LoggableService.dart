import '../../../Abstractions/Diagnostics/ILogging.dart';
import '../../../Abstractions/Diagnostics/ILoggingService.dart';
import 'package:get_it/get_it.dart';

class LoggableService
{
    ILoggingService get loggingService => GetIt.I<ILoggingService>();
    lateinit ILogging specificLogger;
    bool specificLoggerInitialized = false;

    void LogMethodStart(String methodName, [List<Object?>? args])
    {
        try
        {
            final loggingService = GetIt.I<ILoggingService>();
            final className = this.runtimeType.toString();
            loggingService.LogMethodStarted(className, methodName, args);
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
            specificLogger = loggingService.CreateSpecificLogger(key);
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
