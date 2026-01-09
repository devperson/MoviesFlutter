abstract interface class IPageLifecycleAware
{
  void OnAppearing();
  void OnDisappearing();

  void ResumedFromBackground();
  void PausedToBackground();
}
