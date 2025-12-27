import '../Common/Size.dart';

abstract interface class IResizeImageService
{
  ImageResizeResult ResizeImage(List<int> imageData, String originalContentType, int maxWidth, int maxHeight, { double quality = 97, int rotation = 0, bool shouldSetUniqueName = false });

  ImageResizeResult ResizeNativeImage(Object image, String originalContentType, int maxWidth, int maxHeight, { int rotation = 0, double quality = 97, bool shouldSetUniqueName = false });

  int GetRequiredRotation(Object fileResult);
  int GetRequiredRotationFromPath(String filePath);
}

class ImageResizeResult
{
  bool isResized;
  Object? nativeImage;
  List<int>? image;
  String contentType;
  Size imageSize;
  String? filePath;

  ImageResizeResult({ this.isResized = true, this.nativeImage, this.image, this.contentType = "", Size? imageSize, this.filePath }) : imageSize = imageSize ?? Size.Zero;

  String get FileExtension
  {
    if (contentType.toLowerCase().contains("png"))
      return ".png";

    return ".jpg";
  }

  bool get IsPortrait
  {
    return imageSize == Size.Zero || imageSize.Height > imageSize.Width;
  }
}
