

import '../../Common/AppException.dart';

class AuthExpiredException extends AppException
{
  AuthExpiredException([ String message = "user access token is expired" ])
      : super(message, StackTrace.current);
}
