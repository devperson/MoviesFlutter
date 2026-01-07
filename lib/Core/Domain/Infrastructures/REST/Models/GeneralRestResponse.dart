import '../../../../Abstractions/REST/Json/IJsonModel.dart';

class VoidResponse implements IDeserializable<VoidResponse>
{
  @override
  VoidResponse Deserialize(String json)
  {
    return VoidResponse();
  }

  @override
  String Serialize()
  {
    return "{}";
  }
}


