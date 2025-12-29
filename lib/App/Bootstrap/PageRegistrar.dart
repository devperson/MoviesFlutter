import 'package:get/get.dart';
import 'package:movies_flutter/App/Controllers/LoginPageViewModel.dart';
import 'package:movies_flutter/App/Pages/LoginPage.dart';

import '../Controllers/MoviesPageViewModel.dart';
import '../Pages/MoviesPage.dart';

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
      page: () => MoviesPage(),
      binding: BindingsBuilder(()
      {
        Get.lazyPut<MoviesPageViewModel>(() => MoviesPageViewModel());
      }),
    ),
  ];
}



