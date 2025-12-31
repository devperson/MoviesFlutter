import 'package:shared_preferences/shared_preferences.dart';
import '../../../Abstractions/Essentials/IPreferences.dart';


class F_PreferencesImplementation implements IPreferences
{
  SharedPreferences? _prefs;

  F_PreferencesImplementation()
  {
    InitializeAsync();
  }

  Future<void> InitializeAsync() async
  {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  bool ContainsKey(String key, {String? sharedName})
  {
    return _prefs!.containsKey(key) ?? false;
  }

  @override
  Future<void> Remove(String key, {String? sharedName}) async
  {
    await _prefs!.remove(key);
  }

  @override
  Future<void> Clear({String? sharedName}) async
  {
    await _prefs!.clear();
  }

  @override
  Future<void> Set<T>(String key, T? value, {String? sharedName}) async
  {
    if (value == null)
    {
      await _prefs!.remove(key);
      return;
    }

    if (value is String)
      await _prefs!.setString(key, value);
    else if (value is int)
      await _prefs!.setInt(key, value);
    else if (value is bool)
      await _prefs!.setBool(key, value);
    else if (value is double)
      await _prefs!.setDouble(key, value);
    else if (value is DateTime)
      await _prefs!.setInt(key, value.millisecondsSinceEpoch);
    else
      throw UnsupportedError('Unsupported preference type: ${value.runtimeType}');
  }

  @override
  T Get<T>(String key, T defaultValue, {String? sharedName})
  {
    if (defaultValue is String)
      return (_prefs!.getString(key) ?? defaultValue) as T;
    if (defaultValue is int)
      return (_prefs!.getInt(key) ?? defaultValue) as T;
    if (defaultValue is bool)
      return (_prefs!.getBool(key) ?? defaultValue) as T;
    if (defaultValue is double)
      return (_prefs!.getDouble(key) ?? defaultValue) as T;
    if (defaultValue is DateTime)
    {
      final millis = _prefs!.getInt(key);
      return (millis != null
          ? DateTime.fromMillisecondsSinceEpoch(millis)
          : defaultValue) as T;
    }

    return defaultValue;
  }
}
