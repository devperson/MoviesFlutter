
import 'package:get/get.dart';
import '../../Core/Base/BaseImplRegistrar.dart';



class BaseDependencies extends Bindings
{
  @override
  void dependencies()
  {
      BaseImplRegistrar.RegisterTypes();
  }
}


