import 'dart:io';
import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';
import 'package:realm/realm.dart';

import '../../../Abstractions/Platform/IDirectoryService.dart';
import '../../../Abstractions/Repository/ILocalDbInitilizer.dart';
import '../../../Base/Impl/Diagnostic/LoggableService.dart';
import '../../../Base/Impl/Utils/LazyInjected.dart';
import 'Tables/Movietb.dart';


class F_DbInitilizer
    with LoggableService
    implements ILocalDbInitilizer
{
  bool _isInited = false;
  Realm? _realmConn;


  final _directoryService = LazyInjected<IDirectoryService>();

  @override
  final String DbsFolderName = "Databases";

  @override
  final String DbExtenstion = ".realm";

  @override
  final String DbName = "AppDb.realm";

  // ------------------------------------------------------------
  // Paths
  // ------------------------------------------------------------

  @override
  Future<String> GetDbDir() async
  {
    final String baseDir = await _directoryService.Value.GetAppDataDir();
    final String dbFolder = "$baseDir${Platform.pathSeparator}$DbsFolderName";

    if (! await _directoryService.Value.IsExistDir(dbFolder))
    {
      _directoryService.Value.CreateDir(dbFolder);
    }

    return dbFolder;
  }

  @override
  Future<String> GetDbPath() async
  {
    final dbDir = await GetDbDir();
    return "${dbDir}${Platform.pathSeparator}$DbName";
  }

  // ------------------------------------------------------------
  // Realm access
  // ------------------------------------------------------------

  @override
  Realm GetDbConnection()
  {
    LogMethodStart("GetDbConnection");

    if (_realmConn == null)
    {
      throw AppException.Throw("Please call Init() before calling GetDbConnection()");
    }

    return _realmConn!;
  }

  // ------------------------------------------------------------
  // Lifecycle
  // ------------------------------------------------------------

  @override
  Future<void> Init() async
  {
    LogMethodStart("Init");

    if (!_isInited)
    {
      _isInited = true;

      final dbPath = await GetDbPath();
      final Configuration config = Configuration.local(
        [
          Movietb.schema, // RealmObject schemas
        ],
        //path: dbPath,

      );

      _realmConn = Realm(config);
    }
    else
    {
      loggingService.Value.LogWarning("DbInitializer skip Init() because isInited:true");
    }
  }



  @override
  Future<void> Release({bool closeConnection = false}) async
  {
    LogMethodStart("Release", [closeConnection]);

    _isInited = false;

    if (_realmConn == null)
    {
      loggingService.Value.LogWarning(
        "DbInitializer: attempt to close on null realmConn",
      );
      return;
    }

    if (closeConnection)
    {
      _realmConn!.close();
    }

    _realmConn = null;
  }


}