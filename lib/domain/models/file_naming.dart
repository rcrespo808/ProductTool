/// Utilities for generating file names according to the naming convention:
/// {barcode}_{index}_{tag1}-{tag2}-{tag3}.jpg
class FileNaming {
  /// Normalizes a tag for storage consistency: lowercase and trim
  /// Use this for storing tags in AuditImage and TagTrie
  static String normalizeTag(String tag) {
    return tag.toLowerCase().trim();
  }

  /// Sanitizes a tag for file names: lowercase, replace spaces/special chars with hyphens
  /// Use this when generating file names
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

  /// Sanitizes a barcode for use in file names
  /// Removes invalid filesystem characters and limits length
  static String sanitizeBarcode(String barcode) {
    return barcode
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '') // Remove invalid filesystem chars
        .replaceAll(RegExp(r'\s+'), '_') // Replace spaces with underscores
        .replaceAll(RegExp(r'_+'), '_') // Collapse multiple underscores
        .replaceAll(RegExp(r'^_|_$'), '') // Remove leading/trailing underscores
        .substring(0, barcode.length > 100 ? 100 : barcode.length); // Limit length
  }

  /// Generates a file name: {barcode}_{index}_{tag1}-{tag2}.jpg
  /// - barcode: The product barcode (will be sanitized)
  /// - index: Zero-based index, will be padded to 3 digits (001, 002, etc.)
  /// - tags: List of tags (will be sanitized and joined)
  /// - extension: File extension (defaults to 'jpg')
  /// 
  /// Ensures total filename length stays within filesystem limits (255 chars).
  /// Truncates tags if needed to fit within limit while preserving barcode and index.
  static String generateFileName({
    required String barcode,
    required int index,
    required List<String> tags,
    String extension = 'jpg',
  }) {
    final sanitizedBarcode = sanitizeBarcode(barcode);
    final paddedIndex = index.toString().padLeft(3, '0');
    final tagString = sanitizeTags(tags);
    
    // Calculate required length: barcode + index + separators + extension + dot
    const maxLength = 255; // Most filesystem limit
    final reservedLength = sanitizedBarcode.length + // barcode
                           3 + // index (always 3 digits)
                           2 + // separators (_)
                           extension.length + // extension
                           1; // dot before extension
    
    // Truncate tags if needed to fit within limit
    final maxTagLength = (maxLength - reservedLength).clamp(0, maxLength);
    final finalTagString = tagString.length > maxTagLength
        ? tagString.substring(0, maxTagLength)
        : tagString;
    
    return '${sanitizedBarcode}_${paddedIndex}_${finalTagString}.${extension}';
  }
}

