import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_flutter/impl/Utils/NumConstants.dart';
import '../../impl/UI/Controls/F_EditTextField.dart';
import '../../impl/UI/Controls/F_PrimaryButton.dart';
import '../Controllers/LoginController.dart';



class LoginPage extends GetView<LoginController>
{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Login'),
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: NumConstants.pageHMargin),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16, // Flutter 3.22+
            children: [
              F_EditTextField(
                placeholder: 'Login',
                onChanged: (v) => controller.login = v
              ),

              F_EditTextField(
                placeholder: 'Password',
                isPassword: true,
                onChanged: (v) => controller.password = v,
              ),

              F_PrimaryButton(
                text: 'Submit',
                onTap: controller.Submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}