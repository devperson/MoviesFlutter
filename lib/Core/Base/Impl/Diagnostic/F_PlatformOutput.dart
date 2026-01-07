import 'dart:io';
import 'package:logger/logger.dart';
import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/CommonTAG.dart';
import 'package:simple_native_logger/simple_native_logger.dart';
import '../../../Abstractions/Diagnostics/IPlatformOutput.dart';

class F_PlatformOutput implements IPlatformOutput
{
  final _TAG = CommonTAG.LOGGER_TAG;
  late final SimpleNativeLogger nativeLogger;//platform console: logcat, xcode console, etc
  late final flutterLogger;//flutter run/debug console

  @override
  bool IsInited = false;

  F_PlatformOutput()
  {
    flutterLogger = Logger(
      printer: PrettyPrinter(
        methodCount: 0, // No stacktrace for cleaner logs
        colors: true,   // True for terminal colors
        printEmojis: true,
      ),
    );
    SimpleNativeLogger.init();
    nativeLogger = SimpleNativeLogger(tag: _TAG);
  }

  @override
  void Init()
  {

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

  /// Writes a log message to exactly one output to avoid duplicated Logcat entries.
  ///
  /// IMPORTANT:
  /// - Flutter loggers (e.g. `flutterLogger`) already forward messages to
  ///   the Android platform log (Logcat), but without custom coloring.
  /// - Writing the same message to both `flutterLogger` and `nativeLogger`
  ///   results in duplicated Logcat entries:
  ///     1) Plain Flutter log
  ///     2) Colored native log
  ///
  /// Because it is not possible to emit a single message to both Flutter console
  /// and Logcat without duplication, this method explicitly chooses ONE target:
  ///
  /// Routing strategy:
  /// - Unit tests:
  ///   - Log ONLY to Flutter console (`flutterLogger`)
  ///   - Ensures test output is visible and capturable
  /// - Normal app runtime:
  ///   - Log ONLY to native/platform logger (`nativeLogger`)
  ///   - Ensures colored, well-formatted logs in Logcat
  ///
  /// Log level selection:
  /// - `blue`   → informational logs
  /// - `yellow` → warning logs
  /// - `red`    → error logs
  ///
  void _print(String message, { bool red = false, yellow = false, blue= false})
  {
    if(blue)
      {
        if(IsUnitTest)
          flutterLogger.i("$_TAG: $message");
        else
          nativeLogger.i(message);
      }
    else if(red)
    {
      if(IsUnitTest)
        flutterLogger.e("$_TAG: $message");
      else
        nativeLogger.e(message);
    }
    else if(yellow)
      {
        if(IsUnitTest)
          flutterLogger.w("$_TAG: $message");
        else
          nativeLogger.w(message);
      }
  }

  bool get IsUnitTest
  {
    return const bool.fromEnvironment('dart.vm.product') == false
        && Platform.environment.containsKey('FLUTTER_TEST');
  }


}