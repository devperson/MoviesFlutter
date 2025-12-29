import 'package:movies_flutter/Core/Abstractions/UI/IAlertDialogService.dart';
import 'package:movies_flutter/Core/Abstractions/UI/ISnackbarService.dart';
import 'package:movies_flutter/Core/Base/MVVM/ViewModels/NavigatingBaseViewModel.dart';

import '../../Impl/Utils/LazyInjected.dart';

class PageViewModel extends NavigatingBaseViewModel
{
   final snackbarService = LazyInjected<ISnackbarService>();
   final alertService = LazyInjected<IAlertDialogService>();
}