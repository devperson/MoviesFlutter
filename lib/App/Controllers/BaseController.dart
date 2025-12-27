

import 'package:get/get.dart';

import '../../Core/Abstractions/Diagnostics/ILoggingService.dart';


class BaseController extends GetxController
{
  late final ILoggingService loggingService = Get.find<ILoggingService>();
}