
import 'package:get/get.dart';

import '../../../../Abstractions/MVVM/IDestructible.dart';
import '../../../../Abstractions/MVVM/IInitialize.dart';
import '../../../../Abstractions/MVVM/IPageNavigationService.dart';
import '../../../../Abstractions/MVVM/NavigationParameters.dart';
import '../../Diagnostic/LoggableService.dart';
import '../../Utils/LazyInjected.dart';
import '../Navigation/F_PageNavigationService.dart';
import 'PageViewModel.dart';


class BaseViewModel extends GetxController with LoggableService implements IDestructible, IInitialize
{
   final navigationService = LazyInjected<IPageNavigationService>();

   @override
   void Initialize(NavigationParameters parameters)
   {
      this.LogVirtualBaseMethod("Initialize");
     //Initialized.Invoke();
   }

   @override
   void Destroy()
   {
     this.LogVirtualBaseMethod("Destroy");
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

    void NotifyUpdate()
    {
      this.update();
    }


}
