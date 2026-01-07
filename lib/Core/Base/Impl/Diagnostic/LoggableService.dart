
import '../../../Abstractions/Diagnostics/ILoggingService.dart';
import '../Utils/LazyInjected.dart';
import '../../../Abstractions/Common/AppException.dart';

mixin LoggableService
{
    final loggingService = LazyInjected<ILoggingService>();
    late ILogging specificLogger;
    bool specificLoggerInitialized = false;

    void LogMethodStart(String methodName, [Map<String, Object?>? args])
    {
        try
        {
            final className = this.runtimeType.toString();
            loggingService.Value.LogMethodStarted(className, methodName, args);
        }
        catch (ex, stackTrace)
        {
          print(ex.ToExceptionString(stackTrace));
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

    void SpecificLogMethodStart(String methodName, [Map<String, Object?>? args])
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

    void SpecificLogMethodFinished(String methodName, [Map<String, Object?>? args])
    {
      try
      {
        final className = this.runtimeType.toString();
        specificLogger.LogMethodFinished(className, methodName, args);
      }
      catch (ex, stackTrace)
      {
        print(stackTrace.toString());
      }
    }
}
