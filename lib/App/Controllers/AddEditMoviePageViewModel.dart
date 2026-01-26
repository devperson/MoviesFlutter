import 'package:flutter/cupertino.dart';
import 'package:movies_flutter/Core/Domain/AppService/IMovieService.dart';

import '../../Core/Abstractions/AppServices/Some.dart';
import '../../Core/Abstractions/Essentials/IMediaPickerService.dart';
import '../../Core/Abstractions/MVVM/NavigationParameters.dart';
import '../../Core/Base/Impl/MVVM/Helpers/AsyncCommand.dart';
import '../../Core/Base/Impl/MVVM/ViewModels/PageViewModel.dart';
import '../../Core/Base/Impl/Utils/LazyInjected.dart';
import '../../Core/Domain/Dto/MovieDto.dart';
import '../Utils/CommonStrings.dart';
import 'Items/MovieItemModel.dart';
import 'MovieDetailPageViewModel.dart';
import 'MoviesPageViewModel.dart';

class AddEditMoviePageViewModel extends PageViewModel with MovieItemLoader
{
  final mediaPickerService = LazyInjected<IMediaPickerService>();
  static const Name = 'AddEditMoviePageViewModel';
  static const NEW_ITEM = 'NEW_ITEM';
  static const UPDATE_ITEM = 'UPDATE_ITEM';
  static const REMOVE_ITEM = 'REMOVE_ITEM';
  late final SaveCommand = AsyncCommand(OnSaveCommand);
  late final ChangePhotoCommand = AsyncCommand(OnChangePhotoCommand);
  late final DeleteCommand = AsyncCommand(OnDeleteCommand);
  bool IsEdit = false;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final intGenerator = IntIdGenerator();

  @override
  void Initialize(NavigationParameters parameters) async
  {
    super.Initialize(parameters);

    if (parameters.ContainsKey(MoviesPageViewModel.SELECTED_ITEM))
    {
      this.Title = "Edit";
      this.IsEdit = true;
      final movieId = parameters.GetValue<int>(MoviesPageViewModel.SELECTED_ITEM)!;

      final success = await LoadMovie(movieId);
      if(success)
      {
        this.NotifyUpdate();
      }    
    }
    else
    {
      this.Title = "Create new";
      this.MovieItem = MovieItemModel();
      this.MovieItem!.id = intGenerator.next();
    }

    // Prefill from model
    titleController.text = MovieItem!.title;
    descriptionController.text = MovieItem!.overview;

    // Keep model in sync
    titleController.addListener(() {
      MovieItem!.title = titleController.text;
    });

    descriptionController.addListener(() {
      MovieItem!.overview = descriptionController.text;
    });
  }


  @override
  void Destroy()
  {
    super.Destroy();

    titleController.dispose();
    descriptionController.dispose();
  }

  Future<void> OnSaveCommand(Object? param) async
  {
    try
    {
      LogMethodStart("OnSaveCommand");

      if (MovieItem!.title.isEmpty)
      {
        snackbarService.Value.ShowError("The Name field is required");
        return;
      }
      else if (MovieItem!.overview.isEmpty)
      {
        snackbarService.Value.ShowError("The Overview field is required");
        return;
      }

      Some<MovieDto>? Result;
      bool succes = false;
      int movieId = 0;
      if (IsEdit)
      {
        // TODO: use mapper
        final dtoModel = MovieItem!.toDto();
        final result = await moviesService.Value.UpdateAsync(dtoModel);
        succes = result.Success;
        movieId = MovieItem!.id;

      }
      else
      {
        final result = await moviesService.Value.AddAsync(
          MovieItem!.title,
          MovieItem!.overview,
          MovieItem!.posterPath,
        );
        succes = result.Success;
        movieId = result.ValueOrThrow;
      }

      if (succes)
      {
        final key = IsEdit ? UPDATE_ITEM : NEW_ITEM;

        await NavigateBack(NavigationParameters().With(key, movieId));
      }
      else
      {
        snackbarService.Value.ShowError(CommonStrings.GeneralError);
      }
    }
    catch (ex, stack)
    {
      HandleUIError(ex, stack);
    }
  }

  Future<void> OnChangePhotoCommand(Object? param) async
  {
    LogMethodStart("OnChangePhotoCommand");

    try
    {
      final deleteText = MovieItem!.posterPath.isNotEmpty ? "Delete" : null;

      final buttons = ["Pick Photo", "Take Photo"];

      final actionResult =
      await alertService.Value.DisplayActionSheet("Set photo from", cancel: "Cancel", destruction: deleteText, buttons: buttons,);

      if (actionResult == buttons[0])
      {
        final photo = await mediaPickerService.Value.GetPhotoAsync();

        if (photo != null)
        {
          MovieItem!.posterPath = photo.FilePath;
        }
        else
        {
          loggingService.Value.LogWarning("AddEditMoviePageViewModel: getPhotoAsync() returned null",);
        }
      }
      else if (actionResult == buttons[1])
      {
        final photo = await mediaPickerService.Value.TakePhotoAsync();

        if (photo != null)
        {
          MovieItem!.posterPath = photo.FilePath;
        }
        else
        {
          loggingService.Value.LogWarning("AddEditMoviePageViewModel: takePhotoAsync() returned null",);
        }
      }
      else if (actionResult == deleteText)
      {
        MovieItem!.posterPath = "";
      }

      this.NotifyUpdate();
    }
    catch (ex, stack)
    {
      HandleUIError(ex, stack);
    }
  }

  Future<void> OnDeleteCommand(Object? param) async
  {
    try
    {
      LogMethodStart("OnDeleteCommand");

      final res = await alertService.Value.ConfirmAlert(
        "Confirm",
        "Are you sure you want to delete this item?",
        "Yes",
        "No",
      );

      if (res == true)
      {
        final result = await moviesService.Value.RemoveAsync(MovieItem!.id);

        if (result.Success)
        {
          await NavigateToRoot(NavigationParameters().With(REMOVE_ITEM, MovieItem!.id));
        }
        else
        {
          snackbarService.Value.ShowError(CommonStrings.GeneralError);
        }
      }
    }
    catch (ex, stack)
    {
      HandleUIError(ex, stack);
    }
  }
}
