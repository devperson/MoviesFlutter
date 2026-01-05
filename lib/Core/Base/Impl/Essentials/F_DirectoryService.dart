import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../../Abstractions/Diagnostics/ILoggingService.dart';
import '../../../Abstractions/Platform/IDirectoryService.dart';
import '../Diagnostic/LoggableService.dart';


class F_DirectoryService with LoggableService implements IDirectoryService
{

  F_DirectoryService()
  {
    InitSpecificlogger(SpecificLoggingKeys.LogEssentialServices);
  }

  // ----------------------------------------------------------
  // Cache directory
  // ----------------------------------------------------------

  @override
  Future<String> GetCacheDir() async
  {
    SpecificLogMethodStart('GetCacheDir');

    final dir = await getTemporaryDirectory();
    return dir.path;
  }

  // ----------------------------------------------------------
  // App data directory
  // ----------------------------------------------------------

  @override
  Future<String> GetAppDataDir() async
  {
    SpecificLogMethodStart('GetAppDataDir');

    if (kIsWeb)
    {
      // Virtual root for Web (in-memory usage)
      return "memory://appdata";
    }

    final dir = await getApplicationSupportDirectory();

    if (!await dir.exists())
    {
      await dir.create(recursive: true);
    }

    return dir.path;
  }

  // ----------------------------------------------------------
  // Directory existence
  // ----------------------------------------------------------

  @override
  Future<bool> IsExistDir(String path) async
  {
    SpecificLogMethodStart('IsExistDir', [path]);

    final dir = Directory(path);
    return await dir.exists();
  }

  // ----------------------------------------------------------
  // Create directory (recursive)
  // ----------------------------------------------------------

  @override
  Future<void> CreateDir(String path) async
  {
    SpecificLogMethodStart('CreateDir', [path]);

    final dir = Directory(path);
    final res = await dir.exists();
    if (res == false)
    {
      await dir.create(recursive: true);
    }
  }
}
