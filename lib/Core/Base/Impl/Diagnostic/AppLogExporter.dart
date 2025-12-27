import '../../../Abstractions/Diagnostics/IAppLogExporter.dart';
import '../../../Abstractions/Diagnostics/ILoggingService.dart';
import '../../../Abstractions/Essentials/IShare.dart';
import '../../../Abstractions/Essentials/IDirectoryService.dart';
import 'LoggableService.dart';
import 'package:get_it/get_it.dart';
import 'dart:io';

class AppLogExporter extends LoggableService implements IAppLogExporter
{
    IDirectoryService get directoryService => GetIt.I<IDirectoryService>();
    IShare get shareFileService => GetIt.I<IShare>();
    final String KyChat_Logs = "KyChat_Logs";

    @override
    Future<LogSharingResult> ShareLogs() async
    {
        LogMethodStart("ShareLogs");
        try
        {
            this.removeOldFilesFromCache();

            final date = getUtcDateString();
            final fileName = "${KyChat_Logs}_${date}.zip";
            final filePath = "${directoryService.GetCacheDir()}/$fileName";

            // also include censored database into logs folder.
            //this.CopyCensoredDatabaseAsync()

            final compressedLogs = await loggingService.GetCompressedLogFileBytes(false); // Assuming false for GetOnlyLastSession as in Kotlin it was no-arg call which likely defaults or needs check

            if (compressedLogs == null)
            {
                final result = LogSharingResult(false, ExceptionValue: Exception("Error: GetCompressedLogFileStream() method returned null."));
                return result;
            }

            final file = File(filePath);
            await file.writeAsBytes(compressedLogs);

            shareFileService.RequestShareFile("Sharing compressed logs", filePath);

            final result = LogSharingResult(true, ExceptionValue: null);
            return result;
        }
        catch (exception)
        {
            if (exception is Exception) {
                loggingService.TrackError(exception);
                final result = LogSharingResult(false, ExceptionValue: exception);
                return result;
            }
             final result = LogSharingResult(false, ExceptionValue: Exception(exception.toString()));
             return result;
        }
    }

    void removeOldFilesFromCache() {
        LogMethodStart("removeOldFilesFromCache");
        try {
            final cacheDir = Directory(directoryService.GetCacheDir());

            if (cacheDir.existsSync()) {
                final files = cacheDir.listSync()
                    .where((file) => file.path.contains(KyChat_Logs));

                for (final file in files) {
                    file.deleteSync();
                }
            }
        } catch (e) {
            if (e is Exception)
             loggingService.TrackError(e);
        }
    }

    String getUtcDateString() {
        LogMethodStart("getUtcDateString");
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
