/// Represents the device platform that the application is running on.
class DevicePlatform
{
    final String _devicePlatform;

    const DevicePlatform._(this._devicePlatform);

    /// Gets an instance of DevicePlatform that represents Android.
    static const DevicePlatform Android = DevicePlatform._("Android");

    /// Gets an instance of DevicePlatform that represents iOS.
    static const DevicePlatform iOS = DevicePlatform._("iOS");

    /// Gets an instance of DevicePlatform that represents macOS.
    /// Note, this is different than MacCatalyst.
    static const DevicePlatform macOS = DevicePlatform._("macOS");

    /// Gets an instance of DevicePlatform that represents Mac Catalyst.
    /// Note, this is different than macOS.
    static const DevicePlatform MacCatalyst = DevicePlatform._("MacCatalyst");

    /// Gets an instance of DevicePlatform that represents Apple tvOS.
    static const DevicePlatform tvOS = DevicePlatform._("tvOS");

    /// Gets an instance of DevicePlatform that represents Samsung Tizen.
    static const DevicePlatform Tizen = DevicePlatform._("Tizen");

    /// Gets an instance of DevicePlatform that represents UWP.
    @Deprecated("Use WinUI instead.")
    static const DevicePlatform UWP = DevicePlatform._("UWP");

    /// Gets an instance of DevicePlatform that represents WinUI.
    static const DevicePlatform WinUI = DevicePlatform._("WinUI");

    /// Gets an instance of DevicePlatform that represents WinUI.
    static const DevicePlatform Windows = DevicePlatform._("Windows");

    /// Gets an instance of DevicePlatform that represents Apple watchOS.
    static const DevicePlatform watchOS = DevicePlatform._("watchOS");

    /// Gets an instance of DevicePlatform that represents Linux.
    static const DevicePlatform Linux = DevicePlatform._("Linux");

    /// Gets an instance of DevicePlatform that represents Web.
    static const DevicePlatform Web = DevicePlatform._("Web");

    /// Gets an instance of DevicePlatform that represents an unknown platform. This is used for when the current platform is unknown.
    static const DevicePlatform Unknown = DevicePlatform._("Unknown");

    /// Creates a new device platform instance. This can be used to define your custom platforms.
    /// [devicePlatform] The device platform identifier.
    /// Returns A new instance of DevicePlatform with the specified platform identifier.
    factory DevicePlatform.Create(String devicePlatform) {
        if (devicePlatform.isEmpty) throw ArgumentError("devicePlatform cannot be empty");
        return DevicePlatform._(devicePlatform);
    }

    /// Compares the underlying DevicePlatform instances.
    /// [other] DevicePlatform object to compare with.
    /// Returns true if they are equal, otherwise false.
    bool Equals(DevicePlatform other) => _devicePlatform == other._devicePlatform;

    @override
    bool operator ==(Object other) => other is DevicePlatform && Equals(other);

    /// Gets the hash code for this platform instance.
    /// Returns The computed hash code for this device platform or 0 when the device platform is null.
    @override
    int get hashCode => _devicePlatform.hashCode;

    /// Returns a string representation of the current value of the device platform.
    /// Returns A string representation of this instance in the format of {device platform} or an empty string when no device platform is set.
    @override
    String toString() => _devicePlatform;
}
