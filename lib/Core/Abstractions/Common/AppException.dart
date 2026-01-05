/// Base exception class that emulates Kotlin `Throwable` / C# `Exception` behavior.
/// Dart exceptions do not automatically store stack traces or causes.
/// This class centralizes:
/// - the error message
/// - the captured stack trace
/// - an optional caused / inner exception
///
/// The string representation intentionally follows a Kotlin / C#–style format,
/// because it is clear, and looks good in logs and diagnostic output.
///
/// All custom exceptions in the project should extend this class.
class AppException implements Exception
{
  /// Error message describing the failure.
  final String _message;
  /// Stack trace captured at the moment the exception was created.
  final StackTrace _stackTrace;
  /// Optional inner / caused exception (Kotlin `cause`, C# `InnerException`).
  final Exception? _causedException;

  String get Message => _message;
  StackTrace get ErrorStackTrace => _stackTrace;
  Exception? get CausedException => _causedException;

  AppException.Throw(String message) : this(message, StackTrace.current);
  AppException(this._message, this._stackTrace, [ this._causedException ]);

  /// Returns a string representation in a Kotlin / C#–style format:
  ///
  /// `{ExceptionType}: {Message}`
  /// `{StackTrace}`
  /// `Caused by: {InnerException}` (if present)
  ///
  /// This format is optimized for readability in logs and debugging tools.
  @override
  String toString()
  {
    final buffer = StringBuffer();
    buffer.write("$runtimeType: $_message\n$_stackTrace");

    if (_causedException != null)
    {
      buffer.write("\nCaused by: $_causedException");
    }

    return buffer.toString();
  }
}

extension ExceptionExtensions on Exception
{
  AppException ToAppException(StackTrace stackTrace)
  {
    return AppException("App EXCEPTION occurred, please check caused(internal) exception", stackTrace, this);
  }
}

extension ObjectExtensions on Object
{
  String ToExceptionString(StackTrace stackTrace)
  {
    final appException = this.ToAppException(stackTrace);
    return appException.toString();
  }

  AppException ToAppException(StackTrace stackTrace)
  {
    if(this is AppException)
      {
        //no need to use stackTrace because AppException has stackTrace internally
        return this as AppException;
      }
      else if(this is Exception)
      {
        //convert Exception to AppException
        return (this as Exception).ToAppException(stackTrace);
      }
      else
      {
        //convert ERROR to AppException
        return AppException("App ERROR occurred: $this", stackTrace);
      }
  }
}

