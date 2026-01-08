import '../../Abstractions/AppServices/IAppDto.dart';

class MovieDto implements IAppDto
{
  @override
  int Id;
  String Name;
  String Overview;
  String? PosterUrl;

  MovieDto(this.Id, this.Name, this.Overview, this.PosterUrl);
}