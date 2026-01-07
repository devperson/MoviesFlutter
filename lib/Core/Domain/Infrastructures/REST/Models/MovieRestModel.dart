import 'package:dart_mappable/dart_mappable.dart';
import '../../../../Abstractions/REST/Json/IJsonModel.dart';

part 'MovieRestModel.mapper.dart';

// RUN `dart run build_runner build` to generate MovieRestModelMappable
@MappableClass()
class MovieRestModel with MovieRestModelMappable implements IDeserializable<MovieRestModel>
{
  @MappableField(key: 'id')
  int Id = 0;
  @MappableField(key: "title")
  String Name = "";
  @MappableField(key:"poster_path")
  String PosterPath = "";
  @MappableField(key: "overview")
  String Overview = "";

  MovieRestModel(this.Id, this.Name, this.PosterPath, this.Overview);
  static MovieRestModel Empty()
  {
    return MovieRestModel(0, "", "", "");
  }


  @override
  MovieRestModel Deserialize(String json)
  {
    return MovieRestModelMapper.fromJson(json);
  }

  @override
  String Serialize()
  {
    return this.toJson();
  }


}