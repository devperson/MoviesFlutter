import '../../Models/Movie.dart';

abstract interface class IMovieRestService
{
   Future<List<Movie>> GetMovieRestlist();
}