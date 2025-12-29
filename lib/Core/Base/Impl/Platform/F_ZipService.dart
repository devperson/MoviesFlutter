import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';

import '../../../Abstractions/Platform/IZipService.dart';

class F_ZipService implements IZipService
{
  /// Used only on Web (virtual filesystem)
  final Map<String, List<int>> _memoryZips = {};

  @override
  Future<void> CreateFromFileAsync(String filePath, String zipPath) async
  {
    final file = File(filePath);
    if (!await file.exists())
      throw FileSystemException("File not found", filePath);

    final bytes = await file.readAsBytes();
    final archive = Archive();

    archive.addFile(ArchiveFile(file.uri.pathSegments.last, bytes.length, bytes));

    final zipBytes = ZipEncoder().encode(archive)!;

    await _writeZip(zipPath, zipBytes);
  }

  @override
  Future<void> CreateFromDirectoryAsync(
      String fileDir,
      String zipPath,
      ) async
  {
    final dir = Directory(fileDir);
    if (!await dir.exists())
      throw FileSystemException("Directory not found", fileDir);

    final archive = Archive();

    await for (final entity in dir.list(recursive: true))
    {
      if (entity is File)
      {
        final bytes = await entity.readAsBytes();
        final relativePath = entity.path.substring(fileDir.length + 1);

        archive.addFile(
          ArchiveFile(
            relativePath,
            bytes.length,
            bytes,
          ),
        );
      }
    }

    final zipBytes = ZipEncoder().encode(archive)!;
    await _writeZip(zipPath, zipBytes);
  }

  @override
  Future<void> CreateFromMemoryAsync(
      String fileName,
      List<int> bytes,
      String zipPath,
      ) async
  {
    final archive = Archive();

    archive.addFile(
      ArchiveFile(
        fileName,
        bytes.length,
        Uint8List.fromList(bytes),
      ),
    );

    final zipBytes = ZipEncoder().encode(archive)!;

    _memoryZips[zipPath] = zipBytes;
  }

  @override
  List<int>? ReadZipBytes(String zipPath)
  {
    if (kIsWeb)
    {
      return _memoryZips[zipPath];
    }

    final file = File(zipPath);
    if (!file.existsSync())
      return null;

    return file.readAsBytesSync();
  }

  // ---------------- helpers ----------------

  Future<void> _writeZip(String zipPath, List<int> bytes) async
  {
    if (kIsWeb)
    {
      _memoryZips[zipPath] = bytes;
      return;
    }

    final file = File(zipPath);
    await file.writeAsBytes(bytes, flush: true);
  }

  @override
  Future<void> ExtractToDirectoryAsync(String filePath, String dir, bool overwrite) {
    // TODO: implement ExtractToDirectoryAsync
    throw UnimplementedError();
  }
}
