import 'package:movies_flutter/Core/Domain/DomainImplRegistrar.dart';

import '../../../Core/Base/BaseImplRegistrar.dart';

class DiRegistration
{
  static Future<void> RegisterTypes() async
  {
    await BaseImplRegistrar.RegisterTypes();
    DomainImplRegistrar.RegisterTypes();
  }
}