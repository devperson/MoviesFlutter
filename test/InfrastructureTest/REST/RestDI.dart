import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:movies_flutter/Core/Abstractions/AppServices/IConstant.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/ILoggingService.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IPlatformOutput.dart';
import 'package:movies_flutter/Core/Abstractions/Essentials/IPreferences.dart';
import 'package:movies_flutter/Core/Abstractions/REST/IAuthTokenService.dart';
import 'package:movies_flutter/Core/Abstractions/REST/IRestClient.dart';
import 'package:movies_flutter/Core/Abstractions/REST/Json/IJsonMapper.dart';
import 'package:movies_flutter/Core/Base/Impl/Diagnostic/F_PlatformOutput.dart';
import 'package:movies_flutter/Core/Base/Impl/REST/F_AuthTokenService.dart';
import 'package:movies_flutter/Core/Base/Impl/REST/RequestQueueList.dart';
import 'package:movies_flutter/Core/Base/Impl/REST/RestClient.dart';
import 'package:movies_flutter/Core/Domain/Infrastructures/REST/IMovieRestService.dart';
import 'package:movies_flutter/Core/Domain/Infrastructures/REST/JsonMapper.dart';
import 'package:movies_flutter/Core/Domain/Infrastructures/REST/Models/MovieListResponse.dart';
import 'package:movies_flutter/Core/Domain/Infrastructures/REST/Models/MovieRestModel.dart';
import 'package:movies_flutter/Core/Domain/Infrastructures/REST/MovieRestService.dart';

import '../../Impl/ConstImpl.dart';
import '../../Impl/InMemoryPreferences.dart';
import '../../Impl/MockLoggingService.dart';

class RestDI
{
  void RegisterTypes()
  {
    //common
    Get.lazyPut<IPreferences>(() => InMemoryPreferences(), fenix: true);
    //logging
    Get.lazyPut<IPlatformOutput>(() => F_PlatformOutput(), fenix: true);
    Get.lazyPut<ILoggingService>(() => MockLoggingService(), fenix: true);
    //REST
    Get.lazyPut<IRestClient>(() => RestClient(), fenix: true);
    Get.lazyPut<RequestQueueList>(() => RequestQueueList(), fenix: true);
    Get.lazyPut<IAuthTokenService>(() => F_AuthTokenService(), fenix: true);
    Get.lazyPut<IMovieRestService>(() => MovieRestService(), fenix: true);
    Get.lazyPut<IConstant>(() => ConstImpl(), fenix: true);
    //json
    final jsonMapper = JsonMapper();
    jsonMapper.Register(MovieListResponse.Empty());
    jsonMapper.Register(MovieRestModel.Empty());
    Get.put<IJsonMapper>(jsonMapper , permanent: true);
  }
}