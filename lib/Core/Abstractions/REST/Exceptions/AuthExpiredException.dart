

import '../../Common/BaseException.dart';

class AuthExpiredException extends BaseException
{
  AuthExpiredException([ String message = "user access token is expired" ])
      : super(message, StackTrace.current);
}
