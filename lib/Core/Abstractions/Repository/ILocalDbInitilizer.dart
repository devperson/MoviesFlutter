abstract interface class ILocalDbInitilizer
{
    String get DbsFolderName;
    String get DbExtenstion;
    String get DbName;
    String GetDbPath();
    String GetDbDir();
    Object GetDbConnection();
    Future<void> Init();
    Future<void> Release({bool closeConnection = false});
}
