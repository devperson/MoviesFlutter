import 'IJsonModel.dart';

abstract interface class IJsonMapper
{
  void Register<T extends IDeserializable<T>>(T prototype);
  String Serialize(ISerializable model);
  T Deserialize<T extends IDeserializable<T>>(String json);
}