import 'package:equatable/equatable.dart';
import 'audit_image.dart';

/// Represents a complete audit session for a product
class AuditSession with EquatableMixin {
  final String barcode;
  final List<AuditImage> images;

  const AuditSession({
    required this.barcode,
    this.images = const [],
  });

  /// Creates a copy with updated fields
  AuditSession copyWith({
    String? barcode,
    List<AuditImage>? images,
  }) =>
      AuditSession(
        barcode: barcode ?? this.barcode,
        images: images ?? this.images,
      );

  /// Adds an image to the session
  AuditSession addImage(AuditImage image) => copyWith(
        images: [...images, image],
      );

  int get imageCount => images.length;

  @override
  List<Object> get props => [barcode, images];

  Map<String, dynamic> toJson() => {
        'barcode': barcode,
        'images': images.map((img) => img.toJson()).toList(),
      };

  factory AuditSession.fromJson(Map<String, dynamic> json) => AuditSession(
        barcode: json['barcode'] as String,
        images: (json['images'] as List)
            .map((img) => AuditImage.fromJson(img as Map<String, dynamic>))
            .toList(),
      );
}

