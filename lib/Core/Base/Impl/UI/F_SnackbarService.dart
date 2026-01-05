import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_flutter/Core/Abstractions/Common/Event.dart';

import '../../../Abstractions/UI/ISnackbarService.dart';
import '../Utils/FontConstants.dart';

class F_SnackbarService implements ISnackbarService
{
  @override
  // TODO: implement PopupShowed
  Event<SeverityType> get PopupShowed => throw UnimplementedError();

  @override
  void ShowInfo(String message)
  {
    this.Show(message, SeverityType.Info);
  }

  @override
  void ShowError(String message)
  {
    this.Show(message, SeverityType.Error);
  }

  @override
  void Show(String message, SeverityType severityType, { int duration = 10000 })
  {
    final backgroundColor = _GetBackgroundColor(severityType);
    final textColor = _GetTextColor(severityType);

    Get.rawSnackbar(
      messageText: Text(
        message,
        style: TextStyle(
          color: textColor,
          fontSize: 13,
          fontFamily: FontConstants.RegularFont,
          fontWeight: FontWeight.w500,
        ),
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.all(20),
      borderRadius: 12,
      duration: Duration(milliseconds: duration),
      isDismissible: true,
      snackStyle: SnackStyle.FLOATING,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      overlayColor: Colors.black.withAlpha(75),
      overlayBlur: 0.1,
      borderColor: textColor,
      borderWidth: 0.5,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withAlpha(100),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],

      // 👇 Faster show / hide animation
      animationDuration: const Duration(milliseconds: 250),
    );
  }

  Color _GetBackgroundColor(SeverityType severityType)
  {
    switch (severityType)
    {
      case SeverityType.Info:
        return Colors.lightBlue.shade100;

      case SeverityType.Success:
        return Colors.lightGreen.shade100;

      case SeverityType.Warning:
        return Colors.orange.shade100;

      case SeverityType.Error:
        return Colors.red.shade100;
    }
  }

  Color _GetTextColor(SeverityType severityType)
  {
    switch (severityType)
    {
      case SeverityType.Info:
        return Colors.lightBlue.shade900;

      case SeverityType.Success:
        return Colors.lightGreen.shade900;

      case SeverityType.Warning:
        return Colors.orange.shade900;

      case SeverityType.Error:
        return Colors.red.shade900;
    }
  }
}
