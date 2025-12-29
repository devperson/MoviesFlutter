import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../../Abstractions/Platform/IDirectoryService.dart';

class F_DirectoryService implements IDirectoryService
{
  @override
  Future<String> GetAppDataDir() async
  {
    if (kIsWeb)
    {
      // Virtual root for Web (in-memory usage)
      return "memory://appdata";
    }

    Directory dir;

    if (Platform.isAndroid || Platform.isIOS)
    {
      dir = await getApplicationSupportDirectory();
    }
    else
    {
      // Windows / macOS / Linux
      dir = await getApplicationSupportDirectory();
    }

    if (!await dir.exists())
      await dir.create(recursive: true);

    return dir.path;
  }

  @override
  Future<void> CreateDir(String path) {
    // TODO: implement CreateDir
    throw UnimplementedError();
  }

  @override
  Future<String> GetCacheDir() {
    // TODO: implement GetCacheDir
    throw UnimplementedError();
  }

  @override
  Future<bool> IsExistDir(String path) {
    // TODO: implement IsExistDir
    throw UnimplementedError();
  }
}
