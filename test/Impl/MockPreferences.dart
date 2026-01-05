import 'package:movies_flutter/Core/Abstractions/Essentials/IPreferences.dart';

class Mockpreferences implements IPreferences
{
  Map<String, Object> _map = {};

  @override
  void Clear() {
    // TODO: implement Clear
  }

  @override
  bool ContainsKey(String key)
  {
    return _map.containsKey(key);
  }

  @override
  T Get<T>(String key, T defaultValue)
  {
     if(ContainsKey(key))
       {
         return _map[key] as T;
       }
       else
       {
         return defaultValue;
       }
  }

  @override
  void Remove(String key)
  {
    if(ContainsKey(key))
      {
        _map.remove(key);
      }
  }

  @override
  void Set<T>(String key, T value)
  {
    if(!ContainsKey(key))
      {
        _map[key] = value as Object;
      }
  }

}