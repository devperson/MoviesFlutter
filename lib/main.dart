import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'App/Controllers/LoginController.dart';
import 'App/Navigation/BaseDependencies.dart';
import 'App/Navigation/PageRegistrar.dart';
import 'impl/Utils/ColorConstants.dart';

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
      initialRoute: '/' + LoginController.Name,
      getPages: PageRegistrar.pages,
      defaultTransition: Transition.rightToLeft,
      initialBinding: BaseDependencies(),
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple),
                       scaffoldBackgroundColor: ColorConstants.BgColor,),
    );
  }
}
