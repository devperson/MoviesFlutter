import '../../Core/Abstractions/MVVM/NavigationParameters.dart';
import '../../Core/Base/Impl/Diagnostic/LoggableService.dart';
import '../../Core/Base/Impl/MVVM/Helpers/AsyncCommand.dart';
import '../../Core/Base/Impl/MVVM/ViewModels/PageViewModel.dart';
import '../../Core/Base/Impl/Utils/LazyInjected.dart';
import '../../Core/Domain/AppService/IMovieService.dart';
import '../Utils/Events/MovieCellItemUpdatedEvent.dart';
import 'AddEditMoviePageViewModel.dart';
import 'Items/MovieItemModel.dart';
import 'MoviesPageViewModel.dart';

class MovieDetailPageViewModel extends PageViewModel with MovieItemLoader
{
  static const Name = 'MovieDetailPageViewModel';

  late final EditCommand = AsyncCommand(OnEditCommand);



  @override
  void Initialize(NavigationParameters parameters) async
  {
    try
    {
      LogMethodStart("Initialize");

      if(parameters.ContainsKey(MoviesPageViewModel.SELECTED_ITEM))
      {
        final movieId = parameters.GetValue(MoviesPageViewModel.SELECTED_ITEM);
        final success = await LoadMovie(movieId);
        if(success)
          NotifyUpdate();
      }  
    }
    catch(ex, stackTrace)
    {
      loggingService.Value.TrackError(ex, stackTrace);
    }
  }

  @override
  void OnNavigatedTo(NavigationParameters parameters) async
  {
    try
    {
      if (parameters.ContainsKey(AddEditMoviePageViewModel.UPDATE_ITEM))
      {
        final success = await LoadMovie(MovieItem!.id);
        if(success)
        {
          //refresh UI
          this.NotifyUpdate();
          //report to main controller
          final updateCellEvent = eventAggregator.Value.GetOrCreateEvent(()=>MovieCellItemUpdatedEvent());
          updateCellEvent.Publish(this.MovieItem!.id);
        }
      }
    }
    catch(ex, stackTrace)
    {
      loggingService.Value.TrackError(ex, stackTrace);
    }
  }

  Future<void> OnEditCommand(Object? param) async
  {
    try
    {
      LogMethodStart("OnEditCommand");

      await Navigate(AddEditMoviePageViewModel.Name, NavigationParameters().With(MoviesPageViewModel.SELECTED_ITEM, MovieItem!.id));
    }
    catch (ex, stack)
    {
      HandleUIError(ex, stack);
    }
  }


}

mixin MovieItemLoader on LoggableService
{
  final moviesService = LazyInjected<IMovieService>();
  MovieItemModel? MovieItem = null;

  Future LoadMovie(int movieId) async
  {
    var result = await moviesService.Value.GetById(movieId);
    if (result.Success)
    {
      this.MovieItem = new MovieItemModel.fromDto(result.ValueOrThrow);
      return true;
    }
    else
    {
      loggingService.Value.LogWarning("LoadMovie() for movieId: $movieId is failed");
      return false;
    }
  }
}
