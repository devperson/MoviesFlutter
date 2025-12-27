import 'package:movies_flutter/Core/Abstractions/Common/BaseException.dart';

class ServerApiException extends BaseException
{
    ServerApiException(String message) : super(message, StackTrace.current);
}
