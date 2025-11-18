/// DTO representing the backend status of product images
class ProductImageStatus {
  final String codeEAN;
  final List<String> imagesPathList;
  final List<String> failedImages;
  final int totalRequested;
  final int totalSuccessful;
  final int totalFailed;

  const ProductImageStatus({
    required this.codeEAN,
    required this.imagesPathList,
    required this.failedImages,
    required this.totalRequested,
    required this.totalSuccessful,
    required this.totalFailed,
  });

  Map<String, dynamic> toJson() => {
        'codeEAN': codeEAN,
        'imagesPathList': imagesPathList,
        'failedImages': failedImages,
        'totalRequested': totalRequested,
        'totalSuccessful': totalSuccessful,
        'totalFailed': totalFailed,
      };

  factory ProductImageStatus.fromJson(Map<String, dynamic> json) =>
      ProductImageStatus(
        codeEAN: json['codeEAN'] as String? ?? json['product']?['codeEAN'] as String? ?? '',
        imagesPathList: (json['imagesPathList'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            (json['product']?['imagesPathList'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        failedImages: (json['failedImages'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        totalRequested: json['totalRequested'] as int? ?? 0,
        totalSuccessful: json['totalSuccessful'] as int? ?? 0,
        totalFailed: json['totalFailed'] as int? ?? 0,
      );
}

