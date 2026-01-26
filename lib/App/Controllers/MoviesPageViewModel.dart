import 'dart:async';
import 'dart:ffi';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';
import 'package:movies_flutter/Core/Abstractions/AppServices/IInfrastructureServices.dart';

import '../../Core/Abstractions/Diagnostics/IAppLogExporter.dart';
import '../../Core/Abstractions/MVVM/NavigationParameters.dart';
import '../../Core/Base/Impl/Diagnostic/Extensions.dart';
import '../../Core/Base/Impl/MVVM/Helpers/AsyncCommand.dart';
import '../../Core/Base/Impl/MVVM/ViewModels/PageViewModel.dart';
import '../../Core/Base/Impl/Utils/LazyInjected.dart';
import '../../Core/Domain/AppService/IMovieService.dart';
import '../../Core/Domain/Dto/MovieDto.dart';
import '../Utils/Events/MovieCellItemUpdatedEvent.dart';
import 'AddEditMoviePageViewModel.dart';
import 'Items/MovieItemModel.dart';
import 'LoginPageViewModel.dart';
import 'MovieDetailPageViewModel.dart';

class MoviesPageViewModel extends PageViewModel
{
  static const Name = 'MoviesPageViewModel';
  static const SELECTED_ITEM = 'SELECTED_ITEM';
  late final String TAG = "${nameof<MoviesPageViewModel>()}";
  final appLogExporter = LazyInjected<IAppLogExporter>();
  final _infrastructureService = LazyInjected<IInfrastructureServices>();
  final movieService = LazyInjected<IMovieService>();

  List<MovieItemModel> _movies = <MovieItemModel>[];
  List<MovieItemModel> get Movies => _movies;
  set Movies(List<MovieItemModel> value)
  {
    _movies = value;
    NotifyUpdate();
  }
  late final ItemTappedCommand = AsyncCommand(OnItemTappedCommand);
  late final AddCommand = AsyncCommand(OnAddCommand);
  late final ShareLogsCommand = AsyncCommand(OnShareLogsCommand);
  late final LogoutCommand = AsyncCommand(OnLogoutCommand);
  late final MovieCellItemUpdatedEvent movieCellUpdatedEvent;

  @override
  void Initialize(NavigationParameters parameters)
  {
    try
    {
      LogMethodStart("Initialize");
      movieCellUpdatedEvent = eventAggregator.Value.GetOrCreateEvent(() => MovieCellItemUpdatedEvent());
      movieCellUpdatedEvent.Subscribe(OnMovieCellUpdatedEvent);


      unawaited(Future(() async
      {
        await _infrastructureService.Value.Start();
        await _loadData();
      }));
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
      LogMethodStart("OnNavigatedTo");

      if(parameters.ContainsKey(AddEditMoviePageViewModel.NEW_ITEM))
      {
        final movieId = GetParameter<int>(parameters, AddEditMoviePageViewModel.NEW_ITEM);
        final newMovie = await GetMovieFromDb(movieId!);
        Movies.insert(0, newMovie!);
        //update ui
        this.NotifyUpdate();
      }
      else if(parameters.ContainsKey(AddEditMoviePageViewModel.REMOVE_ITEM))
      {
        final removedId = GetParameter<int>(parameters, AddEditMoviePageViewModel.REMOVE_ITEM);
        final item = Movies.firstWhereOrNull((x) => x.id == removedId!);
        if(item != null)
        {
          Movies.remove(item);
          //update ui
          this.NotifyUpdate();
        }
      }
    }
    catch (ex, stack)
    {
      loggingService.Value.TrackError(ex, stack);
    }
  }

  @override
  ResumedFromBackground()
  {
    unawaited(Future(() async
    {
      try
      {
        LogMethodStart("ResumedFromBackground");
        await _infrastructureService.Value.Resume();
      }
      catch(ex, stackTrace)
      {
        loggingService.Value.TrackError(ex, stackTrace);
      }
    }));

  }

  @override
  void PausedToBackground()
  {
    unawaited(Future(() async
    {
      try
      {
        LogMethodStart("PausedToBackground");
        await _infrastructureService.Value.Pause();
      }
      catch(ex, stackTrace)
      {
        loggingService.Value.TrackError(ex, stackTrace);
      }
    }));
  }


