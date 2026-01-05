import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'App/Controllers/LoginPageViewModel.dart';
import 'App/Bootstrap/BaseDependencies.dart';
import 'App/Bootstrap/PageRegistrar.dart';
import 'Core/Base/Impl/Diagnostic/F_PlatformOutput.dart';
import 'Core/Base/Impl/Utils/ColorConstants.dart';

void main()
{
    final outputLog = F_PlatformOutput();
    runZonedGuarded(()
    {
      runApp(const MyApp());
    },
    (error, stack)
    {
       outputLog.Error('Unhandled crash:', error: error, stackTrace: stack, isHandled: false);
    });
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)
  {
    return GetMaterialApp(
      title: 'Movies Flutter app',
      initialRoute: '/' + LoginPageViewModel.Name,
      getPages: PageRegistrar.pages,
      defaultTransition: Transition.rightToLeft,
      initialBinding: BaseDependencies(),
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                        appBarTheme: const AppBarTheme(
                          backgroundColor: ColorConstants.BgColor,
                          foregroundColor: ColorConstants.DefaultTextColor, // title + icons
                          elevation: 0,
                          centerTitle: true,),
                       scaffoldBackgroundColor: ColorConstants.BgColor,),
    );
  }
}
