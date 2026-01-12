import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movies_flutter/App/Controllers/AddEditMoviePageViewModel.dart';
import 'package:movies_flutter/App/Controllers/MoviesPageViewModel.dart';
import 'package:movies_flutter/App/Utils/ConstImpl.dart';
import 'package:movies_flutter/Core/Abstractions/AppServices/IConstant.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IErrorTrackingService.dart';
import 'package:movies_flutter/Core/Base/BaseImplRegistrar.dart';
import 'package:movies_flutter/Core/Domain/DomainImplRegistrar.dart';

import '../Impl/PageViewModelResolver.dart';

class IntegrationDI
{
  static Future<void> RegisterTypes() async
  {
    await BaseImplRegistrar.RegisterTypes();
    DomainImplRegistrar.RegisterTypes();

    Get.lazyPut<IErrorTrackingService>(()=> ErrorTrackingServiceMock(), fenix: true);
    Get.lazyPut<IConstant>(() => Constimpl(), fenix: true);
    //register pages
    PageViewModelResolver.Register<MoviesPageViewModel>(nameOf<MoviesPageViewModel>(),() => MoviesPageViewModel());
    PageViewModelResolver.Register<MoviesPageViewModel>(nameOf<AddEditMoviePageViewModel>(),() => AddEditMoviePageViewModel());
  }

  static String nameOf<T>() => T.toString();
}


class ErrorTrackingServiceMock extends Mock implements IErrorTrackingService {}
