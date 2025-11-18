/// Overall review summary status for an audit session
enum AuditReviewSummary {
  /// No reviews yet
  unknown,

  /// All images approved
  fullyApproved,

  /// Mix of approved/rejected/unknown
  partiallyApproved,

  /// All images rejected
  fullyRejected,
}

extension AuditReviewSummaryExtension on AuditReviewSummary {
  String toJson() {
    switch (this) {
      case AuditReviewSummary.unknown:
        return 'unknown';
      case AuditReviewSummary.fullyApproved:
        return 'fullyApproved';
      case AuditReviewSummary.partiallyApproved:
        return 'partiallyApproved';
      case AuditReviewSummary.fullyRejected:
        return 'fullyRejected';
    }
  }

  static AuditReviewSummary fromJson(String json) {
    switch (json) {
      case 'unknown':
        return AuditReviewSummary.unknown;
      case 'fullyApproved':
        return AuditReviewSummary.fullyApproved;
      case 'partiallyApproved':
        return AuditReviewSummary.partiallyApproved;
      case 'fullyRejected':
        return AuditReviewSummary.fullyRejected;
      default:
        return AuditReviewSummary.unknown;
    }
  }
}

