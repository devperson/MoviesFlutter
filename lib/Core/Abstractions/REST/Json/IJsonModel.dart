abstract interface class ISerializable
{
  String Serialize();
}

abstract class IDeserializable<TSelf extends IDeserializable<TSelf>> implements ISerializable
{
  TSelf Deserialize(String json);
}