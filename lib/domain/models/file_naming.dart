/// Utilities for generating file names according to the naming convention:
/// {barcode}{index}{tag1}-{tag2}-{tag3}.jpg
class FileNaming {
  /// Sanitizes a tag: lowercase, replace spaces/special chars with hyphens
  static String sanitizeTag(String tag) {
    return tag
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '') // Remove special chars except hyphens
        .replaceAll(RegExp(r'\s+'), '-') // Replace spaces with hyphens
        .replaceAll(RegExp(r'-+'), '-') // Collapse multiple hyphens
        .replaceAll(RegExp(r'^-|-$'), ''); // Remove leading/trailing hyphens
  }

  /// Sanitizes a list of tags and joins them
  static String sanitizeTags(List<String> tags) {
    if (tags.isEmpty) {
      return 'no-tags';
    }
    return tags.map(sanitizeTag).where((t) => t.isNotEmpty).join('-');
  }

  /// Generates a file name: {barcode}{index}{tag1}-{tag2}.jpg
  /// - barcode: The product barcode
  /// - index: Zero-based index, will be padded to 3 digits (001, 002, etc.)
  /// - tags: List of tags (will be sanitized and joined)
  static String generateFileName({
    required String barcode,
    required int index,
    required List<String> tags,
    String extension = 'jpg',
  }) {
    final paddedIndex = index.toString().padLeft(3, '0');
    final tagString = sanitizeTags(tags);
    return '$barcode$paddedIndex$tagString.$extension';
  }
}

