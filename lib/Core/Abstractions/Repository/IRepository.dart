import '../Domain/IEntity.dart';

abstract interface class IRepository<TEntity extends IEntity>
{
    Future<TEntity?> FindById(int id);
    Future<List<TEntity>> GetListAsync({int count = -1, int skip = 0});
    Future<int> AddAsync(TEntity entity);
    Future<int> UpdateAsync(TEntity entity);
    Future<int> AddAllAsync(List<TEntity> entities);
    Future<int> RemoveAsync(int entityId);
    Future<int> ClearAsync(String reason);
}
