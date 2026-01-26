import '../../Abstractions/AppServices/Some.dart';
import '../Dto/MovieDto.dart';

abstract interface class IMovieService
{
  Future<Some<List<MovieDto>>> GetListAsync({int count = -1, int skip = 0, bool remoteList = false});
  Future<Some<MovieDto>> GetById(int id);
  Future<Some<int>> AddAsync(String name, String overview, String? posterUrl);
  Future<Some<int>> UpdateAsync(MovieDto dtoModel);
  Future<Some<int>> RemoveAsync(int dtoId);
}