import 'package:get/get.dart';

class ContainerLocator
{
  static T Resolve<T>()
  {
    return Get.find<T>();
  }

  static T? ResolveSecure<T>()
  {
    try
    {
      return Get.find<T>();
    }
    catch(ex)
    {
      return null;
    }
  }
}
