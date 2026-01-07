import 'package:flutter_test/flutter_test.dart';
import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';
import 'package:movies_flutter/Core/Abstractions/Repository/ILocalDbInitilizer.dart';
import 'package:movies_flutter/Core/Abstractions/Repository/IRepository.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/ContainerLocator.dart';
import 'package:movies_flutter/Core/Domain/Models/Movie.dart';
import 'RepoDi.dart';

void main()
{
  //late CounterService service;

  setUp(() async
  {
     final infraDi = RepoDI();
     infraDi.RegisterTypes();

     // final logging = ContainerLocator.Resolve<ILoggingService>();
     // await logging.InitAsync();

     final dbInitializer = ContainerLocator.Resolve<ILocalDbInitilizer>();
     await dbInitializer.Init();
  });

  late int newId;

  test('T1_1AddMovieTest', () async
  {
    final movieRepo = ContainerLocator.Resolve<IRepository<Movie>>();
    final movieEntity = Movie.Create("test movie from unittest", "good movie", "no url");
    await movieRepo.AddAsync(movieEntity);
    expect(movieEntity.Id > 0, isTrue, reason: "new movieEntity id doesn't increment");
    newId = movieEntity.Id;
  });

  test('T1_2AddAllMovieTest', () async
      {
        final movieRepo = ContainerLocator.Resolve<IRepository<Movie>>();
        final movieEntity = Movie.Create("test movie from unittest", "good movie", "no url");
        final movieEntity2 = Movie.Create("test movie from unittest2", "good movie2", "no url2");
        await movieRepo.AddAllAsync([movieEntity, movieEntity2]);
        expect(movieEntity.Id > 0,isTrue, reason: "new first id doesn't increment");
        expect(movieEntity2.Id > 0,isTrue, reason: "new second movie id doesn't increment");
      });

  test('T1_3GetListTest', () async
      {
        final movieRepo = ContainerLocator.Resolve<IRepository<Movie>>();
        final allList = await movieRepo.GetListAsync();

        expect(allList.length > 0, isTrue, reason: "GetList() returned empty list");
      });

  test('T1_4GetMovieTest', () async
      {
        final movieRepo = ContainerLocator.Resolve<IRepository<Movie>>();
        final movieEntity = await movieRepo.FindById(newId);

        expect(movieEntity != null, isTrue, reason: "FindById() returned null");
        expect(movieEntity!.Id > 0, isTrue, reason: "entity has incorrect id");
      });

  test('T1_5UpdateMovieTest', () async
      {
        final movieRepo = ContainerLocator.Resolve<IRepository<Movie>>();
        final movieEntity = await movieRepo.FindById(newId);
        if (movieEntity != null)
        {
          movieEntity.Name = "updated name";
          await movieRepo.UpdateAsync(movieEntity);
          //check update
          final updatedEntity = await movieRepo.FindById(newId);
          expect(updatedEntity != null, isTrue, reason: "FindById() returned null");
          expect(updatedEntity!.Id > 0, isTrue, reason: "entity has incorrect id");
          expect(updatedEntity.Name, "updated name", reason: "entity has incorrect name");
        }
        else
        {
          throw AppException.Throw("Can not find movie entity");
        }
      });

  test('T1_6DeleteMovieTest', () async
      {
        final movieRepo = ContainerLocator.Resolve<IRepository<Movie>>();
        var entity = await movieRepo.FindById(1);
        expect(entity != null, isTrue, reason: "Can not find entity");
        final deletedCount = await movieRepo.RemoveAsync(entity!);
        expect(deletedCount > 0, isTrue, reason: "RemoveAsync() returned negative value");

        entity = await movieRepo.FindById(1);
        expect(entity == null, isTrue, reason: "Entity was not removed");
      });

  test('T1_7ClearAllMovieTest', () async
      {
        final movieRepo = ContainerLocator.Resolve<IRepository<Movie>>();
        movieRepo.ClearAsync("test clear");
        final list = await movieRepo.GetListAsync();
        expect(list.length == 0, isTrue, reason:  "table still has data after clear()");
      });

}