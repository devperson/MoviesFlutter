import '../../Common/AppException.dart';

class HttpConnectionException extends AppException
{
    HttpConnectionException(String message, {Exception? causeException, StackTrace? causedStackTrace}): super(message, StackTrace.current, causeException, causedStackTrace);
}
