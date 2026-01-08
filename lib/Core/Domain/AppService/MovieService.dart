import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/LazyInjected.dart';

import '../../Abstractions/AppServices/Some.dart';
import '../../Abstractions/Repository/IRepository.dart';
import '../../Base/Impl/Diagnostic/LoggableService.dart';
import '../Dto/MovieDto.dart';
import '../Infrastructures/REST/IMovieRestService.dart';
import '../Mappers/DtoToEntity.dart';
import '../Mappers/EntityToDtoMapper.dart';
import '../Models/Movie.dart';
import 'IMovieService.dart';

class MoviesService with LoggableService implements IMovieService
{
  final movieRepository = LazyInjected<IRepository<Movie>>();
  final movieRestService = LazyInjected<IMovieRestService>();

  @override
  Future<Some<List<MovieDto>>> GetListAsync({int count = -1, int skip = 0, bool remoteList = false}) async
  {
    try
    {
      LogMethodStart('GetListAsync', [count, skip, remoteList]);
      bool canLoadLocal = true;
      List<Movie>? localList;
      if (remoteList)
      {
        canLoadLocal = false;
      }
      else
      {
        localList = await movieRepository.Value.GetListAsync();
        canLoadLocal = localList.isNotEmpty;
      }

      if (canLoadLocal)
      {
        loggingService.Value.Log('MoviesService.GetListAsync(): loading from Local storage because canLoadLocal: $canLoadLocal');

        final dtoList = localList!
            .map((s) => s.ToDto<MovieDto>())
            .toList();

        return Some.FromValue(dtoList);
      }
      else
      {
        loggingService.Value.Log('MoviesService.GetListAsync(): loading from Remote server because canLoadLocal: $canLoadLocal');

        final remoteList = await movieRestService.Value.GetMovieRestlist();
        final deletedCount = await movieRepository.Value.ClearAsync('MoviesService: Delete all items requested when syncing');
        final insertedCount = await movieRepository.Value.AddAllAsync(remoteList);

        loggingService.Value.Log('MoviesService.GetListAsync(): Sync completed deletedCount: $deletedCount, insertedCount: $insertedCount');

        final dtoList = remoteList
            .map((s) => s.ToDto<MovieDto>())
            .toList();

        return Some.FromValue(dtoList);
      }
    }
    catch (ex, stackTrace)
    {
      return Some.FromError(ex.ToAppException(stackTrace));
    }
  }

  @override
  Future<Some<MovieDto>> GetById(int id) async
  {
    try
    {
      LogMethodStart('GetById', [id]);
      final movie = await movieRepository.Value.FindById(id);
      final dtoMovie = movie!.ToDto<MovieDto>();
      return Some.FromValue(dtoMovie);
    }
    catch (ex, stackTrace)
    {
      return Some.FromError(ex.ToAppException(stackTrace));
    }
  }

  @override
  Future<Some<MovieDto>> AddAsync(String name, String overview, String? posterUrl) async
  {
    try
    {
      LogMethodStart('AddAsync', [name, overview, posterUrl]);
      final movie = Movie.Create(name, overview, posterUrl);
      await movieRepository.Value.AddAsync(movie);
      final dtoMovie = movie.ToDto<MovieDto>();
      return Some.FromValue(dtoMovie);
    }
    catch (ex, stackTrace)
    {
      return Some.FromError(ex.ToAppException(stackTrace));
    }
  }

  @override
  Future<Some<MovieDto>> UpdateAsync(MovieDto dtoModel) async
  {
    try
    {
      LogMethodStart('UpdateAsync', [dtoModel]);
      final movie = dtoModel.ToEntity<Movie>();
      await movieRepository.Value.UpdateAsync(movie);

      return Some.FromValue(dtoModel);
    }
    catch (ex, stackTrace)
    {
      return Some.FromError(ex.ToAppException(stackTrace));
    }
  }

  @override
  Future<Some<int>> RemoveAsync(MovieDto dtoModel) async
  {
    try
    {
      LogMethodStart('RemoveAsync', [dtoModel]);

      final movie = dtoModel.ToEntity<Movie>();
      final res = await movieRepository.Value.RemoveAsync(movie);

      return Some.FromValue(res);
    }
    catch (ex, stackTrace)
    {
      return Some.FromError(ex.ToAppException(stackTrace));
    }
  }
}
