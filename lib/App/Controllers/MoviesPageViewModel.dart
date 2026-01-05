import 'package:movies_flutter/App/Controllers/LoginPageViewModel.dart';
import 'package:movies_flutter/App/MockData.dart';

import '../../Core/Abstractions/Navigation/NavigationParameters.dart';
import '../../Core/Base/MVVM/Helpers/AsyncCommand.dart';
import '../../Core/Base/MVVM/Helpers/ObservableCollection.dart';
import '../../Core/Base/MVVM/ViewModels/PageViewModel.dart';
import 'MovieDetailPageViewModel.dart';

class MoviesPageViewModel extends PageViewModel
{
  static const Name = 'MoviesPageViewModel';
  static const SELECTED_ITEM = 'SELECTED_ITEM';

  final Movies = ObservableCollection<MovieItemModel>();
  late final ItemTappedCommand = AsyncCommand(OnItemTappedCommand);
  late final ShareLogsCommand = AsyncCommand(OnShareLogsCommand);
  late final LogoutCommand = AsyncCommand(OnLogoutCommand);

  @override
  void Initialize(NavigationParameters parameters)
  {
    super.Initialize(parameters);

    this.Movies.AddRange(Mockdata.MockMovies);
    this.update();
  }

  @override
  void Destroy()
  {
    super.Destroy();
  }

  Future<void> OnItemTappedCommand(Object? param) async
  {
      final index = param as int;
      final item = this.Movies[index];

      Navigate(MovieDetailPageViewModel.Name, NavigationParameters().With(SELECTED_ITEM, item));
  }

  Future<void> OnShareLogsCommand(Object? param) async
  {

  }

  Future<void> OnLogoutCommand(Object? param) async
  {
      this.Navigate("/"+LoginPageViewModel.Name);
  }
}