import 'dart:io';


import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';
import 'package:simple_native_logger/simple_native_logger.dart';
import '../../../Abstractions/Diagnostics/IPlatformOutput.dart';
//import 'dart:developer' as dev;

class F_PlatformOutput implements IPlatformOutput
{
  final _TAG = "AppLogger";
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
    if(IsUnitTest)
      {
        print(message);
      }
    else
      {
        nativeLogger.i(message);
      }

  }

  @override
  void Warn(String message)
  {
    if(IsUnitTest)
    {
      print(message);
    }
    else
      {
        nativeLogger.w(message);
        //dev.log(message, name: _TAG, level: warningLevel);
      }

  }

  @override
  void Error(String message, { Object? error, StackTrace? stackTrace, bool isHandled = true})
  {
    if(IsUnitTest)
      {
        if(error == null)
          {
            print(message);
          }
        else
          {
             final exception = error.ToExceptionString(stackTrace!);
             print(exception);
          }
      }
    else
      {
        if(error == null)
          {
            nativeLogger.e(message);
          }
        else
          {
            final exception = error.ToExceptionString(stackTrace!);
            nativeLogger.e("$message: $exception");
          }
        //final errlevel = isHandled ? errorLevel : fatalLevel;
        //dev.log(message, name: _TAG, level: errlevel, error: error, stackTrace: stackTrace,);
      }

  }

  bool get IsUnitTest
  {
    return const bool.fromEnvironment('dart.vm.product') == false
        && Platform.environment.containsKey('FLUTTER_TEST');
  }


}