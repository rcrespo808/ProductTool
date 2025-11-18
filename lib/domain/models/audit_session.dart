import 'package:equatable/equatable.dart';
import 'audit_image.dart';
import 'audit_session_status.dart';
import 'audit_review_summary.dart';
import 'review_status.dart';

/// Represents a complete audit session for a product
class AuditSession with EquatableMixin {
  final String barcode;
  final List<AuditImage> images;
  final AuditSessionStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;

  const AuditSession({
    required this.barcode,
    this.images = const [],
    required this.status,
    required this.createdAt,
    this.completedAt,
  });

  /// Creates a copy with updated fields
  AuditSession copyWith({
    String? barcode,
    List<AuditImage>? images,
    AuditSessionStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
  }) =>
      AuditSession(
        barcode: barcode ?? this.barcode,
        images: images ?? this.images,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        completedAt: completedAt ?? this.completedAt,
      );

  /// Adds an image to the session
  AuditSession addImage(AuditImage image) => copyWith(
        images: [...images, image],
      );

  int get imageCount => images.length;

  /// Computes the overall review summary from image review statuses
  AuditReviewSummary get reviewSummary {
    if (images.isEmpty) {
      return AuditReviewSummary.unknown;
    }

    final approvedCount = images.where((img) => img.reviewStatus == ReviewStatus.approved).length;
    final rejectedCount = images.where((img) => img.reviewStatus == ReviewStatus.rejected).length;
    final unknownCount = images.where((img) => img.reviewStatus == ReviewStatus.unknown).length;

    if (approvedCount == images.length) {
      return AuditReviewSummary.fullyApproved;
    } else if (rejectedCount == images.length) {
      return AuditReviewSummary.fullyRejected;
    } else if (unknownCount == images.length) {
      return AuditReviewSummary.unknown;
    } else {
      return AuditReviewSummary.partiallyApproved;
    }
  }

  @override
  List<Object?> get props => [barcode, images, status, createdAt, completedAt];

  Map<String, dynamic> toJson() => {
        'barcode': barcode,
        'images': images.map((img) => img.toJson()).toList(),
        'status': status.toJson(),
        'createdAt': createdAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
      };

  factory AuditSession.fromJson(Map<String, dynamic> json) => AuditSession(
        barcode: json['barcode'] as String,
        images: (json['images'] as List)
            .map((img) => AuditImage.fromJson(img as Map<String, dynamic>))
            .toList(),
        status: AuditSessionStatus.fromJson(json['status'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'] as String)
            : null,
      );
}
