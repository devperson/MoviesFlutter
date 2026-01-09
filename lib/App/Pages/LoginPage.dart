import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Core/Base/Impl/UI/Controls/F_EditTextField.dart';
import '../../Core/Base/Impl/UI/Controls/F_PrimaryButton.dart';
import '../../Core/Base/Impl/Utils/NumConstants.dart';
import '../Controllers/LoginPageViewModel.dart';



class LoginPage extends StatelessWidget
{
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginPageViewModel>(
        builder: (controller) {
          return Scaffold(
            // appBar: AppBar(
            //   title: const Text('Login'),
            // ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: NumConstants.pageHMargin),
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
                      onTap: () {
                        controller.SubmitCommand.Execute();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}