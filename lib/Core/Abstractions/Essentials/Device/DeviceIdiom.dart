/// Represents the idiom (form factor) of the device.
class DeviceIdiom
{
    final String _deviceIdiom;

    const DeviceIdiom._(this._deviceIdiom);

    /// Gets an instance of DeviceIdiom that represents a (mobile) phone idiom.
    static const DeviceIdiom Phone = DeviceIdiom._("Phone");

    /// Gets an instance of DeviceIdiom that represents a tablet idiom.
    static const DeviceIdiom Tablet = DeviceIdiom._("Tablet");

    /// Gets an instance of DeviceIdiom that represents a desktop computer idiom.
    static const DeviceIdiom Desktop = DeviceIdiom._("Desktop");

    /// Gets an instance of DeviceIdiom that represents a television (TV) idiom.
    static const DeviceIdiom TV = DeviceIdiom._("TV");

    /// Gets an instance of DeviceIdiom that represents a watch idiom.
    static const DeviceIdiom Watch = DeviceIdiom._("Watch");

    /// Gets an instance of DeviceIdiom that represents an unknown idiom. This is used for when the current device idiom is unknown.
    static const DeviceIdiom Unknown = DeviceIdiom._("Unknown");

    /// Creates a new device idiom instance. This can be used to define your custom idioms.
    /// [deviceIdiom] The idiom name of the device.
    /// Returns A new instance of DeviceIdiom with the specified idiom type.
    factory DeviceIdiom.Create(String deviceIdiom) {
        if (deviceIdiom.isEmpty) throw ArgumentError("deviceIdiom cannot be empty");
        return DeviceIdiom._(deviceIdiom);
    }

    /// Compares the underlying DeviceIdiom instances.
    /// [other] DeviceIdiom object to compare with.
    /// Returns true if they are equal, otherwise false.
    bool Equals(DeviceIdiom other) => _deviceIdiom == other._deviceIdiom;

    @override
    bool operator ==(Object other) => other is DeviceIdiom && Equals(other);

    /// Gets the hash code for this idiom instance.
    /// Returns The computed hash code for this device idiom.
    @override
    int get hashCode => _deviceIdiom.hashCode;

    /// Returns a string representation of the current device idiom.
    /// Returns A string representation of this instance in the format of {device idiom} or an empty string when no device idiom is set.
    @override
    String toString() => _deviceIdiom;
}
