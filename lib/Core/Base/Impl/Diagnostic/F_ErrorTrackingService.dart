import 'dart:async';

import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IErrorTrackingService.dart';
import 'package:movies_flutter/Core/Abstractions/Common/Event.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IFileLogger.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/ILoggingService.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/ContainerLocator.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/LazyInjected.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry/sentry_io.dart';

import '../../../Abstractions/Diagnostics/IPlatformOutput.dart';
import '../../../Abstractions/Essentials/Device/DevicePlatform.dart';
import '../../../Abstractions/Essentials/Device/IDeviceInfo.dart';

class F_ErrorTrackingService implements IErrorTrackingService
{
  final _consoleOutput = LazyInjected<IPlatformOutput>();
  //final _directoryService = LazyInjected<IDirectoryService>();

  String? logDirectoryForUnhandled = null;
  @override
  Event<Exception> get OnServiceError => Event<Exception>();

  @override
  Future<void> InitializeAsync() async
  {
    await SentryFlutter.init((options)
    {
        options.dsn = 'https://6f765635535a1c1d81ecd9b6c288b836@o4507288977080320.ingest.de.sentry.io/4510697340338256';
        // Adds request headers and IP for users, for more info visit:
        // https://docs.sentry.io/platforms/dart/guides/flutter/data-management/data-collected/
        options.sendDefaultPii = true;
        options.beforeSend = (ev, hint) async
        {
          final logger = ContainerLocator.Resolve<ILoggingService>();
          final logBytes = await logger.GetLastSessionLogBytes();
          //final newLogPath = await _createPathForAttachment();

          if (logBytes == null)
          {
            return ev;
          }

          hint.attachments.clear();
          hint.attachments.add(
            SentryAttachment.fromIntList(logBytes, 'applog.zip',contentType: 'application/x-zip-compressed'));
          //SentryAttachment attach = Se
           return ev;
        };
    });
  }



  @override
  void TrackError(Object ex, StackTrace stackTrace, {List<int>? attachment, Map<String, String>? additionalData})
  {
    unawaited(Future(() async
    {
      try
      {
        await Sentry.captureException(ex, stackTrace: stackTrace);
      }
      catch(ex, stackTrace)
      {
        _consoleOutput.Value.Error(ex.ToExceptionString(stackTrace));
      }
    }));

  }

  @override
  Future<void> CustomConfigure() async
  {
    // final deviceInfo = ContainerLocator.Resolve<IDeviceInfo>();
    // if(deviceInfo.Platform == DevicePlatform.iOS)
    // {
      final fileLogger = ContainerLocator.Resolve<IFileLogger>();
      final logPath = fileLogger.GetCurrentLogFileName();
      final attachment = IoSentryAttachment.fromPath(logPath);
      await Sentry.configureScope((scope) => scope.addAttachment(attachment));
    //}
  }


  // int logFileIndex = 1;
  // Future<String> _createPathForAttachment() async
  // {
  //   if (logDirectoryForUnhandled == null)
  //   {
  //     final cacheDir = await _directoryService.Value.GetCacheDir();
  //     logDirectoryForUnhandled = path.join(cacheDir,'sentryTempFolder');
  //
  //     final dir = Directory(logDirectoryForUnhandled!);
  //     if (!await dir.exists())
  //     {
  //       await dir.create(recursive: true);
  //     }
  //   }
  //
  //   final newPath = path.join(logDirectoryForUnhandled!,'applog$logFileIndex.zip');
  //
  //   final file = File(newPath);
  //   if (await file.exists())
  //   {
  //     await file.delete();
  //   }
  //
  //   logFileIndex++;
  //   return newPath;
  // }

}