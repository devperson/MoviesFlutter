import 'package:movies_flutter/Core/Abstractions/Essentials/IMediaPickerService.dart';

import '../../Core/Abstractions/AppServices/Some.dart';
import '../../Core/Abstractions/Navigation/NavigationParameters.dart';
import '../../Core/Base/Impl/Utils/LazyInjected.dart';
import '../../Core/Base/MVVM/Helpers/AsyncCommand.dart';
import '../../Core/Base/MVVM/ViewModels/PageViewModel.dart';
import '../MockData.dart';
import 'MoviesPageViewModel.dart';

class AddEditMoviePageViewModel extends PageViewModel
{
  final mediaPickerService = LazyInjected<IMediaPickerService>();
  static const Name = 'AddEditMoviePageViewModel';
  static const NEW_ITEM = 'NEW_ITEM';
  static const UPDATE_ITEM = 'UPDATE_ITEM';
  static const REMOVE_ITEM = 'REMOVE_ITEM';
  late MovieItemModel MovieItem;
  late final SaveCommand = AsyncCommand(OnSaveCommand);
  late final ChangePhotoCommand = AsyncCommand(OnChangePhotoCommand);
  late final DeleteCommand = AsyncCommand(OnDeleteCommand);
  bool IsEdit = false;

  @override
  void Initialize(NavigationParameters parameters)
  {
    LogMethodStart("Initialize");
    super.Initialize(parameters);

    if (parameters.ContainsKey(MoviesPageViewModel.SELECTED_ITEM))
    {
      this.IsEdit = true;
      this.MovieItem = parameters.GetValue<MovieItemModel>(MoviesPageViewModel.SELECTED_ITEM)!;
      this.Title.value = "Edit";
    }
    else
    {
      this.MovieItem = MovieItemModel();
      this.Title.value = "Add new";
    }
  }


  @override
  void Destroy()
  {
    super.Destroy();
  }

  Future<void> OnSaveCommand(Object? param) async
  {
    try
    {
      LogMethodStart("OnSaveCommand");

      if (MovieItem.title.isEmpty)
      {
        snackbarService.Value.ShowError("The Name field is required");
        return;
      }
      else if (MovieItem.overview.isEmpty)
      {
        snackbarService.Value.ShowError("The Overview field is required");
        return;
      }


      final key = IsEdit ? UPDATE_ITEM : NEW_ITEM;
      NavigateBack(NavigationParameters().With(key, MovieItem));

      // Some<MovieDto>? Result;
      //
      // if (IsEdit)
      // {
      //   // TODO: use mapper
      //   final dtoModel = Model!.ToDto();
      //   Result = await movieService.UpdateAsync(dtoModel);
      // }
      // else
      // {
      //   Result = await movieService.AddAsync(
      //     Model!.Name!,
      //     Model!.Overview!,
      //     Model!.PosterUrl,
      //   );
      // }

      // if (Result.Success)
      // {
      //   final item = MovieItemViewModel(Result.ValueOrThrow);
      //   final key = IsEdit ? UPDATE_ITEM : NEW_ITEM;
      //
      //   NavigateBack(
      //     NavigationParameters()
      //       ..add(key, item),
      //   );
      // }
      // else
      // {
      //   snackbarService.Value.ShowError(CommonStrings.GeneralError);
      // }
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
      final deleteText = (MovieItem.posterPath.isNotEmpty ?? false) ? "Delete" : null;

      final buttons = ["Pick Photo", "Take Photo"];

      final actionResult =
      await alertService.Value.DisplayActionSheet("Set photo from", cancel: "Cancel", destruction: deleteText, buttons: buttons,);

      if (actionResult == buttons[0])
      {
        final photo = await mediaPickerService.Value.GetPhotoAsync();

        if (photo != null)
        {
          MovieItem.posterPath = photo.FilePath;
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
          MovieItem.posterPath = photo.FilePath;
        }
        else
        {
          loggingService.Value.LogWarning("AddEditMoviePageViewModel: takePhotoAsync() returned null",);
        }
      }
      else if (actionResult == deleteText)
      {
        MovieItem.posterPath = "";
      }
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
        // final dtoModel = MovieItem!.ToDto();
        // final result = await movieService.RemoveAsync(dtoModel);

        // if (result.Success)
        // {
          NavigateToRoot(
            NavigationParameters().With(REMOVE_ITEM, MovieItem),
          );
        // }
        // else
        // {
        //   snackbarService.Value.ShowError(CommonStrings.GeneralError);
        // }
      }
    }
    catch (ex, stack)
    {
      HandleUIError(ex, stack);
    }
  }
}