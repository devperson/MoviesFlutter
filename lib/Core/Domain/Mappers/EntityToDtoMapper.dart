import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';

import '../../Abstractions/AppServices/IAppDto.dart';
import '../../Abstractions/Domain/IEntity.dart';
import '../Dto/MovieDto.dart';
import '../Models/Movie.dart';

extension EntityToDtoMapper on IEntity
{
  T ToDto<T extends IAppDto>()
  {
    if (this is Movie)
    {
      if (T != MovieDto)
      {
        throw AppException.Throw('Movie entity can be converted only to MovieDto type but input T is $T');
      }

      final m = this as Movie;
      final dto = MovieDto(m.Id, m.Name, m.Overview, m.PosterUrl);
      return dto as T;
    }

    throw AppException.Throw('ToDto() failed: Can not find dto type for entity type ${runtimeType}');
  }
}