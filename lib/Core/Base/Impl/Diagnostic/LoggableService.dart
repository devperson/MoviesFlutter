import '../../../Abstractions/Diagnostics/ILoggingService.dart';
import '../Utils/LazyInjected.dart';
import 'ConsoleService.dart';

mixin LoggableService
{
    final consoleImpl = ConsoleServiceImpl();
    final loggingService = LazyInjected<ILoggingService>();
    late ILogging specificLogger;
    bool specificLoggerInitialized = false;

    // void LogMethodStartAuto([Map<String, Object?>? args])
    // {
    //   final calledMethodName = _getPreviousMethodName();
    //   LogMethodStart(calledMethodName, args);
    // }

    void LogMethodStart({String? methodName = null, Map<String, Object?>? args})
    {
        try
        {
          if(methodName == null)
            {
              methodName = _getPreviousMethodName();
            }
            final className = this.runtimeType.toString();
            loggingService.Value.LogMethodStarted(className, methodName, args);
        }
        catch (ex, stackTrace)
        {
          consoleImpl.PrintException(ex, stackTrace);
        }
    }

    void LogMethodFinished(String methodName, [Map<String, Object?>? args])
    {
      try
      {
        final className = this.runtimeType.toString();
        loggingService.Value.LogMethodFinished(className, methodName, args);
      }
      catch (ex, stackTrace)
      {
        consoleImpl.PrintException(ex, stackTrace);
      }
    }

    void LogVirtualBaseMethod([String? methodName = null])
    {
      if(methodName == null)
        methodName = _getPreviousMethodName();

      final className = this.runtimeType.toString();
      this.loggingService.Value.LogMethodStarted2('$className.$methodName() (from base)');
    }

    void InitSpecificlogger(String key)
    {
        if(specificLoggerInitialized == false)
        {
            specificLogger = loggingService.Value.CreateSpecificLogger(key);
            specificLoggerInitialized = true;
        }
    }

    void SpecificLogMessage(String message)
    {
      try
      {
        final className = this.runtimeType.toString();
        specificLogger.Log("$className.$message");
      }
      catch (ex, stackTrace)
      {
        consoleImpl.PrintException(ex, stackTrace);
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
          consoleImpl.PrintException(ex, stackTrace);
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

    String nameof<T>() => T.toString();


    /// Returns the name of the *previous* (calling) method by parsing the current StackTrace.
    ///
    /// IMPORTANT:
    /// - Dart does NOT provide an official API to retrieve method names at runtime.
    /// - This implementation is **best-effort** and intended **ONLY for logging / diagnostics**.
    /// - StackTrace formats differ between Dart VM, Flutter Web, and may change in future versions.
    ///
    /// [skipFrames] defines how many stack frames to skip:
    ///   0 → GetPreviousMethodName itself
    ///   1 → Direct caller (e.g. LogMethod)
    ///   2 → Caller of the logger (e.g. Foo)  ← default & recommended
    ///
    /// The method NEVER throws and always returns a string.
    /// If the method name cannot be determined, `'Unknown'` is returned.
    String _getPreviousMethodName({int skipFrames = 2})
    {
      final trace = StackTrace.current.toString();
      final lines = trace.split('\n');

      if (lines.length <= skipFrames) {
        return 'Unknown';
      }

      final line = lines[skipFrames];

      // Dart VM format
      final vmMatch = RegExp(r'#\d+\s+(.+?)\s+\(').firstMatch(line);
      final vmName = vmMatch?.group(1);
      if (vmName != null && vmName.isNotEmpty)
      {
        final methodName = _extractMethodName(vmName);
        return methodName;
      }

      // Web format
      final webMatch = RegExp(r'at\s+(.+?)\s+\(').firstMatch(line);
      final webName = webMatch?.group(1);
      if (webName != null && webName.isNotEmpty)
      {
        final webMethodName = _extractMethodName(webName);
        return webMethodName;
      }

      return 'Unknown';
    }


    /// Returns the name of the *current* or *calling* method by parsing the current StackTrace.
    ///
    /// IMPORTANT:
    /// - Dart does NOT provide an official API to retrieve method names at runtime.
    /// - This implementation is **best-effort** and intended **ONLY for logging / diagnostics**.
    /// - StackTrace formats differ between Dart VM, Flutter Web, and may change in future versions.
    ///
    /// [level] specifies which stack frame to inspect:
    ///   0 → GetMethodName itself
    ///   1 → Direct caller of GetMethodName
    ///   2 → Caller of the caller
    ///
    /// The method NEVER throws and always returns a string.
    /// If the method name cannot be determined, `'Unknown'` is returned.
    String _getMethodName({int level = 1})
    {
      // Obtain the current stack trace as a string.
      final trace = StackTrace.current.toString();

      // Split the stack trace into individual lines (frames).
      final lines = trace.split('\n');

      // Defensive check: ensure the requested stack frame exists.
      if (lines.length <= level) {
        return 'Unknown';
      }

      // Select the stack frame corresponding to the requested level.
      final line = lines[level];

      // ------------------------------------------------------------
      // Dart VM / Flutter (mobile & desktop) stack trace format:
      //
      //   #1  ClassName.MethodName (file.dart:line:column)
      //
      // We extract `ClassName.MethodName`.
      // ------------------------------------------------------------
      final vmMatch = RegExp(r'#\d+\s+(.+?)\s+\(').firstMatch(line);
      final vmName = vmMatch?.group(1);

      if (vmName != null && vmName.isNotEmpty)
      {
        final methodName = _extractMethodName(vmName);
        return methodName;
      }

      // ------------------------------------------------------------
      // Flutter Web stack trace format:
      //
      //   at ClassName.MethodName (http://.../main.dart.js:line:column)
      //
      // We extract `ClassName.MethodName`.
      // ------------------------------------------------------------
      final webMatch = RegExp(r'at\s+(.+?)\s+\(').firstMatch(line);
      final webName = webMatch?.group(1);

      if (webName != null && webName.isNotEmpty)
      {
        final methodName = _extractMethodName(webName);
        return methodName;
      }

      // Fallback when stack trace parsing fails.
      return 'Unknown';
    }


    /// Extracts the method name from a stack trace symbol.
    ///
    /// Examples:
    ///   `ClassName.MethodName` → `MethodName`
    ///   `MethodName` → `MethodName`
    ///   `<anonymous closure>` → `<anonymous closure>`
    String _extractMethodName(String fullName)
    {
      //stacktrace can contain multiple dot(Class.ChildClass.Method()) so make sure to get last dot
      final lastDotIndex = fullName.lastIndexOf('.');
      if (lastDotIndex == -1 || lastDotIndex == fullName.length - 1)
      {
        return fullName;
      }
      return fullName.substring(lastDotIndex + 1);
    }
}
