abstract interface class IPageLifecycleAware
{
  void OnAppearing();
  void OnDisappearing();

  void ResumedFromBackground(Object? arg);
  void PausedToBackground(Object? arg);
}
