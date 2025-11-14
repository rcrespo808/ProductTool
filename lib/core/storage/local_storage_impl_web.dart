import 'dart:typed_data';
import 'dart:html' as html;
import 'local_storage_service.dart';
import '../util/result.dart';

/// Web implementation of LocalStorageService using browser download API
/// For web platform
class LocalStorageServiceImpl implements LocalStorageService {
  @override
  Future<Result<String>> getImageDirectory() async {
    // On web, we use downloads instead of a persistent directory
    // Return a virtual path that indicates download location
    return const Success('downloads/audit_images/');
  }

  @override
  Future<Result<String>> saveImageBytes(
    Uint8List bytes, {
    required String fileName,
  }) async {
    try {
      // Create a blob from the bytes
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Create a download link
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..style.display = 'none';

      // Add to DOM, click, and remove
      html.document.body?.append(anchor);
      anchor.click();
      anchor.remove();

      // Revoke the object URL
      html.Url.revokeObjectUrl(url);

      // Return a virtual path indicating the file was downloaded
      return Success('downloads/audit_images/$fileName');
    } catch (e) {
      return Failure(
        'Failed to save image: ${e.toString()}',
        e,
      );
    }
  }
}

