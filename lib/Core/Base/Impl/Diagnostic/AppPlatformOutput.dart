import '../../../Abstractions/Diagnostics/IPlatformOutput.dart';
import 'dart:developer' as dev;

class AppPlatformOutput implements IPlatformOutput
{
  final msgLevel = 800;
  final warningLevel = 900;
  final errorLevel = 1000;
  final fatalLevel = 1200;



  @override
  void Info(String message)
  {
    dev.log(message, level: msgLevel);
  }

  @override
  void Warn(String message)
  {
    dev.log(message, level: warningLevel);
  }

  @override
  void Error(String message, { Object? error, StackTrace? stackTrace, bool isHandled = true})
  {
     final errlevel = isHandled ? errorLevel : fatalLevel;
     dev.log(message, name: 'ERROR', level: errlevel, error: error, stackTrace: stackTrace,);
  }

}