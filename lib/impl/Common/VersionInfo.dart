class VersionInfo implements Comparable<VersionInfo> {
  final int major;
  final int minor;
  final int build;
  final int revision;

  VersionInfo({
    required this.major,
    required this.minor,
    this.build = -1,
    this.revision = -1,
  }) {
    if (major < 0) {
      throw ArgumentError('Major version cannot be negative.');
    }
    if (minor < 0) {
      throw ArgumentError('Minor version cannot be negative.');
    }
    if (build != -1 && build < 0) {
      throw ArgumentError('Build cannot be negative.');
    }
    if (revision != -1 && revision < 0) {
      throw ArgumentError('Revision cannot be negative.');
    }
  }

  /// High 16 bits of revision
  int get majorRevision => (revision >> 16) & 0xFFFF;

  /// Low 16 bits of revision
  int get minorRevision => revision & 0xFFFF;

  // ------------------------
  // Comparable
  // ------------------------

  @override
  int compareTo(VersionInfo other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    if (build != other.build) return build.compareTo(other.build);
    if (revision != other.revision) {
      return revision.compareTo(other.revision);
    }
    return 0;
  }

  // ------------------------
  // Equality
  // ------------------------

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is VersionInfo &&
              major == other.major &&
              minor == other.minor &&
              build == other.build &&
              revision == other.revision;

  @override
  int get hashCode => Object.hash(major, minor, build, revision);

  // ------------------------
  // String
  // ------------------------

  @override
  String toString() {
    final parts = <int>[major, minor];
    if (build >= 0) parts.add(build);
    if (revision >= 0) parts.add(revision);
    return parts.join('.');
  }

  // ------------------------
  // Parsing
  // ------------------------

  static VersionInfo parseVersion(String version) {
    final parsed = tryParse(version);
    if (parsed != null) return parsed;

    final major = int.tryParse(version);
    if (major != null) {
      return VersionInfo(major: major, minor: 0);
    }

    return VersionInfo(major: 0, minor: 0);
  }

  static VersionInfo parse(String input) {
    final s = input.trim();
    if (s.isEmpty) {
      throw ArgumentError('Input cannot be blank');
    }

    final parts = s.split('.');
    if (parts.length < 2 || parts.length > 4) {
      throw ArgumentError('Invalid version format: $input');
    }

    int parsePart(String value, String name) {
      final v = int.tryParse(value);
      if (v == null || v < 0) {
        throw FormatException(
          'Invalid number in version part: $name = $value',
        );
      }
      return v;
    }

    final major = parsePart(parts[0], 'major');
    final minor = parsePart(parts[1], 'minor');
    final build =
    parts.length >= 3 ? parsePart(parts[2], 'build') : -1;
    final revision =
    parts.length == 4 ? parsePart(parts[3], 'revision') : -1;

    return VersionInfo(
      major: major,
      minor: minor,
      build: build,
      revision: revision,
    );
  }

  static VersionInfo? tryParse(String? input) {
    if (input == null) return null;
    try {
      return parse(input);
    } catch (_) {
      return null;
    }
  }
}

// ------------------------------------------------------------
// Nullable comparison helper (matches Swift behavior)
// ------------------------------------------------------------

int compareNullable(VersionInfo? lhs, VersionInfo? rhs) {
  if (lhs == null) return rhs == null ? 0 : -1;
  if (rhs == null) return 1;

  final c = lhs.compareTo(rhs);
  if (c < 0) return -1;
  if (c > 0) return 1;
  return 0;
}
