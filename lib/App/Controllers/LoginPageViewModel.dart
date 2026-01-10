import 'package:movies_flutter/Core/Abstractions/Essentials/IPreferences.dart';
import '../../Core/Abstractions/MVVM/NavigationParameters.dart';
import '../../Core/Base/Impl/MVVM/Helpers/AsyncCommand.dart';
import '../../Core/Base/Impl/MVVM/ViewModels/PageViewModel.dart';
import '../../Core/Base/Impl/Utils/LazyInjected.dart';
import 'MoviesPageViewModel.dart';


class LoginPageViewModel extends PageViewModel
{
    final preferenceServices = LazyInjected<IPreferences>();

    static const Name = 'LoginPageViewModel';
    static const LogoutRequest = 'LogoutRequest';
    static const IsLoggedIn = 'IsLoggedIn';

    var login = "";
    var password = "";
    late final SubmitCommand = AsyncCommand(OnSubmitCommand);

    @override
    void Initialize(NavigationParameters parameters)
    {
      super.Initialize(parameters);

      if(parameters.ContainsKey(LogoutRequest))
      {
        preferenceServices.Value.Set(IsLoggedIn, false);
      }
    }

    Future<void> OnSubmitCommand(Object? obj) async
    {
        LogMethodStart("OnSubmitCommand");
        preferenceServices.Value.Set(IsLoggedIn, true);
        await this.Navigate("/${nameof<MoviesPageViewModel>()}");
    }

    @override
    void Destroy()
    {
      super.Destroy();
    }
}
