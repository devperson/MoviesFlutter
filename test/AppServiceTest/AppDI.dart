import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/ILoggingService.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IPlatformOutput.dart';
import 'package:movies_flutter/Core/Abstractions/Essentials/IPreferences.dart';
import 'package:movies_flutter/Core/Abstractions/Repository/IRepository.dart';
import 'package:movies_flutter/Core/Base/Impl/Diagnostic/F_PlatformOutput.dart';
import 'package:movies_flutter/Core/Domain/AppService/IMovieService.dart';
import 'package:movies_flutter/Core/Domain/AppService/MovieService.dart';
import 'package:movies_flutter/Core/Domain/Infrastructures/REST/IMovieRestService.dart';
import 'package:movies_flutter/Core/Domain/Models/Movie.dart';

import '../Impl/MockLoggingService.dart';

class AppDI
{
  void RegisterTypes()
  {
    //mock REST return data
    final movie = Movie.Create('test rest1', 'overview rest1', null);
    movie.Id = 1;
    final List<Movie> someMovies = [movie];
    final mockMovieRestService = MovieRestServiceMock();
    when(() => mockMovieRestService.GetMovieRestlist())
        .thenAnswer((_) async => someMovies);
    //mock repo
    final repo = MovieRepositoryMock();
    when(() => repo.FindById(any()))
        .thenAnswer((_) async => Movie.Create('test', 'test overview', null));
    when(() => repo.GetListAsync(count: any(named: 'count'), skip: any(named: 'skip')))
        .thenAnswer((_) async => [Movie.Create('test2', 'test overview2', null)]);
    when(() => repo.AddAsync(any<Movie>())).thenAnswer((_) async => 1);
    when(() => repo.UpdateAsync(any<Movie>())).thenAnswer((_) async => 1);
    when(() => repo.AddAllAsync(any<List<Movie>>())).thenAnswer((_) async => 1);
    when(() => repo.RemoveAsync(any<Movie>())).thenAnswer((_) async => 1);
    when(() => repo.ClearAsync(any())).thenAnswer((_) async => 1);

    Get.lazyPut<IPreferences>(()=>PreferencesMock(), fenix: true);
    Get.lazyPut<IPlatformOutput>(() => F_PlatformOutput(), fenix: true);
    Get.lazyPut<ILoggingService>(() => MockLoggingService(), fenix: true);
    Get.put<IMovieRestService>(mockMovieRestService, permanent: true);
    Get.put<IRepository<Movie>>(repo, permanent: true);
    Get.lazyPut<IMovieService>(()=>MoviesService(), fenix: true);


  }
}

class PreferencesMock extends Mock implements IPreferences {}
class MovieRestServiceMock extends Mock implements IMovieRestService {}
class MovieRepositoryMock extends Mock implements IRepository<Movie> {}
class MovieFake extends Fake implements Movie {}