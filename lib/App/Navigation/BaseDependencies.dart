
import 'package:get/get.dart';
//import 'package:movies_flutter/impl/Services/LoggingService.dart';

import '../../Core/Abstractions/Diagnostics/ILoggingService.dart';
import '../../impl/Services/LoggingService.dart';
import '../Controllers/HomeController.dart';


class BaseDependencies extends Bindings
{
  @override
  void dependencies()
  {
     Get.lazyPut<ILoggingService>(() => LoggingService(), fenix: true);
  }
}


