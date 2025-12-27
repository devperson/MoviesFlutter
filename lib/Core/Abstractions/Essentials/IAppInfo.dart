import '../Common/VersionInfo.dart';

/// Represents information about the application.
abstract interface class IAppInfo
{
    /// Gets the application package name or identifier.
    ///
    /// On Android and iOS, this is the application package name. On Windows, this is the application GUID.
    String get PackageName;

    /// Gets the application name.
    String get Name;

    /// Gets the application version as a string representation.
    String get VersionString;

    /// Gets the application version as a [VersionInfo] object.
    VersionInfo get Version;

    /// Gets the application build number.
    String get BuildString;

    /// Open the settings menu or page for this application.
    void ShowSettingsUI();

    /// Gets the requested layout direction of the system or application.
    LayoutDirection get RequestedLayoutDirection;
}

/// Enumerates possible layout directions.
enum LayoutDirection
{
    /// The requested layout direction is unknown.
    Unknown,

    /// The requested layout direction is left-to-right.
    LeftToRight,

    /// The requested layout direction is right-to-left.
    RightToLeft
}
