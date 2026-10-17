/// Shared string helpers used across features.
class StringUtils {
  StringUtils._();

  /// Returns up to two uppercase initials for a display [name].
  ///
  /// Falls back to `'A'` for an empty name so avatar placeholders always
  /// render something meaningful.
  static String getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'A';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  /// Masks a display name for public surfaces, keeping the first name and the
  /// initial of the last part (`Ahmed Ali` -> `Ahmed A.`). Single-word names are
  /// returned unchanged; an empty name yields an empty string.
  static String maskName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first;
    return '${parts.first} ${parts.last[0].toUpperCase()}.';
  }
}
