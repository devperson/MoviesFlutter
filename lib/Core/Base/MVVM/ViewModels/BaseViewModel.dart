
import 'package:get/get.dart';

import '../../../Abstractions/Navigation/IPageNavigationService.dart';
import '../../Impl/Navigation/F_PageNavigationService.dart';
import '../../Impl/Utils/LazyInjected.dart';
import '../../../Abstractions/Navigation/NavigationParameters.dart';
import '../../Impl/Diagnostic/LoggableService.dart';
import 'NavigatingBaseViewModel.dart';


class BaseViewModel extends GetxController with LoggableService
{
   final navigationService = LazyInjected<IPageNavigationService>();

   void Initialize(NavigationParameters parameters)
   {
     //Initialized.Invoke();
   }

   void Destroy()
   {
     //OnDestroyed.Invoke();
   }

    @override
    void onInit()
    {
        super.onInit();

        //we use own viewmodels stack as GetX does not help as to get info about current viewmodels stack
        var getx_navService = navigationService.Value as F_PageNavigationService;
        getx_navService.vmStack.add(this as NavigatingBaseViewModel);

        late NavigationParameters navParams;
        if(Get.arguments is NavigationParameters)
        {
          navParams = Get.arguments as NavigationParameters;
        }
        else
        {
          navParams = NavigationParameters();
        }
        this.Initialize(navParams);
    }

    @override
    void onClose()
    {
      //we use own viewmodels stack as GetX does not help as to get info about current viewmodels stack
      var getx_navService = navigationService.Value as F_PageNavigationService;
      getx_navService.vmStack.remove(this as NavigatingBaseViewModel);

      this.Destroy();
    }


}