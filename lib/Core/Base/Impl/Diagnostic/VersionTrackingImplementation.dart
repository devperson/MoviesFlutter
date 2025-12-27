import '../../../Abstractions/Essentials/IAppInfo.dart';
import '../../../Abstractions/Essentials/IPreferences.dart';
import '../../../Abstractions/Essentials/IVersionTracking.dart';
import '../Utils/LazyInjected.dart';
import 'LoggableService.dart';

class VersionTrackingImplementation with LoggableService implements IVersionTracking
{
    final preferences = LazyInjected<IPreferences>();
    final appInfo = LazyInjected<IAppInfo>();

    final String versionsKey = "VersionTracking.Versions";
    final String buildsKey = "VersionTracking.Builds";
    late final String sharedName;

    late Map<String, List<String>> versionTrail;

    String get LastInstalledVersion => versionTrail[versionsKey]?.lastOrNull ?? "";

    String get LastInstalledBuild => versionTrail[buildsKey]?.lastOrNull ?? "";

    VersionTrackingImplementation()
    {
        sharedName = "${appInfo.Value.PackageName}.essentials.versiontracking";
        Track();
    }

    @override
    void Track()
    {
        LogMethodStart("Track");
        // In Dart, checking for late initialization isn't straightforward like Kotlin's ::prop.isInitialized
        // But since we call this in constructor, we can just run Init.
        // If we need to protect against re-init, we can check a flag.
        try {
            // simpler check: if versionTrail is set.
            versionTrail;
            return;
        } catch (_) {
            InitVersionTracking();
        }
    }

    /// Initialize VersionTracking module, load data and track current version
    /// For internal use. Usually only called once in production code, but multiple times in unit tests
    void InitVersionTracking()
    {
        LogMethodStart("InitVersionTracking");
        IsFirstLaunchEver = !preferences.Value.ContainsKey(versionsKey, sharedName: sharedName) || !preferences.Value.ContainsKey(buildsKey, sharedName: sharedName);
        if (IsFirstLaunchEver)
        {
            versionTrail = {
                versionsKey: [],
                buildsKey: []
            };
        }
        else
        {
            versionTrail = {
                versionsKey: ReadHistory(versionsKey).toList(),
                buildsKey: ReadHistory(buildsKey).toList()
            };
        }

        IsFirstLaunchForCurrentVersion = !versionTrail[versionsKey]!.contains(CurrentVersion) || CurrentVersion != LastInstalledVersion;
        if (IsFirstLaunchForCurrentVersion)
        {
            // Avoid duplicates and move current version to end of list if already present
            versionTrail[versionsKey]!.removeWhere((v) => v == CurrentVersion);
            versionTrail[versionsKey]!.add(CurrentVersion);
        }

        IsFirstLaunchForCurrentBuild = !versionTrail[buildsKey]!.contains(CurrentBuild) || CurrentBuild != LastInstalledBuild;
        if (IsFirstLaunchForCurrentBuild)
        {
            // Avoid duplicates and move current build to end of list if already present
            versionTrail[buildsKey]!.removeWhere((b) => b == CurrentBuild);
            versionTrail[buildsKey]!.add(CurrentBuild);
        }

        if (IsFirstLaunchForCurrentVersion || IsFirstLaunchForCurrentBuild)
        {
            WriteHistory(versionsKey, versionTrail[versionsKey]!);
            WriteHistory(buildsKey, versionTrail[buildsKey]!);
        }
    }

    @override
    bool IsFirstLaunchEver = false;

    @override
    bool IsFirstLaunchForCurrentVersion = false;

    @override
    bool IsFirstLaunchForCurrentBuild = false;

    @override
    String get CurrentVersion => appInfo.Value.VersionString;

    @override
    String get CurrentBuild => appInfo.Value.BuildString;

    @override
    String? get PreviousVersion => GetPrevious(versionsKey);

    @override
    String? get PreviousBuild => GetPrevious(buildsKey);

    @override
    String? get FirstInstalledVersion => versionTrail[versionsKey]?.firstOrNull;

    @override
    String? get FirstInstalledBuild => versionTrail[buildsKey]?.firstOrNull;

    @override
    List<String> get VersionHistory => versionTrail[versionsKey]?.toList() ?? [];

    @override
    List<String> get BuildHistory => versionTrail[buildsKey]?.toList() ?? [];

    @override
    bool IsFirstLaunchForVersion(String version) {
        LogMethodStart("IsFirstLaunchForVersion", [version]);
        return CurrentVersion == version && IsFirstLaunchForCurrentVersion;
    }

    @override
    bool IsFirstLaunchForBuild(String build) {
        LogMethodStart("IsFirstLaunchForBuild", [build]);
        return CurrentBuild == build && IsFirstLaunchForCurrentBuild;
    }

    String GetStatus()
    {
        LogMethodStart("GetStatus");
        final sb = StringBuffer();
        sb.writeln();
        sb.writeln("VersionTracking");
        sb.writeln("  IsFirstLaunchEver:              $IsFirstLaunchEver");
        sb.writeln("  IsFirstLaunchForCurrentVersion: $IsFirstLaunchForCurrentVersion");
        sb.writeln("  IsFirstLaunchForCurrentBuild:   $IsFirstLaunchForCurrentBuild");
        sb.writeln();
        sb.writeln("  CurrentVersion:                 $CurrentVersion");
        sb.writeln("  PreviousVersion:                $PreviousVersion");
        sb.writeln("  FirstInstalledVersion:          $FirstInstalledVersion");
        sb.writeln("  VersionHistory:                 [${VersionHistory.join(", ")}]");
        sb.writeln();
        sb.writeln("  CurrentBuild:                   $CurrentBuild");
        sb.writeln("  PreviousBuild:                  $PreviousBuild");
        sb.writeln("  FirstInstalledBuild:            $FirstInstalledBuild");
        sb.writeln("  BuildHistory:                   [${BuildHistory.join(", ")}]");
        return sb.toString();
    }

    List<String> ReadHistory(String key) {
        LogMethodStart("ReadHistory", [key]);
        return preferences.Value.Get<String?>(key, null, sharedName: sharedName)?.split('|').where((it) => it.isNotEmpty).toList() ?? [];
    }

    void WriteHistory(String key, List<String> history) {
        LogMethodStart("WriteHistory", [key, history]);
        preferences.Value.Set(key, history.join("|"), sharedName: sharedName);
    }

    String? GetPrevious(String key)
    {
        LogMethodStart("GetPrevious", [key]);
        final trail = versionTrail[key]!;
        return (trail.length >= 2) ? trail[trail.length - 2] : null;
    }
}
