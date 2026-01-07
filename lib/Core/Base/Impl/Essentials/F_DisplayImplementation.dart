import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../Abstractions/Diagnostics/ILoggingService.dart';
import '../../../Abstractions/Essentials/Display/DisplayInfo.dart';
import '../../../Abstractions/Essentials/Display/DisplayOrientation.dart';
import '../../../Abstractions/Essentials/Display/DisplayRotation.dart';
import '../../../Abstractions/Essentials/Display/IDisplay.dart';
import '../Diagnostic/LoggableService.dart';


class F_DisplayImplementation with LoggableService implements IDisplay
{
  F_DisplayImplementation()
  {
    InitSpecificlogger(SpecificLoggingKeys.LogEssentialServices);
  }

  // ----------------------------------------------------------
  // Keep screen on
  // ----------------------------------------------------------

  @override
  bool GetDisplayKeepOnValue()
  {
    SpecificLogMethodStart('GetDisplayKeepOnValue');

    // wakelock_plus exposes async state only
    // so we track desired state locally if needed
    // For parity, return true if enabled
    // (best possible cross-platform behavior)
    return _keepScreenOn;
  }

  bool _keepScreenOn = false;

  @override
  Future<void> SetDisplayKeepOnValue(bool keepOn) async
  {
    SpecificLogMethodStart('SetDisplayKeepOnValue', {'keepOn': keepOn});

    _keepScreenOn = keepOn;

    if (keepOn)
      await WakelockPlus.enable();
    else
      await WakelockPlus.disable();
  }

  // ----------------------------------------------------------
  // Display info
  // ----------------------------------------------------------

  @override
  DisplayInfo GetDisplayInfo()
  {
    SpecificLogMethodStart('GetDisplayInfo');

    final dispatcher = WidgetsBinding.instance.platformDispatcher;
    final views = dispatcher.views;

    if (views.isEmpty)
    {
      return DisplayInfo(
        0,
        0,
        1,
        DisplayOrientation.Unknown,
        DisplayRotation.Unknown,
        0,
      );
    }

    final view = views.first;

    final physicalSize = view.physicalSize;
    final density = view.devicePixelRatio;

    final width = physicalSize.width;
    final height = physicalSize.height;

    final orientation = _CalculateOrientation(width, height);
    final rotation =  DisplayRotation.Unknown; //flutter does not have API to get rotation
    final refreshRate = view.display.refreshRate;

    return DisplayInfo(
      width,
      height,
      density,
      orientation,
      rotation,
      refreshRate,
    );
  }

  // ----------------------------------------------------------
  // Helpers
  // ----------------------------------------------------------

  DisplayOrientation _CalculateOrientation(double width, double height)
  {
    SpecificLogMethodStart('_CalculateOrientation');

    if (width == 0 || height == 0)
      return DisplayOrientation.Unknown;

    return width > height
        ? DisplayOrientation.Landscape
        : DisplayOrientation.Portrait;
  }
}
