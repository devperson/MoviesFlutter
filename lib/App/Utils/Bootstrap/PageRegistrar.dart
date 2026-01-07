import 'package:get/get.dart';
import 'package:movies_flutter/App/Controllers/AddEditMoviePageViewModel.dart';
import 'package:movies_flutter/App/Pages/AddEditMoviePage.dart';


import '../../Controllers/LoginPageViewModel.dart';
import '../../Controllers/MovieDetailPageViewModel.dart';
import '../../Controllers/MoviesPageViewModel.dart';
import '../../Pages/LoginPage.dart';
import '../../Pages/MovieDetailPage.dart';
import '../../Pages/MoviesPage.dart';

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
    GetPage(
      name: "/" + MovieDetailPageViewModel.Name,
      page: () => MovieDetailPage(),
      binding: BindingsBuilder(()
      {
        Get.lazyPut(() => MovieDetailPageViewModel());
      }),
    ),
    GetPage(
      name: "/" + AddEditMoviePageViewModel.Name,
      page: () => AddEditMoviePage(),
      binding: BindingsBuilder(()
      {
        Get.lazyPut(() => AddEditMoviePageViewModel());
      }),
    ),
  ];
}



