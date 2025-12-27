abstract interface class IDirectoryService
{
    String GetCacheDir();
    String GetAppDataDir();
    bool IsExistDir(String path);
    void CreateDir(String path);
}
