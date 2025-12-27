import 'package:get/get.dart';
import 'BaseController.dart';

class HomeController extends BaseController
{
  static const Name = 'HomeController';

  var count = 0.obs;

  void increment()
  {
    count++;

    loggingService.LogWarning("No message");
  }

  @override
  void onInit()
  {
    super.onInit();

    final navParameters = Get.arguments as Map<String, dynamic>?;
    final id = navParameters?["id"];

    if(id != null)
    {
      print("Got $id");
    }
  }

  @override
  void onClose()
  {
    print('$Name disposed');
  }
}