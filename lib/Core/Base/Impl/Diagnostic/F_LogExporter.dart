import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';

import '../../../Abstractions/Diagnostics/IAppLogExporter.dart';
import '../../../Abstractions/Essentials/IShare.dart';
import '../../../Abstractions/Platform/IDirectoryService.dart';
import '../Utils/LazyInjected.dart';
import 'LoggableService.dart';
import 'dart:io';

class F_LogExporter with LoggableService implements IAppLogExporter
{
    final directoryService = LazyInjected<IDirectoryService>();
    final shareFileService = LazyInjected<IShare>();
    final String KyChat_Logs = "MoviesApp_Logs";

    @override
    Future<LogSharingResult> ShareLogs() async
    {
        LogMethodStart("ShareLogs");
        try
        {
            this.removeOldFilesFromCache();

            final date = getUtcDateString();
            final fileName = "${KyChat_Logs}_${date}.zip";
            final cacheDir = await directoryService.Value.GetCacheDir();
            final filePath = "${cacheDir}/$fileName";

            // also include censored database into logs folder.
            //this.CopyCensoredDatabaseAsync()

            final compressedLogs = await loggingService.Value.GetCompressedLogFileBytes(false); // Assuming false for GetOnlyLastSession as in Kotlin it was no-arg call which likely defaults or needs check

            if (compressedLogs == null)
            {
                final result = LogSharingResult(false, ExceptionValue: Exception("Error: GetCompressedLogFileStream() method returned null."));
                return result;
            }

            final file = File(filePath);
            await file.writeAsBytes(compressedLogs);

            shareFileService.Value.RequestShareFile("Sharing compressed logs", filePath);

            final result = LogSharingResult(true, ExceptionValue: null);
            return result;
        }
        catch (exception, stackTrace)
        {
          loggingService.Value.TrackError(exception, stackTrace);
          final appException = exception.ToAppException(stackTrace);
          final result = LogSharingResult(false, ExceptionValue: appException);
          return result;
        }
    }

    void removeOldFilesFromCache() async
    {
      LogMethodStart("removeOldFilesFromCache");
      try
      {
        final cacheFilePath = await directoryService.Value.GetCacheDir();
        final cacheDir = Directory(cacheFilePath);

        if (cacheDir.existsSync())
        {
          final files = cacheDir.listSync().where((file) => file.path.contains(KyChat_Logs));

          for (final file in files)
          {
            file.deleteSync();
          }
        }
      }
      catch (e, stackTrace)
      {
        loggingService.Value.TrackError(e, stackTrace);
      }
    }

    String getUtcDateString()
    {
        final now = DateTime.now().toUtc();
        final buffer = StringBuffer();
        buffer.write(now.year.toString().padLeft(4, '0'));
        buffer.write(now.month.toString().padLeft(2, '0'));
        buffer.write(now.day.toString().padLeft(2, '0'));
        buffer.write(now.hour.toString().padLeft(2, '0'));
        buffer.write(now.minute.toString().padLeft(2, '0'));
        buffer.write(now.second.toString().padLeft(2, '0'));
        return buffer.toString();
    }
}
