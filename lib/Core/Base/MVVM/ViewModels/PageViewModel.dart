import 'package:movies_flutter/Core/Abstractions/Navigation/NavigationParameters.dart';
import 'package:movies_flutter/Core/Abstractions/UI/IAlertDialogService.dart';
import 'package:movies_flutter/Core/Abstractions/UI/ISnackbarService.dart';
import 'package:movies_flutter/Core/Base/MVVM/ViewModels/NavigatingBaseViewModel.dart';

import '../../Impl/Utils/LazyInjected.dart';
import '../Helpers/AsyncCommand.dart';

class PageViewModel extends NavigatingBaseViewModel
{
   late final AsyncCommand BackCommand = AsyncCommand(OnBackCommand);
   final snackbarService = LazyInjected<ISnackbarService>();
   final alertService = LazyInjected<IAlertDialogService>();

  Future<void> OnBackCommand(Object? param) async
  {
    this.LogVirtualBaseMethod("OnBackCommand");
    this.NavigateBack(NavigationParameters());
  }
}