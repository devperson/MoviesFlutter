import 'dart:async';

import 'package:get/get.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IErrorTrackingService.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IFileLogger.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IPlatformOutput.dart';
import 'package:movies_flutter/Core/Abstractions/Essentials/Device/IDeviceInfo.dart';
import 'package:movies_flutter/Core/Abstractions/Messaging/IMessagesCenter.dart';
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
import '../Abstractions/Messaging/SimpleMessagingCenter.dart';
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
    static Future<void> RegisterTypes() async
    {
      //We use IoC by GetX here, it has some cons though
      //Get.put allows to create singilton instances but they will be created right away
      //Get.lazyPut it will not create instance only when accessed but you can not make it singilton.
      //So GetX has some limitation it can not do lazy singilton instances
      Get.put<IDirectoryService>(F_DirectoryService(), permanent: true);

      final pref = F_PreferencesImplementation();
      await pref.InitializeAsync();
      Get.put<IPreferences>(pref, permanent: true);

      Get.put<IFileLogger>(F_FileLogger(), permanent: true);
      Get.put<IPlatformOutput>(F_PlatformOutput(), permanent: true);
      Get.put<IErrorTrackingService>(F_ErrorTrackingService(), permanent: true);

      final logger = F_LoggingService();
      await logger.InitAsync();
      Get.put<ILoggingService>(logger, permanent: true);

      Get.put<IPageNavigationService>(F_PageNavigationService(), permanent: true);
      Get.lazyPut<IZipService>(() => F_ZipService(), fenix: true);
      Get.put<IMessagesCenter>(SimpleMessageCenter(), permanent: true);

      //UI
      Get.lazyPut<IAlertDialogService>(() => F_AlertDialogService(), fenix: true);
      Get.lazyPut<ISnackbarService>(() => F_SnackbarService(), fenix: true);
      Get.put<IPageNavigationService>(F_PageNavigationService(), permanent: true);
      //Essentials
      Get.put<IAppInfo>(F_AppInfoImplementation(), permanent: true);
      Get.put<IDeviceInfo>(F_DeviceInfoImplementation(), permanent: true);

      Get.put<IDisplay>(F_DisplayImplementation(), permanent: true);
      Get.put<IShare>(F_ShareImplementation(), permanent: true);
      //REST
      Get.lazyPut<IRestClient>(() => RestClient(), fenix: true);
      Get.lazyPut<RequestQueueList>(() => RequestQueueList(), fenix: true);
      Get.lazyPut<IAuthTokenService>(() => F_AuthTokenService(), fenix: true);

    }
}