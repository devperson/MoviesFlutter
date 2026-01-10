import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';
import 'package:movies_flutter/Core/Abstractions/Repository/ILocalDbInitilizer.dart';
import 'package:movies_flutter/Core/Base/Impl/Diagnostic/LoggableService.dart';
import 'package:movies_flutter/Core/Domain/Infrastructures/Repository/Tables/Movietb.dart';
import 'package:realm/realm.dart';

class MockDbInitializer with LoggableService implements ILocalDbInitilizer
{
  bool _isInited = false;
  Realm? _realmConn;

  @override
  final String DbsFolderName = "Databases";

  @override
  final String DbExtenstion = ".realm";

  @override
  final String DbName = "AppDb.realm";

  @override
  Future<void> Init()
  {
    LogMethodStart("Init");

    if (!_isInited)
    {
      _isInited = true;

      final config = Configuration.inMemory
        (
          [Movietb.schema]
      );
      _realmConn = Realm(config);
    }

    return Future.value();
  }

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

  @override
  Future<String> GetDbDir()
  {
    // TODO: implement GetDbDir
    throw UnimplementedError();
  }

  @override
  Future<String> GetDbPath()
  {
    // TODO: implement GetDbPath
    throw UnimplementedError();
  }



  @override
  Future<void> Release({bool closeConnection = false}) async
  {
    LogMethodStart("Release", args: {"closeConnection": closeConnection});

    _isInited = false;

    if (_realmConn == null)
    {
      loggingService.Value.LogWarning("DbInitializer: attempt to close on null realmConn");
      return;
    }

    if (closeConnection)
    {
      _realmConn!.close();
    }

    _realmConn = null;
  }

}