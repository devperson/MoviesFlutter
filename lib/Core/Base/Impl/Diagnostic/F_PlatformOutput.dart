import 'dart:ffi';
import 'dart:io';


import 'package:colorid_print/colorid_print.dart' show ColoridPrint;
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/CommonTAG.dart';
import 'package:simple_native_logger/simple_native_logger.dart';
import '../../../Abstractions/Diagnostics/IPlatformOutput.dart';
//import 'dart:developer' as dev;

class F_PlatformOutput implements IPlatformOutput
{
  final _TAG = CommonTAG.LOGGER_TAG;
  final msgLevel = 800;
  final warningLevel = 900;
  final errorLevel = 1000;
  final fatalLevel = 1200;
  late final SimpleNativeLogger nativeLogger;

  @override
  bool IsInited = false;

  @override
  void Init()
  {
     SimpleNativeLogger.init();
     nativeLogger = SimpleNativeLogger(tag: _TAG);
     IsInited = true;
  }

  @override
  void Info(String message)
  {
    _print(message, blue: true);
  }

  @override
  void Warn(String message)
  {
    _print(message, yellow: true);
  }

  @override
  void Error(String message, { Object? error, StackTrace? stackTrace, bool isHandled = true})
  {
    if(error == null)
    {
      //print(message);
      _print(message, red: true);
    }
    else
    {
      final exception = error.ToExceptionString(stackTrace!);
      //print(exception);
      _print("$message: $exception", red: true);
    }

  }

  void _print(String message, { bool red = false, yellow = false, blue= true})
  {
    if(red)
    {
      _redPrint(message);
      if(!IsUnitTest)
        nativeLogger.e(message);
    }
    else if(yellow)
      {
        _yellowPrint(message);
        if(!IsUnitTest)
          nativeLogger.w(message);
      }
    else
      {
        _bluePrint(message);
        if(!IsUnitTest)
          nativeLogger.i(message);
      }
  }

  void _redPrint(String message)
  {
    ColoridPrint.redPrint("$_TAG: $message");
  }

  void _yellowPrint(String message)
  {
    ColoridPrint.yellowPrint("$_TAG: $message");
  }

  void _bluePrint(String message)
  {
    ColoridPrint.bluePrint("$_TAG: $message");
  }

  bool get IsUnitTest
  {
    return const bool.fromEnvironment('dart.vm.product') == false
        && Platform.environment.containsKey('FLUTTER_TEST');
  }


}