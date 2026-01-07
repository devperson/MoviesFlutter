import 'package:movies_flutter/Core/Abstractions/Essentials/IPreferences.dart';

class InMemoryPreferences implements IPreferences {
  final Map<String, Object?> _store = <String, Object?>{};
  bool _initialized = false;

  @override
  Future<void> InitializeAsync() async
  {
    // For unit tests there is nothing to initialize,
    // but we keep the async contract to match real implementations.
    //_initialized = true;
  }

  void _ensureInitialized()
  {
    // if (!_initialized) {
    //   throw StateError(
    //     'IPreferences must be initialized before use. '
    //         'Call InitializeAsync().',
    //   );
    // }
  }

  @override
  bool ContainsKey(String key) {
    _ensureInitialized();
    return _store.containsKey(key);
  }

  @override
  void Remove(String key) {
    _ensureInitialized();
    _store.remove(key);
  }

  @override
  void Clear() {
    _ensureInitialized();
    _store.clear();
  }

  @override
  void Set<T>(String key, T value) {
    _ensureInitialized();
    _store[key] = value;
  }

  @override
  T Get<T>(String key, T defaultValue)
  {
    _ensureInitialized();

    final value = _store[key];
    if (value == null) {
      return defaultValue;
    }

    // Fail fast if type mismatch (very useful in tests)
    if (value is! T) {
      throw StateError(
        'Stored value for key "$key" is of type '
            '${value.runtimeType}, expected $T',
      );
    }

    return value as T;
  }
}