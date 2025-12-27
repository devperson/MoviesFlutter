
import 'NavigationParameters.dart';

abstract interface class IPageNavigationService
{
  Future<void> Navigate(String url, {NavigationParameters? parameters});

  Future<void> NavigateToRoot({NavigationParameters? parameters});

  // Widget? getCurrentPage();
  // GetxController? getCurrentPageModel();
  // GetxController? getRootPageModel();
   List<String> GetNavStack();

  bool get CanNavigateBack;
}