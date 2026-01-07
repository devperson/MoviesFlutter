import '../../../Abstractions/Diagnostics/ILoggingService.dart';
import '../Utils/LazyInjected.dart';
import 'ConsoleService.dart';

mixin LoggableService
{
    final consoleImpl = ConsoleServiceImpl();
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
          consoleImpl.PrintException(ex, stackTrace);
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
          consoleImpl.PrintException(ex, stackTrace);
        }
    }


}
