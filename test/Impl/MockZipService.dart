import 'package:movies_flutter/Core/Abstractions/Platform/IZipService.dart';

class MockZipService implements IZipService
{
  @override
  Future<void> CreateFromDirectoryAsync(String fileDir, String zipPath) {
    // TODO: implement CreateFromDirectoryAsync
    throw UnimplementedError();
  }

  @override
  Future<void> CreateFromFileAsync(String filePath, String zipPath) {
    // TODO: implement CreateFromFileAsync
    throw UnimplementedError();
  }

  @override
  Future<void> CreateFromMemoryAsync(String fileName, List<int> bytes, String zipPath) {
    // TODO: implement CreateFromMemoryAsync
    throw UnimplementedError();
  }

  @override
  Future<void> ExtractToDirectoryAsync(String filePath, String dir, bool overwrite) {
    // TODO: implement ExtractToDirectoryAsync
    throw UnimplementedError();
  }
  
}