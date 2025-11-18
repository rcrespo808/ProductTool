import 'package:equatable/equatable.dart';
import 'processing_status.dart';
import 'review_status.dart';

/// Represents a single captured image in an audit session
class AuditImage with EquatableMixin {
  final String localPath;
  final String fileName;
  final int index; // 1-based index used in filename (001, 002, ...)
  final DateTime createdAt;
  final ProcessingStatus processingStatus;
  final ReviewStatus reviewStatus;
  final String? backendReference;

  /// The remote URL of the backend-processed image (CDN path)
  /// This is the final processed image after background removal and other edits
  /// Returns null if the image hasn't been processed by the backend yet
  String? get remoteUrl => backendReference;

  const AuditImage({
    required this.localPath,
    required this.fileName,
    required this.index,
    required this.createdAt,
    this.processingStatus = ProcessingStatus.unknown,
    this.reviewStatus = ReviewStatus.unknown,
    this.backendReference,
  });

  /// Creates a copy with updated fields
  AuditImage copyWith({
    String? localPath,
    String? fileName,
    int? index,
    DateTime? createdAt,
    ProcessingStatus? processingStatus,
    ReviewStatus? reviewStatus,
    String? backendReference,
  }) =>
      AuditImage(
        localPath: localPath ?? this.localPath,
        fileName: fileName ?? this.fileName,
        index: index ?? this.index,
        createdAt: createdAt ?? this.createdAt,
        processingStatus: processingStatus ?? this.processingStatus,
        reviewStatus: reviewStatus ?? this.reviewStatus,
        backendReference: backendReference ?? this.backendReference,
      );

  @override
  List<Object?> get props => [
        localPath,
        fileName,
        index,
        createdAt,
        processingStatus,
        reviewStatus,
        backendReference,
      ];

  Map<String, dynamic> toJson() => {
        'localPath': localPath,
        'fileName': fileName,
        'index': index,
        'createdAt': createdAt.toIso8601String(),
        'processingStatus': processingStatus.toJson(),
        'reviewStatus': reviewStatus.toJson(),
        'backendReference': backendReference,
      };

  factory AuditImage.fromJson(Map<String, dynamic> json) => AuditImage(
        localPath: json['localPath'] as String,
        fileName: json['fileName'] as String,
        index: json['index'] as int,
        createdAt: DateTime.parse(json['createdAt'] as String),
        processingStatus: json['processingStatus'] != null
            ? ProcessingStatusExtension.fromJson(
                json['processingStatus'] as String)
            : ProcessingStatus.unknown,
        reviewStatus: json['reviewStatus'] != null
            ? ReviewStatusExtension.fromJson(json['reviewStatus'] as String)
            : ReviewStatus.unknown,
        backendReference: json['backendReference'] as String?,
      );
}
