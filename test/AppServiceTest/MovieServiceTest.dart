import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/ContainerLocator.dart';
import 'package:movies_flutter/Core/Domain/AppService/IMovieService.dart';

import 'AppDI.dart';


void main()
{
  //late CounterService service;

  setUpAll(()
  {
    // register to mock arguments of type Movie
    //so we can use mock parameter like this
    //repo.AddAsync(any<Movie>()))
    registerFallbackValue(MovieFake()); //indicate how to create Movie instance
  });

  setUp(() async
  {
     final appDi = AppDI();
     appDi.RegisterTypes();
  });

  test('T1_1AddMovieTest', () async
  {
    final movieService = ContainerLocator.Resolve<IMovieService>();
    final result = await movieService.AddAsync("first product", "test overview", "");

    expect(result.Success, isTrue, reason: "IMoviesService.AddAsync() failed in T1_1AddMovieTest() with error: ${result.Error.toString()}");
  });

  test('T1_2GetMovieListTest', () async
      {
        final movieService = ContainerLocator.Resolve<IMovieService>();
        final result = await movieService.GetListAsync();

        expect(result.Success, isTrue, reason:  "IMoviesService.GetListAsync() failed in T1_2GetMovieListTest() with error: ${result.Error.toString()}");
        expect(result.ValueOrThrow.length > 0, isTrue, reason: "Movie count is zero in T1_2GetMovieListTest()");
      });

  test('T1_3GetMovieTest', () async
  {
    final movieService = ContainerLocator.Resolve<IMovieService>();
    final result = await movieService.GetById(1);
    expect(result.Success, isTrue, reason: "IMoviesService.GetById() failed in T1_3GetMovieTest() with error: ${result.Error.toString()}");
  });

  test('T1_4UpdateMovieTest', () async
  {
    final movieService = ContainerLocator.Resolve<IMovieService>();
    final result = await movieService.GetById(1);
    expect(result.Success, isTrue, reason:  "IMoviesService.GetById() failed in T1_4UpdateMovieTest() with error: ${result.Error.toString()}");

    final item = result.ValueOrThrow;
    item.Name = "updated name";
    item.Overview = "updated overview";
    item.PosterUrl = "updated poster";
    final updateResult = await movieService.UpdateAsync(item);
    expect(updateResult.Success, isTrue, reason:  "IMoviesService.UpdateAsync() failed in T1_3UpdateMovieTest() with error: ${updateResult.Error.toString()}");
  });

  test('T1_5RemoveMovieTest', () async
  {
    final movieService = ContainerLocator.Resolve<IMovieService>();
    final result = await movieService.GetById(1);
    expect(result.Success, isTrue, reason: "IMoviesService.GetById() failed in T1_3UpdateMovieTest()");

    final item = result.ValueOrThrow;
    final removeResult = await movieService.RemoveAsync(item.Id);
    expect(removeResult.Success, isTrue, reason: "IMoviesService.RemoveAsync() failed in T1_3RemoveMovieTest() with error: ${removeResult.Error.toString()}");
  });


}