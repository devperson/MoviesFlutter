import 'package:get/get.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IErrorTrackingService.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IFileLogger.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/ILoggingService.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IPlatformOutput.dart';
import 'package:movies_flutter/Core/Abstractions/Essentials/IPreferences.dart';
import 'package:movies_flutter/Core/Abstractions/Platform/IDirectoryService.dart';
import 'package:movies_flutter/Core/Abstractions/Platform/IZipService.dart';
import 'package:movies_flutter/Core/Abstractions/Repository/ILocalDbInitilizer.dart';
import 'package:movies_flutter/Core/Abstractions/Repository/IRepoMapper.dart';
import 'package:movies_flutter/Core/Abstractions/Repository/IRepository.dart';
import 'package:movies_flutter/Core/Base/Impl/Diagnostic/F_ErrorTrackingService.dart';
import 'package:movies_flutter/Core/Base/Impl/Diagnostic/F_FileLogger.dart';
import 'package:movies_flutter/Core/Base/Impl/Diagnostic/F_LoggingService.dart';
import 'package:movies_flutter/Core/Base/Impl/Diagnostic/F_PlatformOutput.dart';
import 'package:movies_flutter/Core/Domain/Infrastructures/Repository/MoviesRepository.dart';
import 'package:movies_flutter/Core/Domain/Infrastructures/Repository/Tables/Movietb.dart';
import 'package:movies_flutter/Core/Domain/Mappers/MovieRepoMapper.dart';
import 'package:movies_flutter/Core/Domain/Models/Movie.dart';
import '../../Impl/MockDbInitializer.dart';
import '../../Impl/MockDirectoryDir.dart';
import '../../Impl/MockPreferences.dart';
import '../../Impl/MockZipService.dart';

class RepoDI
{
   void RegisterTypes()
   {
     //common
     Get.lazyPut<IPlatformOutput>(() => F_PlatformOutput(), fenix: true);
     Get.lazyPut<IErrorTrackingService>(() => F_ErrorTrackingService(), fenix: true);
     Get.lazyPut<IFileLogger>(() => F_FileLogger(), fenix: true);
     Get.lazyPut<IPreferences>(() => Mockpreferences(), fenix: true);
     Get.lazyPut<IZipService>(() => MockZipService(), fenix: true);
     Get.lazyPut<IDirectoryService>(() => MockDirectoryDir(), fenix: true);
     Get.lazyPut<ILoggingService>(() => F_LoggingService(), fenix: true);

     //db
     Get.lazyPut<ILocalDbInitilizer>(() => MockDbInitializer(), fenix: true);
     Get.lazyPut<IRepoMapper<Movie, Movietb>>(() => MovieRepoMapper(), fenix: true);
     Get.lazyPut<IRepository<Movie>>(() => MovieRepository(), fenix: true);
   }
}