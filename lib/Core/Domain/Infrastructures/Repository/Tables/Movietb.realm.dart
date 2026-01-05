// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Movietb.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class Movietb extends _Movietb with RealmEntity, RealmObjectBase, RealmObject {
  Movietb(int Id, String Name, String Overview, {String? PostUrl}) {
    RealmObjectBase.set(this, 'Id', Id);
    RealmObjectBase.set(this, 'Name', Name);
    RealmObjectBase.set(this, 'Overview', Overview);
    RealmObjectBase.set(this, 'PostUrl', PostUrl);
  }

  Movietb._();

  @override
  int get Id => RealmObjectBase.get<int>(this, 'Id') as int;
  @override
  set Id(int value) => RealmObjectBase.set(this, 'Id', value);

  @override
  String get Name => RealmObjectBase.get<String>(this, 'Name') as String;
  @override
  set Name(String value) => RealmObjectBase.set(this, 'Name', value);

  @override
  String get Overview =>
      RealmObjectBase.get<String>(this, 'Overview') as String;
  @override
  set Overview(String value) => RealmObjectBase.set(this, 'Overview', value);

  @override
  String? get PostUrl =>
      RealmObjectBase.get<String>(this, 'PostUrl') as String?;
  @override
  set PostUrl(String? value) => RealmObjectBase.set(this, 'PostUrl', value);

  @override
  Stream<RealmObjectChanges<Movietb>> get changes =>
      RealmObjectBase.getChanges<Movietb>(this);

  @override
  Stream<RealmObjectChanges<Movietb>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Movietb>(this, keyPaths);

  @override
  Movietb freeze() => RealmObjectBase.freezeObject<Movietb>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'Id': Id.toEJson(),
      'Name': Name.toEJson(),
      'Overview': Overview.toEJson(),
      'PostUrl': PostUrl.toEJson(),
    };
  }

  static EJsonValue _toEJson(Movietb value) => value.toEJson();
  static Movietb _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'Id': EJsonValue Id,
        'Name': EJsonValue Name,
        'Overview': EJsonValue Overview,
      } =>
        Movietb(
          fromEJson(Id),
          fromEJson(Name),
          fromEJson(Overview),
          PostUrl: fromEJson(ejson['PostUrl']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Movietb._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Movietb, 'Movietb', [
      SchemaProperty('Id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('Name', RealmPropertyType.string),
      SchemaProperty('Overview', RealmPropertyType.string),
      SchemaProperty('PostUrl', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
