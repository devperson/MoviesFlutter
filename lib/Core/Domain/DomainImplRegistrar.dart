import 'package:get/get.dart';
import 'package:movies_flutter/Core/Abstractions/Repository/ILocalDbInitilizer.dart';
import 'package:movies_flutter/Core/Domain/Infrastructures/REST/IMovieRestService.dart';
import 'package:movies_flutter/Core/Domain/Infrastructures/REST/JsonMapper.dart';
import 'package:movies_flutter/Core/Domain/Infrastructures/REST/MovieRestService.dart';


import '../Abstractions/REST/Json/IJsonMapper.dart';
import '../Abstractions/Repository/IRepoMapper.dart';
import '../Abstractions/Repository/IRepository.dart';
import 'Infrastructures/REST/Models/MovieListResponse.dart';
import 'Infrastructures/REST/Models/MovieRestModel.dart';
import 'Infrastructures/Repository/F_DbInitilizer.dart';
import 'Infrastructures/Repository/MoviesRepository.dart';
import 'Infrastructures/Repository/Tables/Movietb.dart';
import 'Mappers/MovieRepoMapper.dart';
import 'Models/Movie.dart';

class BaseImplRegistrar
{
  static void RegisterTypes()
  {
    Get.lazyPut<ILocalDbInitilizer>(() => F_DbInitilizer(), fenix: true);
    Get.lazyPut<IRepoMapper<Movie, Movietb>>(() => MovieRepoMapper(), fenix: true);
    Get.lazyPut<IRepository<Movie>>(() => MovieRepository(), fenix: true);

    final jsonMapper = JsonMapper();
    jsonMapper.Register(MovieListResponse.Empty());
    jsonMapper.Register(MovieRestModel.Empty());
    Get.put<IJsonMapper>(jsonMapper , permanent: true);
    Get.lazyPut<IMovieRestService>(() => MovieRestService(), fenix: true);

  }
}