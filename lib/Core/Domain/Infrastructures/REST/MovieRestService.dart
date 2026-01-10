import '../../../Abstractions/REST/RestRequest.dart';
import '../../../Base/Impl/REST/RestService.dart';
import '../../Models/Movie.dart';
import 'IMovieRestService.dart';
import 'Models/MovieListResponse.dart';

class MovieRestService extends RestService implements IMovieRestService
{

  final String baseImageHost = "https://image.tmdb.org/t/p/w300/";

  @override
  Future<List<Movie>> GetMovieRestlist() async
  {
    LogMethodStart("GetMovieRestlist");

    final result = await Get<MovieListResponse>(
      RestRequest(
        ApiEndpoint:
        "movie/popular?api_key=424f4be6472e955cadf36e104d8762d7",
        WithBearer: false,
      ),
    );

    final list = result.Movies.map((s)
    {
      final String posterUrl =
      s.PosterPath.startsWith("/")
          ? baseImageHost + s.PosterPath.substring(1)
          : "";

      final movie = Movie();
      movie.Id = s.Id;
      movie.Name = s.Name;
      movie.Overview = s.Overview;
      movie.PosterUrl = posterUrl;

      return movie;
    }).toList();

    return list;
  }
}
