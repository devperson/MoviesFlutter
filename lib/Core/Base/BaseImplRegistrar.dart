import 'package:get/get.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IErrorTrackingService.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IFileLogger.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IPlatformOutput.dart';
import 'package:movies_flutter/Core/Abstractions/Navigation/IPageNavigationService.dart';
import 'package:movies_flutter/Core/Abstractions/Platform/IDirectoryService.dart';
import 'package:movies_flutter/Core/Abstractions/Platform/IZipService.dart';
import 'package:movies_flutter/Core/Base/Impl/Diagnostic/F_FileLogger.dart';
import 'package:movies_flutter/Core/Base/Impl/Navigation/F_PageNavigationService.dart';
import 'package:movies_flutter/Core/Base/Impl/Platform/F_DirectoryService.dart';
import 'package:movies_flutter/Core/Base/Impl/Platform/F_ZipService.dart';

import '../Abstractions/Diagnostics/ILoggingService.dart';
import 'Impl/Diagnostic/AppErrorTrackingService.dart';
import 'Impl/Diagnostic/AppLoggingService.dart';
import 'Impl/Diagnostic/AppPlatformOutput.dart';

class BaseImplRegistrar
{
    static void RegisterTypes()
    {
      Get.lazyPut<IPlatformOutput>(() => AppPlatformOutput(), fenix: true);
      Get.lazyPut<IErrorTrackingService>(() => AppErrorTrackingService(), fenix: true);
      Get.lazyPut<IFileLogger>(() => F_FileLogger(), fenix: true);
      Get.lazyPut<ILoggingService>(() => AppLoggingService(), fenix: true);
      Get.lazyPut<IPageNavigationService>(() => F_PageNavigationService(), fenix: true);
      Get.lazyPut<IDirectoryService>(() => F_DirectoryService(), fenix: true);
      Get.lazyPut<IZipService>(() => F_ZipService(), fenix: true);
    }
}