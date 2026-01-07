import 'package:dart_mappable/dart_mappable.dart';
import 'package:movies_flutter/Core/Abstractions/REST/Json/IJsonModel.dart';
import 'package:movies_flutter/Core/Domain/Models/Movie.dart';

import 'MovieRestModel.dart';
// RUN run `dart run build_runner build` to generate MovieListResponseMappable
part 'MovieListResponse.mapper.dart';

@MappableClass()
class MovieListResponse with MovieListResponseMappable implements IDeserializable<MovieListResponse>
{
  @MappableField(key: 'page')
  int Page = 0;
  @MappableField(key: 'total_pages')
  int TotalPages = 0;
  @MappableField(key: 'total_results')
  int TotalResults = 0;
  @MappableField(key: 'results')
  List<MovieRestModel> Movies = List.empty();

  static MovieListResponse Empty()
  {
    return MovieListResponse(0, 0, 0, List.empty());
  }
  MovieListResponse(this.Page, this.TotalPages, this.TotalResults, this.Movies);

  @override
  MovieListResponse Deserialize(String json)
  {
    return MovieListResponseMapper.fromJson(json);
  }

  @override
  String Serialize()
  {
    return this.toJson();
  }
}

