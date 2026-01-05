import 'package:movies_flutter/Core/Abstractions/Domain/IEntity.dart';

class Movie implements IEntity
{
  @override
  int Id = 0;
  late String Name;
  late String Overview;
  String? PosterUrl;

  static Movie Create(String name, String overview, String? postUrl)
  {
    final movie = Movie();
    movie.Name = name;
    movie.Overview = overview;
    movie.PosterUrl = postUrl;

    return movie;
  }

}