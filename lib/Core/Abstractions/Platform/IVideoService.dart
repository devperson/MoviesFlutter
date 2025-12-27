import '../Common/Size.dart';

abstract interface class IVideoService
{
  Future<ThumbnailInfo> GetThumbnail(String videoFilePath);

  Future<String> CompressVideo(String inputPath);
}

class ThumbnailInfo
{
  Size imageSize;
  String? filePath;

  ThumbnailInfo({ Size? imageSize, this.filePath })
      : imageSize = imageSize ?? Size.Zero;

  bool get Success
  {
    return filePath != null && filePath!.isNotEmpty;
  }

  bool get IsPortrait
  {
    return imageSize.Width > 0 ? imageSize.Height > imageSize.Width : true;
  }
}
