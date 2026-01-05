import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/IPlatformOutput.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/ContainerLocator.dart';

import 'App/Controllers/LoginPageViewModel.dart';
import 'App/Bootstrap/PageRegistrar.dart';
import 'Core/Base/BaseImplRegistrar.dart';
import 'Core/Base/Impl/Utils/ColorConstants.dart';

void main() async
{
    //init the WidgetsFlutterBinding as it is required for IPreferences
    WidgetsFlutterBinding.ensureInitialized();
    await  BaseImplRegistrar.RegisterTypes();

    runZonedGuarded(()
    {
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
    return GetMaterialApp(
      title: 'Movies Flutter app',
      initialRoute: '/' + LoginPageViewModel.Name,
      getPages: PageRegistrar.pages,
      defaultTransition: Transition.rightToLeft,
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
