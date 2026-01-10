import 'package:movies_flutter/Core/Abstractions/AppServices/IConstant.dart';

class Constimpl implements IConstant
{
  @override
  String get ServerUrlHost => "https://api.themoviedb.org/3/";

}