import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';

class ServerApiException extends AppException
{
    ServerApiException(String message) : super(message, StackTrace.current);
}
