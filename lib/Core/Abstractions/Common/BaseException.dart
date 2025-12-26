class BaseException implements Exception
{
  final String _message;
  final StackTrace _stackTrace;
  final Exception? _causedException;

  String get Message => _message;
  StackTrace get ErrorStackTrace => _stackTrace;
  Exception? get CausedException => _causedException;

  BaseException(this._message, this._stackTrace, [ this._causedException ]);

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
