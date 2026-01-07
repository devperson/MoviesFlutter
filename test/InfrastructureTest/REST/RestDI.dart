import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:movies_flutter/Core/Abstractions/REST/IAuthTokenService.dart';
import 'package:movies_flutter/Core/Abstractions/REST/IRestClient.dart';
import 'package:movies_flutter/Core/Base/Impl/REST/F_AuthTokenService.dart';
import 'package:movies_flutter/Core/Base/Impl/REST/RequestQueueList.dart';
import 'package:movies_flutter/Core/Base/Impl/REST/RestClient.dart';
import 'package:movies_flutter/Core/Domain/Infrastructures/REST/IMovieRestService.dart';
import 'package:movies_flutter/Core/Domain/Infrastructures/REST/MovieRestService.dart';

class RepoDI
{
  void RegisterTypes()
  {

    //REST
    Get.lazyPut<IRestClient>(() => RestClient(), fenix: true);
    Get.lazyPut<RequestQueueList>(() => RequestQueueList(), fenix: true);
    Get.lazyPut<IAuthTokenService>(() => F_AuthTokenService(), fenix: true);
    Get.lazyPut<IMovieRestService>(() => MovieRestService(), fenix: true);
  }
}