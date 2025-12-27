import '../Domain/IEntity.dart';
import 'ITable.dart';

abstract interface class IRepoMapper<TEntity extends IEntity, Tb extends ITable>
{
    Tb ToTb(TEntity entity);
    TEntity ToEntity(Tb tb);
    void MoveData(TEntity from, Tb to);
}
