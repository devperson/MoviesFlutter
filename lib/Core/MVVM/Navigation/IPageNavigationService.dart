abstract interface class IPageNavigationService
{
  Future<void> Navigate(String url, { Map<String, dynamic>? parameters});

  Future<void> NavigateToRoot({Map<String, dynamic>? parameters});

  // Widget? getCurrentPage();
  // GetxController? getCurrentPageModel();
  // GetxController? getRootPageModel();
  // List<GetxController> getNavStackModels();

  bool get CanNavigateBack;
}