import 'package:get/get.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IErrorTrackingService.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IFileLogger.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IPlatformOutput.dart';
import 'package:movies_flutter/Core/Abstractions/Essentials/Device/IDeviceInfo.dart';
import 'package:movies_flutter/Core/Abstractions/Navigation/IPageNavigationService.dart';
import 'package:movies_flutter/Core/Abstractions/Platform/IDirectoryService.dart';
import 'package:movies_flutter/Core/Abstractions/Platform/IZipService.dart';
import 'package:movies_flutter/Core/Abstractions/REST/IAuthTokenService.dart';
import 'package:movies_flutter/Core/Abstractions/REST/IRestClient.dart';
import 'package:movies_flutter/Core/Base/Impl/Diagnostic/F_FileLogger.dart';
import 'package:movies_flutter/Core/Abstractions/UI/ISnackbarService.dart';
import 'package:movies_flutter/Core/Base/Impl/Navigation/F_PageNavigationService.dart';
import 'package:movies_flutter/Core/Base/Impl/Platform/F_ZipService.dart';
import 'package:movies_flutter/Core/Base/Impl/REST/F_AuthTokenService.dart';
import 'package:movies_flutter/Core/Base/Impl/REST/RequestQueueList.dart';
import 'package:movies_flutter/Core/Base/Impl/REST/RestClient.dart';

import '../Abstractions/Diagnostics/ILoggingService.dart';
import '../Abstractions/Essentials/Display/IDisplay.dart';
import '../Abstractions/Essentials/IAppInfo.dart';
import '../Abstractions/Essentials/IPreferences.dart';
import '../Abstractions/Essentials/IShare.dart';
import '../Abstractions/UI/IAlertDialogService.dart';
import 'Impl/Diagnostic/F_ErrorTrackingService.dart';
import 'Impl/Diagnostic/F_LoggingService.dart';
import 'Impl/Diagnostic/F_PlatformOutput.dart';
import 'Impl/Essentials/F_AppInfoImplementation.dart';
import 'Impl/Essentials/F_DeviceInfoImplementation.dart';
import 'Impl/Essentials/F_DirectoryService.dart';
import 'Impl/Essentials/F_DisplayImplementation.dart';
import 'Impl/Essentials/F_PreferencesImplementation.dart';
import 'Impl/Essentials/F_ShareImplementation.dart';
import 'Impl/UI/F_AlertDialogService.dart';
import 'Impl/UI/F_SnackbarService.dart';

class BaseImplRegistrar
{
    static void RegisterTypes()
    {
      Get.lazyPut<IPlatformOutput>(() => F_PlatformOutput(), fenix: true);
      Get.lazyPut<IErrorTrackingService>(() => F_ErrorTrackingService(), fenix: true);
      Get.lazyPut<IFileLogger>(() => F_FileLogger(), fenix: true);
      Get.put<ILoggingService>(F_LoggingService(), permanent: true);
      Get.lazyPut<IZipService>(() => F_ZipService(), fenix: true);

      //UI
      Get.lazyPut<IAlertDialogService>(() => F_AlertDialogService(), fenix: true);
      Get.lazyPut<ISnackbarService>(() => F_SnackbarService(), fenix: true);
      Get.put<IPageNavigationService>(F_PageNavigationService(), permanent: true);
      //Essentials
      Get.lazyPut<IAppInfo>(() => F_AppInfoImplementation(), fenix: true);
      Get.lazyPut<IDeviceInfo>(() => F_DeviceInfoImplementation(), fenix: true);
      Get.lazyPut<IDirectoryService>(() => F_DirectoryService(), fenix: true);
      Get.lazyPut<IDisplay>(() => F_DisplayImplementation(), fenix: true);
      Get.lazyPut<IPreferences>(() => F_PreferencesImplementation(), fenix: true);
      Get.lazyPut<IShare>(() => F_ShareImplementation(), fenix: true);
      //REST
      Get.lazyPut<IRestClient>(() => RestClient(), fenix: true);
      Get.lazyPut<RequestQueueList>(() => RequestQueueList(), fenix: true);
      Get.lazyPut<IAuthTokenService>(() => F_AuthTokenService(), fenix: true);

    }
}