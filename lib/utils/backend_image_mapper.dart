/// Utility for mapping backend image filenames to local image indices
class BackendImageMapper {
  /// Extracts the position number from a backend image URL/filename
  /// Backend format: {EAN}-{position}.{ext} (e.g., "1234567890123-01.jpg")
  /// Returns the position number (1-based), or null if extraction fails
  static int? extractPositionFromBackendUrl(String backendUrl) {
    try {
      // Extract filename from URL (handle both full URLs and filenames)
      final filename = backendUrl.split('/').last;

      // Pattern: {EAN}-{position}.{ext}
      // Extract position by finding the last dash before the extension
      final lastDashIndex = filename.lastIndexOf('-');
      if (lastDashIndex == -1) {
        return null;
      }

      final afterDash = filename.substring(lastDashIndex + 1);
      final dotIndex = afterDash.indexOf('.');
      if (dotIndex == -1) {
        return null;
      }

      final positionStr = afterDash.substring(0, dotIndex);
      final position = int.tryParse(positionStr);
      return position;
    } catch (e) {
      return null;
    }
  }

  /// Maps backend image URLs to local image indices
  /// Returns a map: localImageIndex -> backendUrl
  /// where localImageIndex is the 1-based index matching AuditImage.index
  static Map<int, String> mapBackendImagesToLocalIndices(
    List<String> backendImageUrls,
  ) {
    final Map<int, String> mapping = {};

    for (final url in backendImageUrls) {
      final position = extractPositionFromBackendUrl(url);
      if (position != null) {
        // Backend position is 1-based, matches local index
        mapping[position] = url;
      }
    }

    return mapping;
  }

  /// Checks if a backend URL is in the failed images list
  static bool isFailedImage(String url, List<String> failedImages) {
    return failedImages.contains(url);
  }
}

