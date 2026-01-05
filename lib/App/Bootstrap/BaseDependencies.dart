
import 'package:get/get.dart';
import '../../Core/Abstractions/Diagnostics/ILoggingService.dart';
import '../../Core/Base/BaseImplRegistrar.dart';
import '../../Core/Base/Impl/Diagnostic/F_LoggingService.dart';



class BaseDependencies extends Bindings
{
  @override
  void dependencies()
  {
      //We don't need GETX built-in dependencies initialization
      // because we have complex initialization logic
      // see RegisterTypes() usage
  }

  static void RegisterTypes()
  {
    BaseImplRegistrar.RegisterTypes();
  }
}


