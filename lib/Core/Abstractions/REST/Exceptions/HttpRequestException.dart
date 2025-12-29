import '../../Common/AppException.dart';

class HttpRequestException extends AppException
{
    final int? statusCode;

    HttpRequestException(this.statusCode, String message, [Exception? causeException]): super(message, StackTrace.current, causeException);
}
