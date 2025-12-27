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
class BaseException implements Exception
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

  BaseException(this._message, this._stackTrace, [ this._causedException ]);

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
