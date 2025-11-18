import 'package:flutter_test/flutter_test.dart';
import 'package:product_audit_tool/data/api/audit_api_client.dart';
import 'package:product_audit_tool/data/api/product_image_status.dart';
import 'package:product_audit_tool/data/repositories/session_repository.dart';
import 'package:product_audit_tool/domain/models/audit_session.dart';
import 'package:product_audit_tool/domain/models/audit_image.dart';
import 'package:product_audit_tool/domain/models/audit_session_status.dart';
import 'package:product_audit_tool/domain/models/processing_status.dart';
import 'package:product_audit_tool/providers/audit/audit_review_notifier.dart';
import 'package:product_audit_tool/utils/result.dart';

class MockSessionRepository implements SessionRepository {
  final List<AuditSession> _sessions = [];

  @override
  Future<Result<void>> saveSession(AuditSession session) async {
    _sessions.removeWhere((s) =>
        s.barcode == session.barcode && s.createdAt == session.createdAt);
    _sessions.add(session);
    return const Success(null);
  }

  @override
  Future<Result<List<AuditSession>>> getAllSessions() async {
    return Success(_sessions);
  }

  @override
  Future<Result<List<AuditSession>>> getCompletedSessions() async {
    return Success(_sessions
        .where((s) => s.status == AuditSessionStatus.completed)
        .toList());
  }

  @override
  Future<Result<void>> deleteSession(String barcode, DateTime createdAt) async {
    _sessions.removeWhere(
        (s) => s.barcode == barcode && s.createdAt == createdAt);
    return const Success(null);
  }
}

class MockAuditApiClient implements AuditApiClient {
  ProductImageStatus? _mockStatus;

  void setMockStatus(ProductImageStatus status) {
    _mockStatus = status;
  }

  @override
  Future<Result<void>> uploadSession(AuditSession session) async {
    return const Success(null);
  }

  @override
  Future<Result<ProductImageStatus>> getProductImageStatus(String ean) async {
    if (_mockStatus != null) {
      return Success(_mockStatus!);
    }
    return const Failure('No mock status set');
  }
}

void main() {
  group('AuditReviewNotifier', () {
    late MockSessionRepository repository;
    late MockAuditApiClient apiClient;

    setUp(() {
      repository = MockSessionRepository();
      apiClient = MockAuditApiClient();
    });

    test('stores remote URLs in backendReference when processing status is updated',
        () async {
      final createdAt = DateTime(2024, 1, 1);
      final session = AuditSession(
        barcode: '1234567890123',
        images: [
          AuditImage(
            localPath: '/path/to/image1.jpg',
            fileName: '1234567890123__001.jpg',
            index: 1,
            createdAt: createdAt,
          ),
          AuditImage(
            localPath: '/path/to/image2.jpg',
            fileName: '1234567890123__002.jpg',
            index: 2,
            createdAt: createdAt,
          ),
        ],
        status: AuditSessionStatus.completed,
        createdAt: createdAt,
        completedAt: createdAt,
      );

      await repository.saveSession(session);

      final imageStatus = ProductImageStatus(
        codeEAN: '1234567890123',
        imagesPathList: [
          'https://cdn.example.com/products/1234567890123-01.jpg',
          'https://cdn.example.com/products/1234567890123-02.jpg',
        ],
        failedImages: [],
        totalRequested: 2,
        totalSuccessful: 2,
        totalFailed: 0,
      );

      apiClient.setMockStatus(imageStatus);

      // Create notifier to trigger backend status check
      // ignore: unused_local_variable
      final notifier = AuditReviewNotifier(
        repository,
        apiClient,
        '1234567890123',
        createdAt,
      );

      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 200));

      final updatedSession = await repository.getAllSessions();
      expect(updatedSession.isSuccess, isTrue);

      final sessions = updatedSession.valueOrNull!;
      expect(sessions.length, equals(1));

      final updated = sessions.first;
      expect(updated.images.length, equals(2));

      // Check that remote URLs are stored
      expect(updated.images[0].remoteUrl,
          equals('https://cdn.example.com/products/1234567890123-01.jpg'));
      expect(updated.images[1].remoteUrl,
          equals('https://cdn.example.com/products/1234567890123-02.jpg'));

      // Check processing status
      expect(updated.images[0].processingStatus,
          equals(ProcessingStatus.processedOk));
      expect(updated.images[1].processingStatus,
          equals(ProcessingStatus.processedOk));
    });

    test('maps backend URLs to correct image indices', () async {
      final createdAt = DateTime(2024, 1, 1);
      final session = AuditSession(
        barcode: '1234567890123',
        images: [
          AuditImage(
            localPath: '/path/to/image1.jpg',
            fileName: '1234567890123__001.jpg',
            index: 1,
            createdAt: createdAt,
          ),
          AuditImage(
            localPath: '/path/to/image2.jpg',
            fileName: '1234567890123__002.jpg',
            index: 2,
            createdAt: createdAt,
          ),
          AuditImage(
            localPath: '/path/to/image3.jpg',
            fileName: '1234567890123__003.jpg',
            index: 3,
            createdAt: createdAt,
          ),
        ],
        status: AuditSessionStatus.completed,
        createdAt: createdAt,
        completedAt: createdAt,
      );

      await repository.saveSession(session);

      // Backend returns images for positions 1 and 3, but not 2
      final imageStatus = ProductImageStatus(
        codeEAN: '1234567890123',
        imagesPathList: [
          'https://cdn.example.com/products/1234567890123-01.jpg',
          'https://cdn.example.com/products/1234567890123-03.jpg',
        ],
        failedImages: [],
        totalRequested: 3,
        totalSuccessful: 2,
        totalFailed: 0,
      );

      apiClient.setMockStatus(imageStatus);

      // Create notifier to trigger backend status check
      // ignore: unused_local_variable
      final notifier = AuditReviewNotifier(
        repository,
        apiClient,
        '1234567890123',
        createdAt,
      );

      await Future.delayed(const Duration(milliseconds: 200));

      final updatedSession = await repository.getAllSessions();
      final sessions = updatedSession.valueOrNull!;
      final updated = sessions.first;

      // Image 1 should have remote URL
      expect(updated.images[0].remoteUrl,
          equals('https://cdn.example.com/products/1234567890123-01.jpg'));
      expect(updated.images[0].processingStatus,
          equals(ProcessingStatus.processedOk));

      // Image 2 should not have remote URL (missing from backend)
      expect(updated.images[1].remoteUrl, isNull);
      expect(updated.images[1].processingStatus,
          equals(ProcessingStatus.processedError));

      // Image 3 should have remote URL
      expect(updated.images[2].remoteUrl,
          equals('https://cdn.example.com/products/1234567890123-03.jpg'));
      expect(updated.images[2].processingStatus,
          equals(ProcessingStatus.processedOk));
    });
  });
}

