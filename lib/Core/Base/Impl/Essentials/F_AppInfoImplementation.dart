
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Abstractions/Common/VersionInfo.dart';
import '../../../Abstractions/Diagnostics/ILoggingService.dart';
import '../../../Abstractions/Essentials/IAppInfo.dart';
import '../Diagnostic/LoggableService.dart';


class F_AppInfoImplementation with LoggableService implements IAppInfo
{
  PackageInfo? _packageInfo;

  F_AppInfoImplementation()
  {
    InitSpecificlogger(SpecificLoggingKeys.LogEssentialServices);
  }


  /// Must be called during app startup
  Future<void> InitializeAsync() async
  {
    try
    {
      SpecificLogMethodStart('InitializeAsync');
      _packageInfo ??= await PackageInfo.fromPlatform();
    }
    catch(ex, stackTrace)
    {
      loggingService.Value.TrackError(ex, stackTrace);
    }
  }

  @override
  String get PackageName
  {
    SpecificLogMethodStart('PackageName');
    return _packageInfo?.packageName ?? '';
  }

  @override
  String get Name
  {
    SpecificLogMethodStart('Name');
    return _packageInfo?.appName ?? '';
  }

  @override
  String get VersionString
  {
    SpecificLogMethodStart('VersionString');
    return _packageInfo?.version ?? '';
  }

  @override
  String get BuildString
  {
    SpecificLogMethodStart('BuildString');
    return _packageInfo?.buildNumber ?? '';
  }

  @override
  VersionInfo get Version
  {
    SpecificLogMethodStart('Version');
    return VersionInfo.ParseVersion(VersionString);
  }

  @override
  LayoutDirection get RequestedLayoutDirection
  {
    SpecificLogMethodStart('RequestedLayoutDirection');

    final direction = _GetLayoutDirection();
    return direction;
  }

  @override
  Future<void> ShowSettingsUI() async
  {
    SpecificLogMethodStart('ShowSettingsUI');

    final uri = Uri.parse('app-settings:');

    if (await canLaunchUrl(uri))
    {
      await launchUrl(uri);
    }
  }

  LayoutDirection _GetLayoutDirection()
  {
    SpecificLogMethodStart('_GetLayoutDirection');
    final dispatcher = WidgetsBinding.instance.platformDispatcher;

    final locales = dispatcher.locales;
    if (locales.isEmpty)
      return LayoutDirection.Unknown;

    final locale = locales.first;

    // RTL language codes
    const rtlLanguages = {
      'ar', // Arabic
      'fa', // Persian
      'he', // Hebrew
      'ur', // Urdu
    };

    if (rtlLanguages.contains(locale.languageCode))
      return LayoutDirection.RightToLeft;

    return LayoutDirection.LeftToRight;
  }


}
