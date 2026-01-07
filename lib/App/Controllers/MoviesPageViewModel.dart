import 'package:movies_flutter/App/Controllers/LoginPageViewModel.dart';
import 'package:movies_flutter/App/MockData.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IAppLogExporter.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/LazyInjected.dart';

import '../../Core/Abstractions/Navigation/NavigationParameters.dart';
import '../../Core/Base/MVVM/Helpers/AsyncCommand.dart';
import '../../Core/Base/MVVM/Helpers/ObservableCollection.dart';
import '../../Core/Base/MVVM/ViewModels/PageViewModel.dart';
import '../Utils/Events/MovieCellItemUpdatedEvent.dart';
import 'AddEditMoviePageViewModel.dart';
import 'MovieDetailPageViewModel.dart';

class MoviesPageViewModel extends PageViewModel
{
  static const Name = 'MoviesPageViewModel';
  static const SELECTED_ITEM = 'SELECTED_ITEM';

  final appLogExporter = LazyInjected<IAppLogExporter>();
  final Movies = ObservableCollection<MovieItemModel>();
  late final ItemTappedCommand = AsyncCommand(OnItemTappedCommand);
  late final AddCommand = AsyncCommand(OnAddCommand);
  late final ShareLogsCommand = AsyncCommand(OnShareLogsCommand);
  late final LogoutCommand = AsyncCommand(OnLogoutCommand);
  late final MovieCellItemUpdatedEvent movieCellUpdatedEvent;
  @override
  void Initialize(NavigationParameters parameters)
  {
    super.Initialize(parameters);

    movieCellUpdatedEvent = eventAggregator.Value.GetOrCreateEvent(()=>MovieCellItemUpdatedEvent());
    movieCellUpdatedEvent.Subscribe(OnMovieCellUpdatedEvent);

    this.Movies.AddRange(Mockdata.MockMovies);
    this.update();
  }

  @override
  void OnNavigatedTo(NavigationParameters parameters)
  {
    super.OnNavigatedTo(parameters);

    try
    {
      if(parameters.ContainsKey(AddEditMoviePageViewModel.NEW_ITEM))
      {
        final newProduct = GetParameter<MovieItemModel>(parameters, AddEditMoviePageViewModel.NEW_ITEM);
        Movies.Insert(0,newProduct!);
      }
      else if(parameters.ContainsKey(AddEditMoviePageViewModel.REMOVE_ITEM))
      {
        final removedItem = GetParameter<MovieItemModel>(parameters, AddEditMoviePageViewModel.REMOVE_ITEM);
        Movies.Remove(removedItem!);
      }
    }
    catch (ex, stack)
    {
      loggingService.Value.TrackError(ex, stack);
    }
  }

  @override
  void Destroy()
  {
    super.Destroy();
  }

  void OnMovieCellUpdatedEvent(Object? obj)
  {
    LogMethodStart("OnMovieCellItemUpdatedEvent", {'item': obj});

    try
    {
      final movieItem = obj as MovieItemModel;

      final oldItem = Movies.Items.firstWhere((x) => x.id == movieItem.id);
      final index = Movies.Items.indexOf(oldItem);
      if (index >= 0)
      {
        Movies.Update(index, movieItem);
        //update ui
        this.update();
      }
    }
    catch (ex, stack)
    {
      loggingService.Value.TrackError(ex, stack);
    }
  }

  Future<void> OnItemTappedCommand(Object? param) async
  {
    try
    {
      LogMethodStart("OnItemTappedCommand", {'index': param});
      final index = param as int;
      final item = this.Movies[index];

      Navigate(MovieDetailPageViewModel.Name,
          NavigationParameters().With(SELECTED_ITEM, item));
    }
    catch (ex, stack)
    {
      HandleUIError(ex, stack);
    }
  }

  Future<void> OnShareLogsCommand(Object? param) async
  {
    try {
      LogMethodStart("OnShareLogsCommand");

      final res = await appLogExporter.Value.ShareLogs();
      if(!res.Success)
      {
        final error = res.ExceptionValue.toString();
        snackbarService.Value.ShowError("Share file failed. $error");
      }
    }
    catch (ex, stack)
    {
      HandleUIError(ex, stack);
    }
  }

  Future<void> OnLogoutCommand(Object? param) async
  {
    try {
      LogMethodStart("OnLogoutCommand");

      final confirmed = await alertService.Value.ConfirmAlert("Confirm Action", "Are you sure want to log out?", "Yes", "No");

      if (confirmed)
      {
        this.Navigate("/" + LoginPageViewModel.Name, NavigationParameters().With(LoginPageViewModel.LogoutRequest, true));
      }
    }
    catch (ex, stack)
    {
      HandleUIError(ex, stack);
    }
  }

  Future<void> OnAddCommand(Object? param) async
  {
    try {
      LogMethodStart("OnAddCommand");
      this.Navigate(AddEditMoviePageViewModel.Name);
    }
    catch (ex, stack)
    {
      HandleUIError(ex, stack);
    }
  }


}