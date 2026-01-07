import 'package:movies_flutter/Core/Abstractions/AppServices/IConstant.dart';

class ConstImpl implements IConstant
{
  @override
  String get ServerUrlHost => "https://api.themoviedb.org/3/";

}