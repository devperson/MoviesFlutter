import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'App/Controllers/LoginPageViewModel.dart';
import 'App/Bootstrap/BaseDependencies.dart';
import 'App/Bootstrap/PageRegistrar.dart';
import 'Core/Base/Impl/Utils/ColorConstants.dart';

void main() {
  runApp(const MyApp());
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
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple),
                       scaffoldBackgroundColor: ColorConstants.BgColor,),
    );
  }
}