  @override
  void Destroy()
  {
    unawaited(Future(() async
    {
      try
      {
        super.Destroy();//need to be called to release parent resources

        LogMethodStart("Destroy");
        await _infrastructureService.Value.Stop();
        movieCellUpdatedEvent.Unsubscribe(OnMovieCellUpdatedEvent);
      }
      catch(ex, stackTrace)
      {
        loggingService.Value.TrackError(ex, stackTrace);
      }
    }));

  }

  void OnMovieCellUpdatedEvent(Object? obj) async
  {
    LogMethodStart("OnMovieCellUpdatedEvent", args: {'item': obj});

    try
    {
      if(obj == null)
        return;

      //update movie)
      final movieId = obj as int;
      final updatedMovie = await GetMovieFromDb(movieId);
      if(updatedMovie != null)
        {
          MovieItemModel? oldItem = Movies.firstWhereOrNull((x) => x.id == movieId);
          if(oldItem != null)
            {
              final index = Movies.indexOf(oldItem);
              if (index >= 0)
              {
                Movies[index] = updatedMovie;
                //update ui
                this.NotifyUpdate();
              }
            }

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
      LogMethodStart("OnItemTappedCommand", args: {'index': param});
      //throw GetHttpException("Method not implemented");
      final index = param as int;
      final item = this.Movies[index];

      await Navigate(MovieDetailPageViewModel.Name,
          NavigationParameters().With(SELECTED_ITEM, item.id));
    }
    catch (ex, stack)
    {
      HandleUIError(ex, stack);
    }
  }

  @override
  Future<void> OnRefreshCommand(Object? param) async
  {
    try
    {
      LogMethodStart("OnRefreshCommand");

      IsRefreshing = true;

      await _loadData(getFromServer: true, showError: true);
    }
    catch (ex, stackTrace)
    {
       loggingService.Value.TrackError(ex, stackTrace);
    }
    finally
    {
      IsRefreshing = false;
    }
  }

  Future<void> OnShareLogsCommand(Object? param) async
  {
    try
    {
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
    try
    {
      LogMethodStart("OnLogoutCommand");

      final confirmed = await alertService.Value.ConfirmAlert("Confirm Action", "Are you sure want to log out?", "Yes", "No");

      if (confirmed)
      {
        await this.Navigate("/" + LoginPageViewModel.Name, NavigationParameters().With(LoginPageViewModel.LogoutRequest, true));
      }
    }
    catch (ex, stack)
    {
      HandleUIError(ex, stack);
    }
  }

  Future<void> OnAddCommand(Object? param) async
  {
    try
    {
      LogMethodStart("OnAddCommand");
      await this.Navigate(AddEditMoviePageViewModel.Name);
    }
    catch (ex, stack)
    {
      HandleUIError(ex, stack);
    }
  }


  Future<void> _loadData({bool getFromServer = false, bool showError = false}) async
  {
    try
    {
      LogMethodStart("_loadData", args: {"getFromServer": getFromServer, "showError": showError});

      final result = await ShowLoadingWithResult(() async
      {
        return movieService.Value.GetListAsync(remoteList: getFromServer);
      }, SetIsBusy: getFromServer);

      if (result.Success)
      {
        _setMovieList(result.ValueOrThrow);
      }
    }
    catch(ex, stackTrace)
    {
      loggingService.Value.TrackError(ex, stackTrace);
    }
  }

  void _setMovieList(List<MovieDto> list)
  {
    loggingService.Value.Log("${TAG}: setting data to Movies property result: ${list.ToDebugString()}");
    Movies = list.map((e) => MovieItemModel.fromDto(e)).toList();
  }

  Future<MovieItemModel?> GetMovieFromDb(int movieId) async
  {
    var result = await movieService.Value.GetById(movieId);
    if (result.Success)
    {
      var newMovie = new MovieItemModel.fromDto(result.ValueOrThrow);
      return newMovie;
    }
    else
    {
      loggingService.Value.LogWarning("MovieService.GetById() failed to get record from db");
      return null;
    }
  }


}
