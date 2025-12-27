import 'package:get/get.dart';
import 'package:movies_flutter/App/Controllers/LoginController.dart';
import 'package:movies_flutter/App/Pages/LoginPage.dart';

import '../Controllers/HomeController.dart';
import '../Pages/HomePage.dart';

class PageRegistrar
{
  static final pages = [
    GetPage(
      name: "/" + LoginController.Name,
      page: () => LoginPage(),
      binding: BindingsBuilder(()
      {
        Get.lazyPut<LoginController>(() => LoginController());
      }),
    ),
    GetPage(
      name: "/" + HomeController.Name,
      page: () => HomePage(),
      binding: BindingsBuilder(()
      {
        Get.lazyPut<HomeController>(() => HomeController());
      }),
    ),
  ];
}



