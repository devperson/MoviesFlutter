
import '../../../../Abstractions/MVVM/INavigationAware.dart';
import '../../../../Abstractions/MVVM/NavigationParameters.dart';
import 'BaseViewModel.dart';

class NavigatingBaseViewModel extends BaseViewModel implements INavigationAware
{
  bool get CanGoBack
  {
    return navigationService.Value.CanNavigateBack;
  }

  @override
  void OnNavigatedTo(NavigationParameters parameters)
  {
      this.LogVirtualBaseMethod("OnNavigatedTo");
  }

  @override
  void OnNavigatedFrom()
  {
     this.LogVirtualBaseMethod("OnNavigatedFrom");
  }

  // NavigatingBaseViewModel? GetCurrentPageViewModel()
  // {
  //   LogVirtualBaseMethod('GetCurrentPageViewModel');
  //   return navigationService.Value.GetCurrentPageModel();
  // }

  Future<void> Navigate(String url, [NavigationParameters? parameters]) async
  {
    try
    {
      LogVirtualBaseMethod('Navigate');

      await navigationService.Value.Navigate(url, parameters: parameters);
    }
    catch (ex, stackTrace)
    {
      this.loggingService.Value.TrackError(ex, stackTrace);
    }
  }

  Future<void> NavigateToRoot([NavigationParameters? parameters]) async
  {
    try
    {
      LogVirtualBaseMethod("NavigateToRoot");

      await navigationService.Value.NavigateToRoot(parameters: parameters);
    }
    catch (ex, stackTrace)
    {
      this.loggingService.Value.TrackError(ex, stackTrace);
    }
  }

  Future<void> SkipAndNavigate(int skipCount, String route, [NavigationParameters? parameters]) async
  {
    LogVirtualBaseMethod('SkipAndNavigate',);

    final skip = '../' * skipCount;
    final newRoute = '$skip$route';

    await Navigate(newRoute, parameters);
  }

  Future<void> NavigateAndMakeRoot(String name, [NavigationParameters? parameters]) async
  {
    LogVirtualBaseMethod('NavigateAndMakeRoot');

    final newRoot = '/$name';

    await Navigate(newRoot, parameters);
  }

  Future<void> NavigateBack([NavigationParameters? parameters]) async
  {
    LogVirtualBaseMethod("NavigateBack");
    await Navigate('../', parameters);
  }

  Future<void> BackToRootAndNavigate(String name, [NavigationParameters? parameters]) async
  {
    LogVirtualBaseMethod('BackToRootAndNavigate');

    final navStack = navigationService.Value.GetNavStack();

    final String currentNavStack =
    navStack.length > 1
        ? navStack.join('/')
        : (navStack.isNotEmpty ? navStack.first : '');

    final popCount = navStack.length - 1;
    final popPageUri = popCount > 0 ? '../' * popCount : '';
    final resultUri = '$popPageUri$name';

    loggingService.Value.Log('BackToRootAndNavigate(): '
          'Current navigation stack: /$currentNavStack, '
          'pop count: $popCount, '
          'resultUri: $resultUri');

    await Navigate(resultUri, parameters);
  }

  T? GetParameter<T>(NavigationParameters parameters, String key,)
  {
    LogVirtualBaseMethod('GetParameter');

    if (parameters.ContainsKey(key))
    {
      return parameters.GetValue<T>(key);
    }

    return null;
  }

  void GetParameterWithSetter<T>(NavigationParameters parameters, String key, void Function(T?) setter)
  {
    LogVirtualBaseMethod('GetParameter');

    if (parameters.ContainsKey(key))
    {
      final value = parameters.GetValue<T>(key);
      setter(value);
    }
  }
}
