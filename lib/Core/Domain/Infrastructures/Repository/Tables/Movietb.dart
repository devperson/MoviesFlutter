import 'package:movies_flutter/Core/Abstractions/Repository/ITable.dart';
import 'package:realm/realm.dart';

part 'Movietb.realm.dart';

//run "dart run realm generate" to regenerate Movietb.realm.dart from this model
@RealmModel()
class _Movietb implements ITable
{
  @PrimaryKey()
  @override
  late int Id;
  late String Name;
  late String Overview;
  String? PostUrl;
}