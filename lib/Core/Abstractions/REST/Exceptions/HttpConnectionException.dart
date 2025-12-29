import '../../Common/AppException.dart';

class HttpConnectionException extends AppException
{
    HttpConnectionException(String message, [Exception? causeException]): super(message, StackTrace.current, causeException);
}
