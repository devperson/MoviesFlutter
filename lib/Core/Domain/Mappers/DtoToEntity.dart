import '../../Abstractions/AppServices/IAppDto.dart';
import '../../Abstractions/Domain/IEntity.dart';
import '../Dto/MovieDto.dart';
import '../Models/Movie.dart';

extension DtoToEntityMapper on IAppDto
{
  T ToEntity<T extends IEntity>()
  {
    if (this is MovieDto)
    {
      if (T != Movie)
      {
        throw ArgumentError('MovieDto can be converted only to Movie type but input T is $T');
      }
      final d = this as MovieDto;
      final entity = Movie.Create(d.Name, d.Overview, d.PosterUrl);
      entity.Id = d.Id;

      return entity as T;
    }

    throw ArgumentError('ToEntity() failed: Can not find entity type for dto ${runtimeType}');
  }
}