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

  Future<void> increment() async
  {
    var res = await alertService.Value.ConfirmAlert("Info", "Do you want to see snackbar?", "Yes", "No");
    if(res)
    {
      snackbarService.Value.ShowError("A lot of text about errors and so on; A lot of text about errors and so on; A lot of text about errors and so on; A lot of text about errors and so on;");
    }
  }

}