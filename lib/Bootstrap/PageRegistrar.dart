import 'package:get/get.dart';
import 'package:movies_flutter/App/Controllers/AddEditMoviePageViewModel.dart';
import 'package:movies_flutter/App/Pages/AddEditMoviePage.dart';
import '../App/Controllers/LoginPageViewModel.dart';
import '../App/Controllers/MovieDetailPageViewModel.dart';
import '../App/Controllers/MoviesPageViewModel.dart';
import '../App/Pages/LoginPage.dart';
import '../App/Pages/MovieDetailPage.dart';
import '../App/Pages/MoviesPage.dart';

class PageRegistrar
{
  static final pages = [
    GetPage(
      name: "/" + LoginPageViewModel.Name,
      page: () => const LoginPage(),
      binding: BindingsBuilder(()
      {
        Get.put<LoginPageViewModel>(LoginPageViewModel()); //do not use putLazy here, it will not create viewModel with
      }),
    ),
    GetPage(
      name: "/" + MoviesPageViewModel.Name,
      page: () => const MoviesPage(),
      binding: BindingsBuilder(()
      {
        Get.put<MoviesPageViewModel>(MoviesPageViewModel());
      }),
    ),
    GetPage(
      name: "/" + MovieDetailPageViewModel.Name,
      page: () => const MovieDetailPage(),
      binding: BindingsBuilder(()
      {
        Get.put(MovieDetailPageViewModel());
      }),
    ),
    GetPage(
      name: "/" + AddEditMoviePageViewModel.Name,
      page: () => const AddEditMoviePage(),
      binding: BindingsBuilder(()
      {
        Get.put(AddEditMoviePageViewModel());
      }),
    ),
  ];
}



