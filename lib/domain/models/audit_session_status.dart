/// Status of an audit session
enum AuditSessionStatus {
  /// Session is in progress (photos can be captured)
  inProgress,

  /// Session is completed (finished and persisted)
  completed;

  /// Converts status to JSON string
  String toJson() => name;

  /// Creates status from JSON string
  factory AuditSessionStatus.fromJson(String json) {
    return AuditSessionStatus.values.firstWhere(
      (status) => status.name == json,
      orElse: () => AuditSessionStatus.inProgress,
    );
  }
}

