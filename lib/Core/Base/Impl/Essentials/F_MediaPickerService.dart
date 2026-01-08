import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:movies_flutter/Core/Abstractions/Platform/IDirectoryService.dart';
import 'package:path/path.dart' as p;

import '../../../Abstractions/Diagnostics/ILoggingService.dart';
import '../../../Abstractions/Essentials/IMediaPickerService.dart';
import '../Diagnostic/LoggableService.dart';
import '../Utils/LazyInjected.dart';

class F_MediaPickerService with LoggableService implements IMediaPickerService
{
  final directoryService = LazyInjected<IDirectoryService>();
  final ImagePicker _picker = ImagePicker();

  F_MediaPickerService()
  {
    InitSpecificlogger(SpecificLoggingKeys.LogEssentialServices);
  }

  @override
  Future<MediaFile?> GetPhotoAsync({MediaOptions? options}) async
  {
    SpecificLogMethodStart('GetPhotoAsync');
    return _pickAndProcess(MediaSource.GALLERY, options);
  }

  @override
  Future<MediaFile?> TakePhotoAsync({MediaOptions? options}) async
  {
    SpecificLogMethodStart('TakePhotoAsync');
    return _pickAndProcess(MediaSource.CAMERA, options);
  }

  Future<MediaFile?> _pickAndProcess(MediaSource source, MediaOptions? options) async
  {
    SpecificLogMethodStart('_pickAndProcess');

    final opts = options ?? MediaOptions();

    // Pick the image using image_picker's built-in scaling/quality options
    final XFile? pickedFile = await _picker.pickImage(
      source: source == MediaSource.CAMERA ? ImageSource.camera : ImageSource.gallery,
      maxWidth: opts.maxWidth?.toDouble(),
      maxHeight: opts.maxHeight?.toDouble(),
      imageQuality: opts.compress ? opts.compressionQuality : 100,
    );

    if (pickedFile == null)
    {
      loggingService.Value.LogWarning("Picking media canceled as pickedFile is null");
      return null;
    }

    String finalPath = pickedFile.path;

    // Handle "Save to App Directory" requirement
    if (opts.saveToAppDirectory)
    {
      final appDir = await directoryService.Value.GetAppDataDir();
      final fileName = p.basename(pickedFile.path);
      final targetPath = p.join(appDir, fileName);

      final savedFile = await File(pickedFile.path).copy(targetPath);
      finalPath = savedFile.path;
    }

    // Requires 'mime' package
    final mimType = lookupMimeType(finalPath);

    SpecificLogMessage("_pickAndProcess() finalPath=$finalPath; mimType=$mimType");

    return MediaFile(
      FilePath: finalPath,
      MimeType: mimType,
      ByteData: opts.includeBytes ? await File(finalPath).readAsBytes() : null,
    );
  }
}
