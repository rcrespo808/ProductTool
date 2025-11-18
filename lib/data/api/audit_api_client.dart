import '../../domain/models/audit_session.dart';
import '../../utils/result.dart';
import 'product_image_status.dart';

/// Abstract interface for audit API client
abstract class AuditApiClient {
  /// Uploads an audit session to the backend
  Future<Result<void>> uploadSession(AuditSession session);

  /// Gets the current image status for a product by EAN code
  /// Returns imagesPathList and failedImages from backend
  Future<Result<ProductImageStatus>> getProductImageStatus(String ean);
}

/// Fake implementation that does nothing (for development/testing)
class FakeAuditApiClient implements AuditApiClient {
  @override
  Future<Result<void>> uploadSession(AuditSession session) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));

    // In a real implementation, this would:
    // 1. Serialize session to JSON
    // 2. Send HTTP POST request
    // 3. Handle response/errors

    // For now, just log and return success
    print(
        'FakeAuditApiClient: Would upload session for barcode ${session.barcode} with ${session.imageCount} images');

    return const Success(null);
  }

  @override
  Future<Result<ProductImageStatus>> getProductImageStatus(String ean) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 150));

    // In a real implementation, this would:
    // 1. Send HTTP GET request to /product/getImagesByEAN?codeEAN={ean}
    // 2. Parse response JSON
    // 3. Return ProductImageStatus DTO

    // For now, return mock data simulating some processed images
    print('FakeAuditApiClient: Would get image status for EAN $ean');

    // Mock: assume some images were processed successfully
    // Backend format: {EAN}-{position}.{ext}
    final mockImages = <String>[];
    final mockFailed = <String>[];

    // Simulate 3 images processed (positions 1, 2, 3)
    for (int i = 1; i <= 3; i++) {
      mockImages.add(
          'https://icnortecdn.nyc3.cdn.digitaloceanspaces.com/development/store/products/$ean-${i.toString().padLeft(2, '0')}.jpg');
    }

    final status = ProductImageStatus(
      codeEAN: ean,
      imagesPathList: mockImages,
      failedImages: mockFailed,
      totalRequested: 3,
      totalSuccessful: 3,
      totalFailed: 0,
    );

    return Success(status);
  }
}

