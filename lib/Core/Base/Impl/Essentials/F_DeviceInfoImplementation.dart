import 'dart:io' as io;
import 'dart:math';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';

import '../../../Abstractions/Common/VersionInfo.dart';
import '../../../Abstractions/Diagnostics/ILoggingService.dart';
import '../../../Abstractions/Essentials/Device/DeviceIdiom.dart';
import '../../../Abstractions/Essentials/Device/DevicePlatform.dart';
import '../../../Abstractions/Essentials/Device/DeviceTypeEnum.dart';
import '../../../Abstractions/Essentials/Device/IDeviceInfo.dart';
import '../Diagnostic/LoggableService.dart';


class F_DeviceInfoImplementation with LoggableService implements IDeviceInfo
{
  static const int tabletCrossover = 600;

  final DeviceInfoPlugin _plugin = DeviceInfoPlugin();

  BaseDeviceInfo? _deviceInfo;

  F_DeviceInfoImplementation()
  {
    InitSpecificlogger(SpecificLoggingKeys.LogEssentialServices);
    InitializeAsync();
  }

  // ----------------------------------------------------------
  // Initialization (lazy + async)
  // ----------------------------------------------------------

  Future<void> InitializeAsync() async
  {
    SpecificLogMethodStart('InitializeAsync');

    if (io.Platform.isAndroid)
      _deviceInfo = await _plugin.androidInfo;
    else if (io.Platform.isIOS)
      _deviceInfo = await _plugin.iosInfo;
    else if (io.Platform.isWindows)
      _deviceInfo = await _plugin.windowsInfo;
    else if (io.Platform.isMacOS)
      _deviceInfo = await _plugin.macOsInfo;
    else if (io.Platform.isLinux)
      _deviceInfo = await _plugin.linuxInfo;
    else
      _deviceInfo = await _plugin.webBrowserInfo;
  }

  // ----------------------------------------------------------
  // Platform
  // ----------------------------------------------------------

  @override
  DevicePlatform get Platform
  {
    if (io.Platform.isAndroid) return DevicePlatform.Android;
    if (io.Platform.isIOS) return DevicePlatform.iOS;
    if (io.Platform.isWindows) return DevicePlatform.Windows;
    if (io.Platform.isMacOS) return DevicePlatform.macOS;
    if (io.Platform.isLinux) return DevicePlatform.Linux;
    return DevicePlatform.Web;
  }

  // ----------------------------------------------------------
  // Model / Manufacturer / Name
  // ----------------------------------------------------------

  @override
  String get Model
  {
    SpecificLogMethodStart('Model');

    final info = _deviceInfo;

    if (info is AndroidDeviceInfo) return info.model;
    if (info is IosDeviceInfo) return info.utsname.machine;
    if (info is WindowsDeviceInfo) return info.computerName;
    if (info is MacOsDeviceInfo) return info.model;
    if (info is LinuxDeviceInfo) return info.prettyName;
    if (info is WebBrowserInfo) return info.userAgent ?? '';

    return '';
  }

  @override
  String get Manufacturer
  {
    SpecificLogMethodStart('Manufacturer');

    final info = _deviceInfo;

    if (info is AndroidDeviceInfo) return info.manufacturer;
    if (info is IosDeviceInfo) return 'Apple';
    if (info is MacOsDeviceInfo) return 'Apple';
    if (info is WindowsDeviceInfo) return 'Microsoft';
    if (info is LinuxDeviceInfo) return info.name;
    if (info is WebBrowserInfo) return info.vendor ?? '';

    return '';
  }

  @override
  String get Name
  {
    SpecificLogMethodStart('Name');

    final info = _deviceInfo;

    if (info is AndroidDeviceInfo) return info.model;
    if (info is IosDeviceInfo) return info.name;
    if (info is WindowsDeviceInfo) return info.computerName;
    if (info is MacOsDeviceInfo) return info.computerName;
    if (info is LinuxDeviceInfo) return info.prettyName;
    if (info is WebBrowserInfo) return info.userAgent ?? '';

    return '';
  }

  // ----------------------------------------------------------
  // OS version
  // ----------------------------------------------------------

  @override
  String get VersionString
  {
    SpecificLogMethodStart('VersionString');

    final info = _deviceInfo;

    if (info is AndroidDeviceInfo) return info.version.release ?? '';
    if (info is IosDeviceInfo) return info.systemVersion;
    if (info is WindowsDeviceInfo) return info.displayVersion;
    if (info is MacOsDeviceInfo) return info.osRelease;
    if (info is LinuxDeviceInfo) return info.version ?? '';
    if (info is WebBrowserInfo) return info.appVersion ?? '';

    return '';
  }

  @override
  VersionInfo get Version
  {
    SpecificLogMethodStart('Version');
    return VersionInfo.ParseVersion(VersionString);
  }

  // ----------------------------------------------------------
  // Idiom (Phone / Tablet / Desktop)
  // ----------------------------------------------------------

  @override
  DeviceIdiom get Idiom
  {
    SpecificLogMethodStart('Idiom');

    // Desktop platforms
    if (io.Platform.isWindows || io.Platform.isMacOS || io.Platform.isLinux)
      return DeviceIdiom.Desktop;

    // Mobile platforms → screen-based detection
    final dispatcher = WidgetsBinding.instance.platformDispatcher;
    final views = dispatcher.views;

    if (views.isEmpty)
      return DeviceIdiom.Unknown;

    final view = views.first;
    final logicalSize = view.physicalSize / view.devicePixelRatio;
    final minSide = min(logicalSize.width, logicalSize.height);

    return minSide >= tabletCrossover
        ? DeviceIdiom.Tablet
        : DeviceIdiom.Phone;
  }

  // ----------------------------------------------------------
  // Physical vs Virtual
  // ----------------------------------------------------------

  @override
  DeviceTypeEnum get DeviceType
  {
    SpecificLogMethodStart('DeviceType');

    final info = _deviceInfo;

    if (info is AndroidDeviceInfo)
      return info.isPhysicalDevice == true
          ? DeviceTypeEnum.Physical
          : DeviceTypeEnum.Virtual;

    if (info is IosDeviceInfo)
      return info.isPhysicalDevice == true
          ? DeviceTypeEnum.Physical
          : DeviceTypeEnum.Virtual;

    // Desktop & web → assume physical
    return DeviceTypeEnum.Physical;
  }
}
