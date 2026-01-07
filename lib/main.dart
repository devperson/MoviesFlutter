import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_flutter/App/Controllers/MoviesPageViewModel.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IPlatformOutput.dart';
import 'package:movies_flutter/Core/Abstractions/Essentials/IPreferences.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/ContainerLocator.dart';

import 'App/Controllers/LoginPageViewModel.dart';
import 'App/Utils/Bootstrap/PageRegistrar.dart';
import 'Core/Base/BaseImplRegistrar.dart';
import 'Core/Base/Impl/Utils/ColorConstants.dart';

void main()
{
    runZonedGuarded(() async {
      //init the WidgetsFlutterBinding as it is required for IPreferences, and for similar platform services
      // MUST be inside the same zone as runApp
      WidgetsFlutterBinding.ensureInitialized();
      await BaseImplRegistrar.RegisterTypes();

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
    });
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)
  {
    final pref = ContainerLocator.Resolve<IPreferences>();
    final isLoggedIn = pref.Get(LoginPageViewModel.IsLoggedIn, false);
    final initialPage = isLoggedIn ? MoviesPageViewModel.Name : LoginPageViewModel.Name;

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
