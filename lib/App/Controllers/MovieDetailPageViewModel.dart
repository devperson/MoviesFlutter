

import 'package:movies_flutter/App/MockData.dart';

import '../../Core/Abstractions/Navigation/NavigationParameters.dart';
import '../../Core/Base/MVVM/ViewModels/PageViewModel.dart';
import 'MoviesPageViewModel.dart';

class MovieDetailPageViewModel extends PageViewModel
{
  static const Name = 'MovieDetailPageViewModel';
  late MovieItemModel MovieItem;

  @override
  void Initialize(NavigationParameters parameters)
  {
    super.Initialize(parameters);

    if(parameters.ContainsKey(MoviesPageViewModel.SELECTED_ITEM))
    {
      MovieItem = parameters.GetValue(MoviesPageViewModel.SELECTED_ITEM);
    }
  }

  @override
  void Destroy()
  {
    super.Destroy();
  }
}