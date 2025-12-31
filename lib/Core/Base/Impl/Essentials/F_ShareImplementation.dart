import 'dart:io';
import 'package:share_plus/share_plus.dart';

import '../../../Abstractions/Diagnostics/ILoggingService.dart';
import '../../../Abstractions/Essentials/IShare.dart';
import '../Diagnostic/LoggableService.dart';

class F_ShareImplementation with LoggableService implements IShare
{
  F_ShareImplementation()
  {
    InitSpecificlogger(SpecificLoggingKeys.LogEssentialServices);
  }

  @override
  Future<void> RequestShareFile(String title, String fullPath) async
  {
    SpecificLogMethodStart('RequestShareFile', [title, fullPath]);

    final file = File(fullPath);

    if (!await file.exists())
      throw FileSystemException('File not found', fullPath);

    final xFile = XFile(fullPath);

    await Share.shareXFiles([xFile], subject: title.isNotEmpty ? title : null);
  }
}
