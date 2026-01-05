import 'package:movies_flutter/Core/Base/Impl/Repository/BaseRepository.dart';

import '../../Models/Movie.dart';
import '../Repository/Tables/Movietb.dart';

///This repo based on realm db so run "dart run realm generate" to regenerate Movietb
class MovieRepository extends BaseRepository<Movie, Movietb, Movietb>
{
  MovieRepository() : super(Movietb);
}