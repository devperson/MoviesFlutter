abstract interface class IMediaPickerService {
    Future<MediaFile?> GetPhotoAsync({MediaOptions? options});
    Future<MediaFile?> TakePhotoAsync({MediaOptions? options});
}

enum MediaSource { CAMERA, GALLERY }

class MediaOptions
{
    //final MediaSource source = MediaSource.GALLERY;
    final bool includeBytes;
    final bool compress;
    final int compressionQuality; // 0..100, used only if compress = true
    final int? maxWidth;
    final int? maxHeight;
    final bool saveToAppDirectory;

    MediaOptions({
        this.includeBytes = false,
        this.compress = false,
        this.compressionQuality = 95,
        this.maxWidth,
        this.maxHeight,
        this.saveToAppDirectory = true
    });
}

class MediaFile
{
    final String FilePath;
    final String? MimeType;
    final List<int>? ByteData;

    MediaFile({required this.FilePath, this.MimeType, this.ByteData});
}
