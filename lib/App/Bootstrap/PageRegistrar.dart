import 'package:get/get.dart';
import 'package:movies_flutter/App/Controllers/LoginPageViewModel.dart';
import 'package:movies_flutter/App/Pages/LoginPage.dart';

import '../Controllers/MoviesPageViewModel.dart';
import '../Pages/HomePage.dart';

class PageRegistrar
{
  static final pages = [
    GetPage(
      name: "/" + LoginPageViewModel.Name,
      page: () => LoginPage(),
      binding: BindingsBuilder(()
      {
        Get.lazyPut<LoginPageViewModel>(() => LoginPageViewModel());
      }),
    ),
    GetPage(
      name: "/" + MoviesPageViewModel.Name,
      page: () => HomePage(),
      binding: BindingsBuilder(()
      {
        Get.lazyPut<MoviesPageViewModel>(() => MoviesPageViewModel());
      }),
    ),
  ];
}



