import 'dart:async';
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
    super.Initialize(parameters);

    movieCellUpdatedEvent = eventAggregator.Value.GetOrCreateEvent(()=>MovieCellItemUpdatedEvent());
    movieCellUpdatedEvent.Subscribe(OnMovieCellUpdatedEvent);


    unawaited( Future(() async
    {
      await _infrastructureService.Value.Start();
      await _loadData();
    }));
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
        Movies.insert(0,newProduct!);

        //update ui
        this.NotifyUpdate();
      }
      else if(parameters.ContainsKey(AddEditMoviePageViewModel.REMOVE_ITEM))
      {
        final removedItem = GetParameter<MovieItemModel>(parameters, AddEditMoviePageViewModel.REMOVE_ITEM);
        Movies.remove(removedItem!);

        //update ui
        this.NotifyUpdate();
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
        LogMethodStart();
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
        LogMethodStart();
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
        super.Destroy();

        LogMethodStart();
        await _infrastructureService.Value.Stop();
        movieCellUpdatedEvent.Unsubscribe(OnMovieCellUpdatedEvent);
      }
      catch(ex, stackTrace)
      {
        loggingService.Value.TrackError(ex, stackTrace);
      }
    }));

  }

  void OnMovieCellUpdatedEvent(Object? obj)
  {
    LogMethodStart(args: {'item': obj});

    try
    {
      final movieItem = obj as MovieItemModel;

      final oldItem = Movies.firstWhere((x) => x.id == movieItem.id);
      final index = Movies.indexOf(oldItem);
      if (index >= 0)
      {
        Movies[index] = movieItem;
        //update ui
        this.NotifyUpdate();
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
      LogMethodStart(args: {'index': param});
      final index = param as int;
      final item = this.Movies[index];

      await Navigate(MovieDetailPageViewModel.Name,
          NavigationParameters().With(SELECTED_ITEM, item));
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
    try {
      LogMethodStart();

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
      LogMethodStart();

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
    try {
      LogMethodStart();
      await this.Navigate(AddEditMoviePageViewModel.Name);
    }
    catch (ex, stack)
    {
      HandleUIError(ex, stack);
    }
  }


  Future<void> _loadData({bool getFromServer = false, bool showError = false}) async
  {
    try {
      LogMethodStart(args: {"getFromServer": getFromServer, "showError": showError});

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


}