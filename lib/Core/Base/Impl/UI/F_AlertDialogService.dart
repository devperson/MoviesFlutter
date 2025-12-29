import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/ColorConstants.dart';
import '../../../Abstractions/UI/IAlertDialogService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/FontConstants.dart';

class F_AlertDialogService implements IAlertDialogService
{
  @override
  Future<void> DisplayAlert(String title, String message, { String cancel = "Close" }) async
  {
    await Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message, style: TextStyle(
                    color: ColorConstants.DefaultTextColor,
                    fontSize: 15,
                    fontFamily: FontConstants.RegularFont,
                    fontWeight: FontWeight.w500,
                  )),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(cancel),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  Future<bool> ConfirmAlert(String title, String message, String acceptBtn, String cancelBtn) async
  {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message, style: TextStyle(
                      color: ColorConstants.DefaultTextColor,
                      fontSize: 15,
                      fontFamily: FontConstants.RegularFont,
                      fontWeight: FontWeight.w500,
                    )),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelBtn,  style: TextStyle(
              color: ColorConstants.DefaultTextColor,
              fontSize: 15,
              fontFamily: FontConstants.RegularFont,
              fontWeight: FontWeight.w700,
            )),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(acceptBtn,  style: TextStyle(
              color: ColorConstants.DefaultTextColor,
              fontSize: 15,
              fontFamily: FontConstants.RegularFont,
              fontWeight: FontWeight.w700,
            )),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    return result ?? false;
  }

  @override
  Future<String?> DisplayActionSheet(String title, { String? cancel, String? destruction, List<String> buttons = const [] }) async
  {
    return await Get.bottomSheet<String>(
      SafeArea(
        child: Wrap(
          children: [
            ListTile(
              title: Center(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            ...buttons.map(
                  (text) => ListTile(
                title: Center(child: Text(text)),
                onTap: () => Get.back(result: text),
              ),
            ),

            if (destruction != null)
              ListTile(
                title: Center(
                  child: Text(
                    destruction,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                onTap: () => Get.back(result: destruction),
              ),

            if (cancel != null)
              ListTile(
                title: Center(
                  child: Text(
                    cancel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                onTap: () => Get.back(result: null),
              ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

