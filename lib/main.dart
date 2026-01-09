import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_flutter/App/Controllers/MoviesPageViewModel.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IPlatformOutput.dart';
import 'package:movies_flutter/Core/Abstractions/Essentials/IPreferences.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/ContainerLocator.dart';

import 'App/Controllers/LoginPageViewModel.dart';
import 'App/Utils/Bootstrap/DiRegistration.dart';
import 'App/Utils/Bootstrap/PageRegistrar.dart';
import 'Core/Abstractions/MVVM/IPageNavigationService.dart';
import 'Core/Base/Impl/MVVM/Navigation/F_PageNavigationService.dart';
import 'Core/Base/Impl/Utils/ColorConstants.dart';

void main()
{
  unawaited(
    runZonedGuarded(() async {
      //init the WidgetsFlutterBinding as it is required for IPreferences, and for similar platform services
      // MUST be inside the same zone as runApp
      WidgetsFlutterBinding.ensureInitialized();
      await DiRegistration.RegisterTypes();

      runApp(const MyApp());
    },
    (error, stack)
    {
      final console = ContainerLocator.Resolve<IPlatformOutput>();
      if(console.IsInited == false)
      {
        console.Init();
      }
       console.Error('Unhandled crash:', error: error, stackTrace: stack);
    }));
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)
  {
    //Resove initial page from preferences
    final pref = ContainerLocator.Resolve<IPreferences>();
    final isLoggedIn = pref.Get(LoginPageViewModel.IsLoggedIn, false);
    final initialPage = isLoggedIn ? MoviesPageViewModel.Name : LoginPageViewModel.Name;

    // The initial page is set by GetX, not by NavService.
    // NavService needs to be informed about the initial page.
    // All subsequent navigation is handled by NavService.
    final navService = ContainerLocator.Resolve<IPageNavigationService>() as F_PageNavigationService;
    navService.SetInitialPage(initialPage);

    //set logging navigation to true by default
    //pref.Set(SpecificLoggingKeys.LogUINavigationKey, true);

    return GetMaterialApp(
      title: 'Movies Flutter app',
      initialRoute: '/' + initialPage,
      getPages: PageRegistrar.pages,
      defaultTransition: Transition.rightToLeft,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                        appBarTheme: const AppBarTheme(
                          backgroundColor: ColorConstants.BgColor,  //all page background color
                          foregroundColor: ColorConstants.DefaultTextColor, // all text title + icons colors
                          elevation: 0,
                          centerTitle: true,),
                       scaffoldBackgroundColor: ColorConstants.BgColor,),
    );
  }
}
