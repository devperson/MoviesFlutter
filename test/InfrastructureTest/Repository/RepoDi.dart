import 'package:get/get.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/ILoggingService.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IPlatformOutput.dart';
import 'package:movies_flutter/Core/Abstractions/Repository/ILocalDbInitilizer.dart';
import 'package:movies_flutter/Core/Abstractions/Repository/IRepoMapper.dart';
import 'package:movies_flutter/Core/Abstractions/Repository/IRepository.dart';
import 'package:movies_flutter/Core/Base/Impl/Diagnostic/F_PlatformOutput.dart';
import 'package:movies_flutter/Core/Domain/Infrastructures/Repository/MoviesRepository.dart';
import 'package:movies_flutter/Core/Domain/Infrastructures/Repository/Tables/Movietb.dart';
import 'package:movies_flutter/Core/Domain/Mappers/MovieRepoMapper.dart';
import 'package:movies_flutter/Core/Domain/Models/Movie.dart';
import '../../Impl/MockDbInitializer.dart';
import '../../Impl/MockLoggingService.dart';

class RepoDI
{
   void RegisterTypes()
   {
     //common
     Get.lazyPut<IPlatformOutput>(() => F_PlatformOutput(), fenix: true);
     //Get.lazyPut<IErrorTrackingService>(() => F_ErrorTrackingService(), fenix: true);
     //Get.lazyPut<IFileLogger>(() => F_FileLogger(), fenix: true);
     //Get.lazyPut<IPreferences>(() => Mockpreferences(), fenix: true);
    // Get.lazyPut<IZipService>(() => MockZipService(), fenix: true);
     //Get.lazyPut<IDirectoryService>(() => MockDirectoryDir(), fenix: true);
     Get.lazyPut<ILoggingService>(() => MockLoggingService(), fenix: true);

     //db
     Get.lazyPut<ILocalDbInitilizer>(() => MockDbInitializer(), fenix: true);
     Get.lazyPut<IRepoMapper<Movie, Movietb>>(() => MovieRepoMapper(), fenix: true);
     Get.lazyPut<IRepository<Movie>>(() => MovieRepository(), fenix: true);
   }
}