import 'package:flutter/services.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/ILoggingService.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/LazyInjected.dart';

class NativeiOSBridging
{
  static const platform = MethodChannel('nativeBridging/Swift');
  final logger = LazyInjected<ILoggingService>();

  Future<void> SendDataToNativeSwift(String value) async
  {
    try
    {
      // Passes 'value' to the native side
      await platform.invokeMethod('passValue', {"logPath": value});
    }
    catch (e, stackTrace)
    {
      logger.Value.LogError(e, stackTrace);
    }
  }
}