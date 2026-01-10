import '../../Abstractions/Repository/IRepoMapper.dart';
import '../Infrastructures/Repository/Tables/Movietb.dart';
import '../Models/Movie.dart';

class MovieRepoMapper implements IRepoMapper<Movie, Movietb>
{
  @override
  Movietb ToTb(Movie entity)
  {
    final tb = Movietb(
      entity.Id,
      entity.Name,
      entity.Overview,
      PostUrl: entity.PosterUrl ?? '');

    return tb;
  }

  @override
  Movie ToEntity(Movietb tb)
  {
    final movie = Movie.Create(tb.Name, tb.Overview,tb.PostUrl);
    movie.Id = tb.Id;
    return movie;
  }

  @override
  void MoveData(Movie from, Movietb to)
  {
    to.Name = from.Name;
    to.Overview = from.Overview;
    to.PostUrl = from.PosterUrl;
  }
}
