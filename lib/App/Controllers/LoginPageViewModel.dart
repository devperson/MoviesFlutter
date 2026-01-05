import '../../Core/Abstractions/Navigation/NavigationParameters.dart';
import '../../Core/Base/MVVM/ViewModels/PageViewModel.dart';
import 'MoviesPageViewModel.dart';


class LoginPageViewModel extends PageViewModel
{
    static const Name = 'LoginPageViewModel';

    var login = "";
    var password = "";


    @override
    void Initialize(NavigationParameters parameters)
    {
      LogMethodStart("Initialize");
      super.Initialize(parameters);
    }

    void Submit()
    {
        this.Navigate("/"+MoviesPageViewModel.Name);
    }

    @override
    void Destroy()
    {
      super.Destroy();
    }
}