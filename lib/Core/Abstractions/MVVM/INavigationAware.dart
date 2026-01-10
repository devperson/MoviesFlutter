import 'NavigationParameters.dart';

abstract interface class INavigationAware
{
  /// Called when the implementer has been navigated away from.
  void OnNavigatedFrom();

  /// Called when the implementer has been navigated to.
  void OnNavigatedTo(NavigationParameters parameters);
}
