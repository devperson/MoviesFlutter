import 'dart:async';
import 'dart:ui';

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
import '../Utils/NativeiOSBridging.dart';
import 'dart:io' show Platform;

class F_ErrorTrackingService implements IErrorTrackingService
{
  //WARNING do not use it in InitializeAsync() because InitializeAsync() is called before DI init
  final _consoleOutput = LazyInjected<IPlatformOutput>();


  String? logDirectoryForUnhandled = null;
  @override
  Event<Exception> get OnServiceError => Event<Exception>();

  @override
  Future<void> InitializeAsync() async
  {
    await SentryFlutter.init((options) async
    {
        options.dsn = 'https://6f765635535a1c1d81ecd9b6c288b836@o4507288977080320.ingest.de.sentry.io/4510697340338256';
        // Adds request headers and IP for users, for more info visit:
        // https://docs.sentry.io/platforms/dart/guides/flutter/data-management/data-collected/
        options.sendDefaultPii = true;
        options.beforeSend = (ev, hint) async
        {
          //note that attaching for iOS native unhandled crash is not supported by Sentry
          //the bellow attaches to Android, Flutter exceptions/crashes(handled/unhandled)
          //the swift side have additional setup to send attachment to own server

          final logger = ContainerLocator.Resolve<ILoggingService>();
          final logBytes = await logger.GetLastSessionLogBytes();
          if (logBytes == null)
          {
            return ev;
          }

          hint.attachments.clear();
          hint.attachments.add(
              SentryAttachment.fromIntList(logBytes, 'applog.zip', contentType: 'application/x-zip-compressed'));
          
          return ev;
        };
        if(Platform.isIOS)
        {
          //we have additional setup at native swift side (check AppDelegate)
          print("F_ErrorTrackingService.InitializeAsync(): setup additional setup was done at native side for iOS(check swift AppDelegate)");
          //do not auto initialize native sdk as it is done manually at swift side
          options.autoInitializeNativeSdk = false;
        }
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


}

