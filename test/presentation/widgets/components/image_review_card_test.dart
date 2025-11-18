import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_audit_tool/domain/models/audit_image.dart';
import 'package:product_audit_tool/domain/models/processing_status.dart';
import 'package:product_audit_tool/presentation/widgets/components/image_review_card.dart';

void main() {
  group('ImageReviewCard', () {
    testWidgets('displays network image when remoteUrl is available', (tester) async {
      final image = AuditImage(
        localPath: '/path/to/image.jpg',
        fileName: '1234567890__001.jpg',
        index: 1,
        createdAt: DateTime(2024, 1, 1),
        backendReference: 'https://cdn.example.com/image.jpg',
        processingStatus: ProcessingStatus.processedOk,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageReviewCard(
              image: image,
              onApprove: () {},
              onReject: () {},
            ),
          ),
        ),
      );

      // Should find Image.network widget
      expect(find.byType(Image), findsOneWidget);
      
      // Should find the "Processed" badge
      expect(find.text('Processed'), findsOneWidget);
    });

    testWidgets('falls back to local image when remoteUrl is null', (tester) async {
      final image = AuditImage(
        localPath: '/path/to/image.jpg',
        fileName: '1234567890__001.jpg',
        index: 1,
        createdAt: DateTime(2024, 1, 1),
        backendReference: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageReviewCard(
              image: image,
              onApprove: () {},
              onReject: () {},
            ),
          ),
        ),
      );

      // Should not find "Processed" badge
      expect(find.text('Processed'), findsNothing);
    });

    testWidgets('falls back to local image when remoteUrl is invalid', (tester) async {
      final image = AuditImage(
        localPath: '/path/to/image.jpg',
        fileName: '1234567890__001.jpg',
        index: 1,
        createdAt: DateTime(2024, 1, 1),
        backendReference: 'not-a-valid-url',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageReviewCard(
              image: image,
              onApprove: () {},
              onReject: () {},
            ),
          ),
        ),
      );

      // Should not find "Processed" badge for invalid URL
      expect(find.text('Processed'), findsNothing);
    });

    testWidgets('displays image index and capture time', (tester) async {
      final image = AuditImage(
        localPath: '/path/to/image.jpg',
        fileName: '1234567890__001.jpg',
        index: 1,
        createdAt: DateTime(2024, 1, 1, 14, 30),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageReviewCard(
              image: image,
              onApprove: () {},
              onReject: () {},
            ),
          ),
        ),
      );

      expect(find.text('#1'), findsOneWidget);
      expect(find.textContaining('14:30'), findsOneWidget);
    });

    testWidgets('displays approve and reject buttons', (tester) async {
      final image = AuditImage(
        localPath: '/path/to/image.jpg',
        fileName: '1234567890__001.jpg',
        index: 1,
        createdAt: DateTime(2024, 1, 1),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageReviewCard(
              image: image,
              onApprove: () {},
              onReject: () {},
            ),
          ),
        ),
      );

      expect(find.text('Approve'), findsOneWidget);
      expect(find.text('Reject'), findsOneWidget);
    });
  });
}

