import 'package:get/get.dart';
import 'package:movies_flutter/Core/Abstractions/Repository/ILocalDbInitilizer.dart';


import '../Abstractions/Repository/IRepoMapper.dart';
import '../Abstractions/Repository/IRepository.dart';
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
  }
}