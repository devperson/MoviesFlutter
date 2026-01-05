import 'dart:io';
import 'package:movies_flutter/Core/Abstractions/Platform/IDirectoryService.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class MockDirectoryDir implements IDirectoryService
{
  final Directory _root;

  MockDirectoryDir()
      : _root = Directory.systemTemp.createTempSync('unit_test_dir');



  @override
  Future<String> GetCacheDir() async
  {
    final dir = Directory(p.join(_root.path, 'cache'));
    if (!dir.existsSync()) dir.createSync();
    return dir.path;
  }

  @override
  Future<String> GetAppDataDir() async
  {
    final dir = Directory(p.join(_root.path, 'data'));
    if (!dir.existsSync()) dir.createSync();
    return dir.path;
  }

  @override
  Future<void> CreateDir(String path) {
    // TODO: implement CreateDir
    throw UnimplementedError();
  }

  @override
  Future<bool> IsExistDir(String path) {
    // TODO: implement IsExistDir
    throw UnimplementedError();
  }
}