import '../../Common/BaseException.dart';

class HttpRequestException extends BaseException
{
    final int? statusCode;

    HttpRequestException(this.statusCode, String message, [Exception? causeException]): super(message, StackTrace.current, causeException);
}
