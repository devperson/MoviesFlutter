import 'package:get/get.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IErrorTrackingService.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IFileLogger.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IPlatformOutput.dart';
import 'package:movies_flutter/Core/Abstractions/Navigation/IPageNavigationService.dart';
import 'package:movies_flutter/Core/Abstractions/UI/ISnackbarService.dart';
import 'package:movies_flutter/Core/Base/Impl/Diagnostic/MockFileLogger.dart';
import 'package:movies_flutter/Core/Base/Impl/Navigation/F_PageNavigationService.dart';

import '../Abstractions/Diagnostics/ILoggingService.dart';
import '../Abstractions/UI/IAlertDialogService.dart';
import 'Impl/Diagnostic/AppErrorTrackingService.dart';
import 'Impl/Diagnostic/AppLoggingService.dart';
import 'Impl/Diagnostic/AppPlatformOutput.dart';
import 'Impl/UI/F_AlertDialogService.dart';
import 'Impl/UI/F_SnackbarService.dart';

class BaseImplRegistrar
{
    static void RegisterTypes()
    {
      Get.lazyPut<IPlatformOutput>(() => AppPlatformOutput(), fenix: true);
      Get.lazyPut<IErrorTrackingService>(() => AppErrorTrackingService(), fenix: true);
      Get.lazyPut<IFileLogger>(() => MockFileLogger(), fenix: true);
      Get.lazyPut<ILoggingService>(() => AppLoggingService(), fenix: true);
      Get.lazyPut<IPageNavigationService>(() => F_PageNavigationService(), fenix: true);

      //UI
      Get.lazyPut<IAlertDialogService>(() => F_AlertDialogService(), fenix: true);
      Get.lazyPut<ISnackbarService>(() => F_SnackbarService(), fenix: true);
    }
}