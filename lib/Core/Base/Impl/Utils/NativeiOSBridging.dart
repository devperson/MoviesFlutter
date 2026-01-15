import 'package:flutter/services.dart';
import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/ILoggingService.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/LazyInjected.dart';

class NativeiOSBridging
{
  static const platform = MethodChannel('nativeBridging/Swift');
  final logger = LazyInjected<ILoggingService>();

  Future<void> SendDataToNativeSwift(dynamic arguments, {bool logError = true}) async
  {
    try
    {
      // Passes 'value' to the native side
      await platform.invokeMethod('passValue', arguments);
    }
    catch (e, stackTrace)
    {
      if(logError)
        logger.Value.LogError(e, stackTrace);
      else
        print(e.ToExceptionString(stackTrace));

    }
  }


}