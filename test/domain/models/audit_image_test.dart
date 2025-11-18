import 'package:flutter_test/flutter_test.dart';
import 'package:product_audit_tool/domain/models/audit_image.dart';

void main() {
  group('AuditImage', () {
    test('remoteUrl getter returns backendReference', () {
      final image = AuditImage(
        localPath: '/path/to/image.jpg',
        fileName: '1234567890__001.jpg',
        index: 1,
        createdAt: DateTime(2024, 1, 1),
        backendReference: 'https://cdn.example.com/image.jpg',
      );

      expect(image.remoteUrl, equals('https://cdn.example.com/image.jpg'));
    });

    test('remoteUrl getter returns null when backendReference is null', () {
      final image = AuditImage(
        localPath: '/path/to/image.jpg',
        fileName: '1234567890__001.jpg',
        index: 1,
        createdAt: DateTime(2024, 1, 1),
      );

      expect(image.remoteUrl, isNull);
    });

    test('toJson includes backendReference', () {
      final image = AuditImage(
        localPath: '/path/to/image.jpg',
        fileName: '1234567890__001.jpg',
        index: 1,
        createdAt: DateTime(2024, 1, 1, 12, 0),
        backendReference: 'https://cdn.example.com/image.jpg',
      );

      final json = image.toJson();

      expect(json['backendReference'], equals('https://cdn.example.com/image.jpg'));
      expect(json['localPath'], equals('/path/to/image.jpg'));
      expect(json['fileName'], equals('1234567890__001.jpg'));
      expect(json['index'], equals(1));
    });

    test('fromJson parses backendReference correctly', () {
      final json = {
        'localPath': '/path/to/image.jpg',
        'fileName': '1234567890__001.jpg',
        'index': 1,
        'createdAt': '2024-01-01T12:00:00.000',
        'processingStatus': 'unknown',
        'reviewStatus': 'unknown',
        'backendReference': 'https://cdn.example.com/image.jpg',
      };

      final image = AuditImage.fromJson(json);

      expect(image.backendReference, equals('https://cdn.example.com/image.jpg'));
      expect(image.remoteUrl, equals('https://cdn.example.com/image.jpg'));
    });

    test('fromJson handles missing backendReference (backward compatibility)', () {
      final json = {
        'localPath': '/path/to/image.jpg',
        'fileName': '1234567890__001.jpg',
        'index': 1,
        'createdAt': '2024-01-01T12:00:00.000',
      };

      final image = AuditImage.fromJson(json);

      expect(image.backendReference, isNull);
      expect(image.remoteUrl, isNull);
    });

    test('copyWith preserves remoteUrl when backendReference is updated', () {
      final image = AuditImage(
        localPath: '/path/to/image.jpg',
        fileName: '1234567890__001.jpg',
        index: 1,
        createdAt: DateTime(2024, 1, 1),
      );

      final updated = image.copyWith(
        backendReference: 'https://cdn.example.com/image.jpg',
      );

      expect(updated.remoteUrl, equals('https://cdn.example.com/image.jpg'));
    });
  });
}

