
import 'package:get/get.dart';

import '../../../../Abstractions/MVVM/IPageNavigationService.dart';
import '../../../../Abstractions/MVVM/NavigationParameters.dart';
import '../../Diagnostic/LoggableService.dart';
import '../../Utils/LazyInjected.dart';
import '../Navigation/F_PageNavigationService.dart';
import 'PageViewModel.dart';


class BaseViewModel extends GetxController with LoggableService
{
   final navigationService = LazyInjected<IPageNavigationService>();

   void Initialize(NavigationParameters parameters)
   {
      this.LogVirtualBaseMethod();
     //Initialized.Invoke();
   }

   void Destroy()
   {
     this.LogVirtualBaseMethod();
     //OnDestroyed.Invoke();
   }

    @override
    void onInit()
    {
        super.onInit();

        //we use own viewmodels stack as GetX does not help as to get info about current viewmodels stack
        var getx_navService = navigationService.Value as F_PageNavigationService;
        getx_navService.vmStack.add(this as PageViewModel);

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
      getx_navService.vmStack.remove(this as PageViewModel);

      this.Destroy();
    }


}