

import 'package:movies_flutter/App/MockData.dart';

import '../../Core/Abstractions/Navigation/NavigationParameters.dart';
import '../../Core/Base/MVVM/Helpers/AsyncCommand.dart';
import '../../Core/Base/MVVM/ViewModels/PageViewModel.dart';
import '../Utils/Events/MovieCellItemUpdatedEvent.dart';
import 'AddEditMoviePageViewModel.dart';
import 'MoviesPageViewModel.dart';

class MovieDetailPageViewModel extends PageViewModel
{
  static const Name = 'MovieDetailPageViewModel';
  late MovieItemModel MovieItem;
  late final EditCommand = AsyncCommand(OnEditCommand);

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
  void OnNavigatedTo(NavigationParameters parameters)
  {
    super.OnNavigatedTo(parameters);

    if (parameters.ContainsKey(AddEditMoviePageViewModel.UPDATE_ITEM))
    {
      this.MovieItem = parameters.GetValue<MovieItemModel>(AddEditMoviePageViewModel.UPDATE_ITEM)!;
      final updateCellEvent = eventAggregator.Value.GetOrCreateEvent(()=>MovieCellItemUpdatedEvent());
      updateCellEvent.Publish(this.MovieItem);

      //refresh UI
      this.update();
    }
  }

  @override
  void Destroy()
  {
    super.Destroy();
  }

  Future<void> OnEditCommand(Object? param) async
  {
    try
    {
      LogMethodStart("OnEditCommand");

      await Navigate(AddEditMoviePageViewModel.Name, NavigationParameters().With(MoviesPageViewModel.SELECTED_ITEM, MovieItem));
    }
    catch (ex, stack)
    {
      HandleUIError(ex, stack);
    }
  }
}