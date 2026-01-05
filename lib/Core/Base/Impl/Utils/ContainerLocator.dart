import 'package:get/get.dart';

class ContainerLocator
{
  static T Resolve<T>()
  {
    return Get.find<T>();
  }
}
