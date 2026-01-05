abstract interface class ILocalDbInitilizer
{
    String get DbsFolderName;
    String get DbExtenstion;
    String get DbName;
    Future<String> GetDbPath();
    Future<String> GetDbDir();
    Object GetDbConnection();
    Future<void> Init();
    Future<void> Release({bool closeConnection = false});
}
