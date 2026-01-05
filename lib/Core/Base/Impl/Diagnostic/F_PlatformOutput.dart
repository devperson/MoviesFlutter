import 'dart:io';

import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';

import '../../../Abstractions/Diagnostics/IPlatformOutput.dart';
import 'dart:developer' as dev;

class F_PlatformOutput implements IPlatformOutput
{
  final msgLevel = 800;
  final warningLevel = 900;
  final errorLevel = 1000;
  final fatalLevel = 1200;



  @override
  void Info(String message)
  {
    if(IsUnitTest)
      {
        print(message);
      }
    else
      {
        dev.log(message, level: msgLevel);
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
        dev.log(message, level: warningLevel);
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
        final errlevel = isHandled ? errorLevel : fatalLevel;
        dev.log(message, name: 'ERROR', level: errlevel, error: error, stackTrace: stackTrace,);
      }

  }

  bool get IsUnitTest
  {
    return const bool.fromEnvironment('dart.vm.product') == false
        && Platform.environment.containsKey('FLUTTER_TEST');
  }
}