
import 'package:movies_flutter/Core/Base/Impl/MVVM/ViewModels/PageViewModel.dart';

import 'NavigationParameters.dart';

abstract interface class IPageNavigationService
{
  Future<void> Navigate(String url, {NavigationParameters? parameters});

  Future<void> NavigateToRoot({NavigationParameters? parameters});

  // Widget? getCurrentPage();
   PageViewModel? GetCurrentPageModel();
  // GetxController? getRootPageModel();
   List<String> GetNavStack();

  bool get CanNavigateBack;
}