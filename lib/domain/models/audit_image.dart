import 'package:equatable/equatable.dart';

/// Represents a single captured image in an audit session
class AuditImage with EquatableMixin {
  final String localPath;
  final List<String> tags;
  final String fileName;

  const AuditImage({
    required this.localPath,
    required this.tags,
    required this.fileName,
  });

  @override
  List<Object> get props => [localPath, tags, fileName];

  Map<String, dynamic> toJson() => {
        'localPath': localPath,
        'tags': tags,
        'fileName': fileName,
      };

  factory AuditImage.fromJson(Map<String, dynamic> json) => AuditImage(
        localPath: json['localPath'] as String,
        tags: (json['tags'] as List).cast<String>(),
        fileName: json['fileName'] as String,
      );
}

