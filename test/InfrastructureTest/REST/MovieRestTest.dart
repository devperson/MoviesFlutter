import 'package:movies_flutter/Core/Base/Impl/Utils/ContainerLocator.dart';
import 'package:movies_flutter/Core/Domain/Infrastructures/REST/IMovieRestService.dart';

import '../Repository/RepoDi.dart';
import 'package:flutter_test/flutter_test.dart';

import 'RestDI.dart';
void main()
{
  //late CounterService service;

  setUp(() async
  {
    final infraDi = RestDI();
    infraDi.RegisterTypes();

    // final logging = ContainerLocator.Resolve<ILoggingService>();
    // await logging.InitAsync();
  });

  test('T1_1TestGetMovies', () async
  {
    final movieRestService = ContainerLocator.Resolve<IMovieRestService>();
    final list = await movieRestService.GetMovieRestlist();
    expect(list.length > 0 , isTrue, reason: "GetMovieRestlist() returned empty list instead of movie rest items");
    expect(list.first.PosterUrl?.contains("http") , isTrue, reason: "Movie's PosterUrl value doesn't start with http schemas");
  });
 
}