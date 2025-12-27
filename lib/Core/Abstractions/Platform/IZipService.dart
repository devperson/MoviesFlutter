abstract interface class IZipService
{
    Future<void> CreateFromDirectoryAsync(String fileDir, String zipPath);
    Future<void> ExtractToDirectoryAsync(String filePath, String dir, bool overwrite);
    Future<void> CreateFromFileAsync(String filePath, String zipPath);
}
