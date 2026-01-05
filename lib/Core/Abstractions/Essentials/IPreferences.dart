/// The Preferences API helps to store application preferences in a key/value store.
///
/// Each platform uses the platform-provided APIs for storing application/user preferences:
/// - iOS: NSUserDefaults
/// - Android: SharedPreferences
/// - Windows: ApplicationDataContainer
abstract interface class IPreferences
{
    /// Checks for the existence of a given key.
    ///
    /// [key] The key to check.
    /// [sharedName] Shared container name.
    /// Returns `true` if the key exists in the preferences, otherwise `false`.
    bool ContainsKey(String key);

    /// Removes a key and its associated value if it exists.
    ///
    /// [key] The key to remove.
    /// [sharedName] Shared container name.
    void Remove(String key);

    /// Clears all keys and values.
    ///
    /// [sharedName] Shared container name.
    void Clear();

    /// Sets a value for a given key.
    ///
    /// [T] Type of the object that is stored in this preference.
    /// [key] The key to set the value for.
    /// [value] Value to set.
    /// [sharedName] Shared container name.
    void Set<T>(String key, T value);

    /// Gets the value for a given key, or the default specified if the key does not exist.
    ///
    /// [T] The type of the object stored for this preference.
    /// [key] The key to retrieve the value for.
    /// [defaultValue] The default value to return when no existing value for [key] exists.
    /// [sharedName] Shared container name.
    /// Returns Value for the given key, or the value in [defaultValue] if it does not exist.
    T Get<T>(String key, T defaultValue);
}
