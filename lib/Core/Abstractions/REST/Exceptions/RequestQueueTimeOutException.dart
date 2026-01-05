import '../../Common/AppException.dart';

class RequestQueueTimeOutException extends AppException
{
  RequestQueueTimeOutException(String message) : super(message, StackTrace.current);
}