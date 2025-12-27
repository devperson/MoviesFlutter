/// The VersionTracking API provides an easy way to track an app's version on a device.
abstract interface class IVersionTracking
{
    /// Starts tracking version information.
    void Track();

    /// Gets a value indicating whether this is the first time this app has ever been launched on this device.
    bool get IsFirstLaunchEver;

    /// Gets a value indicating if this is the first launch of the app for the current version number.
    bool get IsFirstLaunchForCurrentVersion;

    /// Gets a value indicating if this is the first launch of the app for the current build number.
    bool get IsFirstLaunchForCurrentBuild;

    /// Gets the current version number of the app.
    String get CurrentVersion;

    /// Gets the current build of the app.
    String get CurrentBuild;

    /// Gets the version number for the previously run version.
    String? get PreviousVersion;

    /// Gets the build number for the previously run version.
    String? get PreviousBuild;

    /// Gets the version number of the first version of the app that was installed on this device.
    String? get FirstInstalledVersion;

    /// Gets the build number of first version of the app that was installed on this device.
    String? get FirstInstalledBuild;

    /// Gets the collection of version numbers of the app that ran on this device.
    List<String> get VersionHistory;

    /// Gets the collection of build numbers of the app that ran on this device.
    List<String> get BuildHistory;

    /// Determines if this is the first launch of the app for a specified version number.
    /// [version] The version number.
    /// Returns true if this is the first launch of the app for the specified version number; otherwise false.
    bool IsFirstLaunchForVersion(String version);

    /// Determines if this is the first launch of the app for a specified build number.
    /// [build] The build number.
    /// Returns true if this is the first launch of the app for the specified build number; otherwise false.
    bool IsFirstLaunchForBuild(String build);
}
