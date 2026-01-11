import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:movies_flutter/App/Utils/ConstImpl.dart';
import 'package:movies_flutter/Core/Abstractions/AppServices/IConstant.dart';
import 'package:movies_flutter/Core/Domain/DomainImplRegistrar.dart';

import '../../../Core/Base/BaseImplRegistrar.dart';

class DiRegistration
{
  static Future<void> RegisterTypes() async
  {
    await BaseImplRegistrar.RegisterTypes();
    DomainImplRegistrar.RegisterTypes();

    Get.lazyPut<IConstant>(() => Constimpl(), fenix: true);
  }
}