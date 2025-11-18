/// Utilities for generating file names according to the naming convention:
/// {barcode}__{index}.jpg
class FileNaming {
  /// Sanitizes a barcode for use in file names
  /// Removes invalid filesystem characters and limits length
  static String sanitizeBarcode(String barcode) {
    return barcode
        .replaceAll(
            RegExp(r'[<>:"/\\|?*]'), '') // Remove invalid filesystem chars
        .replaceAll(RegExp(r'\s+'), '_') // Replace spaces with underscores
        .replaceAll(RegExp(r'_+'), '_') // Collapse multiple underscores
        .replaceAll(RegExp(r'^_|_$'), '') // Remove leading/trailing underscores
        .substring(
            0, barcode.length > 100 ? 100 : barcode.length); // Limit length
  }

  /// Generates a file name: {barcode}__{index}.jpg
  /// - barcode: The product barcode (will be sanitized)
  /// - index: 1-based index, will be padded to 3 digits (001, 002, etc.)
  /// - extension: File extension (defaults to 'jpg')
  ///
  /// Format: {barcode}__{index}.{extension}
  /// Example: 1234567890__001.jpg (first photo), 1234567890__002.jpg (second photo)
  static String generateFileName({
    required String barcode,
    required int index,
    String extension = 'jpg',
  }) {
    final sanitizedBarcode = sanitizeBarcode(barcode);
    final paddedIndex = index.toString().padLeft(3, '0');

    return '${sanitizedBarcode}__${paddedIndex}.${extension}';
  }
}
