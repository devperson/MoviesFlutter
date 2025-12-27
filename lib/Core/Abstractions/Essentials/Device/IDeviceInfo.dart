import '../../Common/VersionInfo.dart';
import 'DevicePlatform.dart';
import 'DeviceIdiom.dart';
import 'DeviceTypeEnum.dart';

/// Represents information about the device.
abstract interface class IDeviceInfo
{
    /// Gets the model of the device.
    String get Model;

    /// Gets the manufacturer of the device.
    String get Manufacturer;

    /// Gets the name of the device.
    ///
    /// This value is often specified by the user of the device.
    String get Name;

    /// Gets the string representation of the version of the operating system.
    String get VersionString;

    /// Gets the version of the operating system.
    VersionInfo get Version;

    /// Gets the platform or operating system of the device.
    DevicePlatform get Platform;

    /// Gets the idiom (form factor) of the device.
    DeviceIdiom get Idiom;

    /// Gets the type of device the application is running on.
    DeviceTypeEnum get DeviceType;
}
