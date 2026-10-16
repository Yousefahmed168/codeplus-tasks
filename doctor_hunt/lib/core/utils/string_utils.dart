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
}
