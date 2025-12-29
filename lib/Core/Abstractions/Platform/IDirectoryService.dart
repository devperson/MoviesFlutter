abstract interface class IDirectoryService
{
    Future<String> GetAppDataDir();
    Future<String> GetCacheDir();
    Future<bool> IsExistDir(String path);
    Future<void> CreateDir(String path);
}
