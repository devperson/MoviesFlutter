
abstract interface class INavigationParameters
{
  bool ContainsKey(String key);
  T? GetValue<T>(String key);
  int Count();
}

class NavigationParameters implements INavigationParameters
{
    final List<(String, Object?)> _entries = [];

    NavigationParameters();

    NavigationParameters.FromMap(Map<String, dynamic>? map)
    {
      if (map == null)
      {
        return;
      }

      map.forEach((key, value)
      {
        _entries.add((key, value));
      });
    }

    NavigationParameters.WithKeyValue(String key, Object? value)
    {
      Add(key, value);
    }

    void Add(String key, Object? value)
    {
      final index = _entries.indexWhere((e) => e.$1 == key);

      if (index != -1)
      {
        _entries[index] = (key, value);
      }
      else
      {
        _entries.add((key, value));
      }
    }

    /// Fluent API (similar to @discardableResult in Swift)
    NavigationParameters With(String key, Object? value)
    {
      Add(key, value);
      return this;
    }

    /// Subscript operator
    Object? operator [](String key)
    {
      final entry = _entries.where((e) => e.$1 == key).firstOrNull;
      return entry?.$2;
    }

    @override
    bool ContainsKey(String key)
    {
      return _entries.any((e) => e.$1 == key);
    }

    @override
    T? GetValue<T>(String key)
    {
      final value = this[key];

      if (value is T)
      {
        return value;
      }

      return null;
    }

    @override
    int Count()
    {
      return _entries.length;
    }

    List<(String, Object?)> AllEntries()
    {
      return List.unmodifiable(_entries);
    }

    /// 🔁 NavigationParameters → Map
    Map<String, dynamic> ToMap()
    {
      final map = <String, dynamic>{};

      for (final entry in _entries)
      {
        map[entry.$1] = entry.$2;
      }

      return map;
    }
}