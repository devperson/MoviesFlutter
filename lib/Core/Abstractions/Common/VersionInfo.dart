class VersionInfo implements Comparable<VersionInfo> {
    final int major;
    final int minor;
    final int build;
    final int revision;

    VersionInfo._(this.major, this.minor, this.build, this.revision) {
        if (major < 0) throw ArgumentError("Major version cannot be negative.");
        if (minor < 0) throw ArgumentError("Minor version cannot be negative.");
        if (build != -1 && build < 0) throw ArgumentError("Build cannot be negative.");
        if (revision != -1 && revision < 0) throw ArgumentError("Revision cannot be negative.");
    }

    VersionInfo(int major, int minor, [int build = -1, int revision = -1]) : this._(major, minor, build, revision);

    factory VersionInfo.fromString(String version) {
        final parsed = parse(version);
        return VersionInfo._(parsed.major, parsed.minor, parsed.build, parsed.revision);
    }

    // region --- Computed properties ---
    int get majorRevision => (revision >> 16);
    int get minorRevision => (revision & 0xFFFF);
    // endregion

    // region --- Comparison ---
    @override
    int compareTo(VersionInfo other) {
        if (major != other.major) return major.compareTo(other.major);
        if (minor != other.minor) return minor.compareTo(other.minor);
        if (build != other.build) return build.compareTo(other.build);
        if (revision != other.revision) return revision.compareTo(other.revision);
        return 0;
    }

    @override
    bool operator ==(Object other) {
        if (identical(this, other)) return true;
        if (other is! VersionInfo) return false;
        return major == other.major &&
                minor == other.minor &&
                build == other.build &&
                revision == other.revision;
    }

    @override
    int get hashCode {
        var acc = 0;
        acc = acc | ((major & 0x0000000F) << 28);
        acc = acc | ((minor & 0x000000FF) << 20);
        acc = acc | ((build & 0x000000FF) << 12);
        acc = acc | (revision & 0x00000FFF);
        return acc;
    }

    @override
    String toString() {
        final parts = [major, minor];
        if (build >= 0) parts.add(build);
        if (revision >= 0) parts.add(revision);
        return parts.join(".");
    }
    // endregion

    // region --- Companion: parsing, tryParse ---
    static VersionInfo ParseVersion(String version)
    {
        try
        {
            return parse(version);
        }
        catch (e)
        {
            // Continue to next parsing attempt
        }

        final major = int.tryParse(version);
        if (major != null)
        {
            return VersionInfo(major, 0);
        }

        return VersionInfo(0, 0);
    }

    static VersionInfo parse(String input) {
        if (input.trim().isEmpty) throw ArgumentError("Input cannot be blank");
        final parts = input.split('.');
        if (parts.length < 2 || parts.length > 4)
            throw ArgumentError("Invalid version format: $input");

        int parsePart(String s, String name) {
            final v = int.tryParse(s);
            if (v == null) throw ArgumentError("Invalid number in version part: $name = $s");
            if (v < 0) throw ArgumentError("Negative version component: $name");
            return v;
        }

        final major = parsePart(parts[0], "major");
        final minor = parsePart(parts[1], "minor");
        final build = (parts.length >= 3) ? parsePart(parts[2], "build") : -1;
        final revision = (parts.length == 4) ? parsePart(parts[3], "revision") : -1;
        return VersionInfo._(major, minor, build, revision);
    }

    static VersionInfo? tryParse(String? input) {
        try {
            if (input == null) return null;
            return parse(input);
        } catch (_) {
            return null;
        }
    }
    // endregion
}
