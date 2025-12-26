import '../../Common/BaseException.dart';

class HttpConnectionException extends BaseException
{
    HttpConnectionException(String message, [Exception? causeException]): super(message, StackTrace.current, causeException);
}
