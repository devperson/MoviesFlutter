import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Log output that writes messages to a session file.
/// On Web, logs are kept fully in memory.
class FileLogOutput extends LogOutput
{
  final String filePath;

  IOSink? _sink;

  /// Used only on Web (or as a fallback)
  final List<String> _memoryLines = [];

  FileLogOutput(this.filePath)
  {
    if (!kIsWeb)
    {
      final file = File(filePath);
      file.createSync(recursive: true);
      _sink = file.openWrite(mode: FileMode.append);
    }
  }

  /// Receives log lines from the `logger` package.
  /// Each line corresponds to a single formatted log entry.
  @override
  void output(OutputEvent event)
  {
    for (final line in event.lines)
    {
      if (kIsWeb)
      {
        _memoryLines.add(line);
      }
      else
      {
        _sink?.writeln(line);
      }
    }
  }

  /// Returns the last [maxLines] log lines.
  /// Used by `GetLogListAsync`.
  Future<List<String>> ReadLastLines([ int maxLines = 100 ]) async
  {
    if (_memoryLines.length <= maxLines)
      return List.unmodifiable(_memoryLines);

    return List.unmodifiable(
      _memoryLines.sublist(_memoryLines.length - maxLines),
    );
  }

  /// Returns all collected log content as raw UTF-8 bytes.
  /// Used by `IZipService.CreateFromMemoryAsync` (Web fallback).
  List<int> GetInMemoryBytes()
  {
    final content = _memoryLines.join("\n");
    return Uint8List.fromList(content.codeUnits);
  }

  /// Flushes and closes file resources.
  /// Should be called on app shutdown if possible.
  void Dispose() async
  {
    try
    {
      await _sink?.flush();
      await _sink?.close();
    }
    catch (_)
    {
      // ignore
    }
  }
}
