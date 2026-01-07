import 'package:movies_flutter/Core/Abstractions/Common/AppException.dart';

import '../../../Abstractions/REST/Json/IJsonMapper.dart';
import '../../../Abstractions/REST/Json/IJsonModel.dart';

class JsonMapper implements IJsonMapper
{
  final Map<Type, IDeserializable> _prototypes = {};

  @override
  void Register<T extends IDeserializable<T>>(T prototype)
  {
    _prototypes[T] = prototype;
  }

  String Serialize(Object model)
  {
    if(model is! ISerializable)
      throw AppException.Throw('The model $model is implemented the IJsonModel. Please implement IJsonModel for this REST model and register it in the JsonMapper(IJsonMapper)');

    return model.Serialize();
  }

  @override
  T Deserialize<T extends IDeserializable<T>>(String json)
  {
    final proto = _prototypes[T];
    if (proto == null)
    {
      throw AppException.Throw('Type $T is not registered. Please use JsonMapper(IJsonMapper) to register the REST model');
    }
    return (proto as T).Deserialize(json);
  }


}