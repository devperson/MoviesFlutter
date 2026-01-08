import 'package:movies_flutter/Core/Abstractions/Repository/ITable.dart';
import 'package:realm/realm.dart';

import '../../../Abstractions/Domain/IEntity.dart';
import '../../../Abstractions/Repository/ILocalDbInitilizer.dart';
import '../../../Abstractions/Repository/IRepoMapper.dart';
import '../../../Abstractions/Repository/IRepository.dart';
import '../Diagnostic/LoggableService.dart';
import '../Utils/LazyInjected.dart';
import '../../../Abstractions/Common/AppException.dart' as app;

/// NOTE:
/// Dart does not support multiple generic bounds (e.g. `Tb extends RealmObject & ITable`),
/// which is possible in C# / Kotlin.
///
/// To preserve strong typing without runtime casts, we split the table constraints:
/// - [Tb]  represents the Realm-generated object type (required by Realm APIs)
/// - [Tb2] represents the logical table contract (e.g. provides `Id` via ITable)
///
/// Both types refer to the same underlying table model, but are expressed separately
/// due to Dart language limitations.
abstract class BaseRepository<TEntity extends IEntity, Tb extends RealmObject, Tb2 extends ITable> with LoggableService implements IRepository<TEntity>
{
  BaseRepository(this.tbType);

  final Type tbType;
  Realm? _realm;
  final _mapper = LazyInjected<IRepoMapper<TEntity, Tb2>>();
  final _dbConnectionInitializer = LazyInjected<ILocalDbInitilizer>();

// ------------------------------------------------------------
// IRepository
// ------------------------------------------------------------

  @override
  Future<List<TEntity>> GetListAsync({int count = -1, int skip = 0}) async
  {
    LogMethodStart('GetListAsync', {'count': count, 'skip': skip,});
    _ensureInitialized();

    late Iterable<Tb> results;

    if (count > 0)
    {
       results = _realm!.all<Tb>().skip(skip).take(count);
    }
    else
    {
       results = _realm!.all<Tb>();
    }

    return results.cast<Tb2>().map(_mapper.Value.ToEntity).toList();
  }

  @override
  Future<int> AddAllAsync(List<TEntity> entities) async
  {
    LogMethodStart('AddAllAsync', {'entities': entities});
    _ensureInitialized();

    var lastId = -1;

    _realm!.write(()
    {
      for (final entity in entities)
      {
        if (lastId != -1)
        {
          lastId++;
        }
        else
        {
          lastId = _getNextId();
        }

        entity.Id = lastId;

        final tb = _mapper.Value.ToTb(entity) as Tb;
        _realm!.add(tb);
      }
    });

    return entities.length;
  }

  @override
  Future<TEntity?> FindById(int id) async
  {
    LogMethodStart('FindById', {'id': id});
    _ensureInitialized();

    final tb = _realm!.query<Tb>('Id == \$0', [id]).firstOrNull;

    return tb != null ? _mapper.Value.ToEntity(tb as Tb2) : null;
  }

  @override
  Future<int> AddAsync(TEntity entity) async
  {
    LogMethodStart('AddAsync', {'entity': entity});
    _ensureInitialized();

    entity.Id = _getNextId();
    final tb = _mapper.Value.ToTb(entity) as Tb;

    _realm!.write(()
    {
      _realm!.add(tb);
    });

    return 1;
  }

  @override
  Future<int> UpdateAsync(TEntity entity) async
  {
    LogMethodStart('UpdateAsync', {'entity': entity});
    _ensureInitialized();

    var hasValue = false;

    _realm!.write(()
    {
      final tb = _realm!
          .query<Tb>('Id == \$0', [entity.Id])
          .firstOrNull;

      if (tb != null)
      {
        hasValue = true;
        _mapper.Value.MoveData(entity, tb as Tb2);
      }
    });

    return hasValue ? 1 : 0;
  }

  @override
  Future<int> RemoveAsync(TEntity entity) async
  {
    LogMethodStart('RemoveAsync', {'entity': entity});
    _ensureInitialized();

    var hasValue = false;

    _realm!.write(()
    {
      final tb = _realm!
          .query<Tb>('Id == \$0', [entity.Id])
          .firstOrNull;

      if (tb != null)
      {
        hasValue = true;
        _realm!.delete(tb);
      }
    });

    return hasValue ? 1 : 0;
  }

  @override
  Future<int> ClearAsync(String reason) async
  {
    LogMethodStart('ClearAsync', {'reason': reason});
    _ensureInitialized();

    var deletedCount = 0;

    _realm!.write(()
    {
      final items = _realm!.all<Tb>();
      deletedCount = items.length;
      _realm!.deleteMany(items);
    });

    loggingService.Value.LogWarning('${runtimeType}: Cleared $deletedCount records from $tbType: $reason');

    return deletedCount;
  }

// ------------------------------------------------------------
// Internals
// ------------------------------------------------------------

  void _ensureInitialized()
  {
    if (_realm == null || _isDbClosed())
    {
      _realm = _dbConnectionInitializer.Value.GetDbConnection() as Realm?;
      if (_realm == null)
      {
        throw app.AppException.Throw('Realm is null. It seems ILocalDbInitilizer.Init() was not called.');
      }
    }
  }

  bool _isDbClosed()
  {
    try
    {
      return _realm?.isClosed ?? true;
    }
    catch (_)
    {
      return true;
    }
  }

  int _getNextId()
  {
    final last = _realm!
        .query<Tb>('TRUEPREDICATE SORT(Id DESC) LIMIT(1)')
        .firstOrNull;

    return last == null ? 1 : (last as Tb2).Id + 1;
  }
}
