import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'BaseController.dart';
import 'HomeController.dart';


class LoginController extends BaseController
{
  static const Name = 'LoginController';

  var login = "";
  var password = "";


  @override
  void onInit()
  {

  }

  void Submit()
  {

    Get.toNamed('/' + HomeController.Name);
  }

  @override
  void onClose()
  {
    print('$Name disposed');
  }
}