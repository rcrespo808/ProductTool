/// Human review status for an image
enum ReviewStatus {
  /// Not yet reviewed by human
  unknown,

  /// Approved by reviewer
  approved,

  /// Rejected by reviewer
  rejected,
}

extension ReviewStatusExtension on ReviewStatus {
  String toJson() {
    switch (this) {
      case ReviewStatus.unknown:
        return 'unknown';
      case ReviewStatus.approved:
        return 'approved';
      case ReviewStatus.rejected:
        return 'rejected';
    }
  }

  static ReviewStatus fromJson(String json) {
    switch (json) {
      case 'unknown':
        return ReviewStatus.unknown;
      case 'approved':
        return ReviewStatus.approved;
      case 'rejected':
        return ReviewStatus.rejected;
      default:
        return ReviewStatus.unknown;
    }
  }
}

