import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';
import 'package:movies_flutter/Core/Abstractions/Diagnostics/CommonTAG.dart';
import 'package:movies_flutter/Core/Base/Impl/Diagnostic/ConsoleService.dart';
import 'package:movies_flutter/Core/Base/Impl/Diagnostic/LoggableService.dart';
import 'package:path/path.dart' as p;

import '../../../Abstractions/Diagnostics/IFileLogger.dart';
import '../../../Abstractions/Platform/IDirectoryService.dart';
import '../../../Abstractions/Platform/IZipService.dart';
import '../Utils/LazyInjected.dart';
import 'FileLogOutput.dart';



class F_FileLogger with ConsoleService implements IFileLogger
{
  final LazyInjected<IDirectoryService> _directoryService = LazyInjected<IDirectoryService>();
  final LazyInjected<IZipService> _zipService = LazyInjected<IZipService>();

  late final Logger _logger;
  late final FileLogOutput _output;

  late String _currentLogPath;
  late String _logRoot;
  late String _sessionDir;

  bool _isInited = false;
  static const String _tag = "F_FileLogger:";

  @override
  Future<void> InitAsync() async
  {
    try
    {
      if(_isInited)
        {
          PrintOrange("$_tag.InitAsync(): Ignoring this method because it is already initilized");
          return;
        }

      _isInited = true;
      final logFolder = await GetLogsFolder();
      if (logFolder.isEmpty)
      {
        PrintRed("$_tag.InitAsync(): Failed to get GetLogsFolder()");
        return;
      }

      _logRoot = logFolder;

      // 🗓 FOLDER PER DAY
      final dayStamp = DateFormat("yyyy-MM-dd").format(DateTime.now());
      _sessionDir = p.join(_logRoot, dayStamp);
      await Directory(_sessionDir).create(recursive: true);

      // 🕒 FILE PER SESSION
      final timestamp = DateFormat("yyyy-MM-dd_HH-mm-ss").format(DateTime.now());
      _currentLogPath = p.join(_sessionDir,"session_$timestamp.log");

      _output = FileLogOutput(_currentLogPath);

      // 💬 Exact "%msg%n" equivalent
      _logger = Logger(
        level: Level.debug,
        printer: SimplePrinter(printTime: false, colors: false),
        output: _output,
      );

      await _cleanupOldLogs();
    }
    catch (ex, stackTrace)
    {
      PrintException(ex,stackTrace);
    }
  }

  @override
  void Info(String message) async
  {
    try
    {
      _logger.i(message);
    }
    catch(ex, stackTrace)
    {
      PrintException(ex,stackTrace);
    }
  }

  @override
  void Warn(String message) async
  {
    try
    {
      _logger.w(message);
    }
    catch(ex, stackTrace)
    {
      PrintException(ex,stackTrace);
    }
  }

  @override
  void Error(String message) async
  {
    try
    {
      _logger.e(message);
    }
    catch(ex, stackTrace)
    {
      PrintException(ex, stackTrace);
    }
  }



  Future<List<int>?> GetCompressedLogsSync(bool getOnlyLastSession) async
  {
    final tempZipPath = kIsWeb
        ? "memory://logs.zip"
        : "${Directory.systemTemp.path}/logs.zip";

    // Remove old zip if exists (file platforms)
    if (!kIsWeb)
    {
      final zipFile = File(tempZipPath);
      if (await zipFile.exists())
        await zipFile.delete();
    }

    if (kIsWeb)
    {
      // Create zip in memory via service
      await _zipService.Value.CreateFromMemoryAsync("session.log", _output.GetInMemoryBytes(), tempZipPath);
      return await _readBytes(tempZipPath);
    }

    if (getOnlyLastSession)
    {
      await _zipService.Value.CreateFromFileAsync(_currentLogPath, tempZipPath);
    }
    else
    {
      await _zipService.Value.CreateFromDirectoryAsync(_logRoot, tempZipPath);
    }

    // Read zip bytes AFTER creation
    return await _readBytes(tempZipPath);
  }


  @override
  Future<List<String>> GetLogListAsync() async
  {
    try
    {
      if (kIsWeb)
        return _output.ReadLastLines();

      final file = File(_currentLogPath);
      if (!await file.exists())
        return [];

      final lines = await file.readAsLines();
      return lines.length <= 100
          ? lines
          : lines.sublist(lines.length - 100);
    }
    catch (ex, stackTrace)
    {
      PrintException(ex, stackTrace);
      return [];
    }
  }

  @override
  Future<String> GetLogsFolder() async
  {
    try
    {
      final root = await _directoryService.Value.GetAppDataDir();
      final path = p.join(root, 'FlutterLogs');
      final folder = Directory(path);

      if (!await folder.exists())
        await folder.create(recursive: true);

      return folder.path;
    }
    catch (ex, stackTrace)
    {
      PrintException(ex, stackTrace);
      return "";
    }
  }

  @override
  String GetCurrentLogFileName()
  {
    return _currentLogPath;
  }

  Future<Uint8List?> _readBytes(String tempZipPath) async
  {
    final zipFile = File(tempZipPath);
    if (!await zipFile.exists())
    {
      return null;
    }

    return await zipFile.readAsBytes();
  }
  // ---------------- cleanup ----------------

  Future<void> _cleanupOldLogs() async
  {
    try
    {
      final rootDir = Directory(_logRoot);
      if (!await rootDir.exists())
        return;

      final folders = rootDir
          .listSync()
          .whereType<Directory>()
          .where((d) => RegExp(r"\d{4}-\d{2}-\d{2}")
          .hasMatch(d.path.split(Platform.pathSeparator).last))
          .toList()
        ..sort((a, b) => b.path.compareTo(a.path));

      if (folders.length <= 7)
        return;

      for (final dir in folders.skip(7))
      {
        try { await dir.delete(recursive: true); }
        catch (ex, stackTrace)
        {
          PrintException(ex, stackTrace);
        }
      }
    }
    catch (ex, stackTrace)
    {
      PrintException(ex, stackTrace);
    }
  }
}
