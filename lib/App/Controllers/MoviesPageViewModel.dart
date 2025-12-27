import 'package:get/get.dart';
import '../../Core/Abstractions/Navigation/NavigationParameters.dart';
import '../../Core/Base/MVVM/ViewModels/PageViewModel.dart';

class MoviesPageViewModel extends PageViewModel
{
  static const Name = 'MoviesPageViewModel';

  var count = 0.obs;

  @override
  void Initialize(NavigationParameters parameters)
  {
    // TODO: implement Initialize
    super.Initialize(parameters);
  }



  @override
  void Destroy()
  {
    super.Destroy();
  }

  void increment()
  {
    count++;

    loggingService.Value.LogWarning("No message");
  }

}