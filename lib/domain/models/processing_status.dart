/// Status of backend processing for an image
enum ProcessingStatus {
  /// Status not yet checked
  unknown,

  /// Waiting for backend processing
  pending,

  /// Backend successfully processed the image
  processedOk,

  /// Backend failed to process the image or image is missing
  processedError,
}

extension ProcessingStatusExtension on ProcessingStatus {
  String toJson() {
    switch (this) {
      case ProcessingStatus.unknown:
        return 'unknown';
      case ProcessingStatus.pending:
        return 'pending';
      case ProcessingStatus.processedOk:
        return 'processedOk';
      case ProcessingStatus.processedError:
        return 'processedError';
    }
  }

  static ProcessingStatus fromJson(String json) {
    switch (json) {
      case 'unknown':
        return ProcessingStatus.unknown;
      case 'pending':
        return ProcessingStatus.pending;
      case 'processedOk':
        return ProcessingStatus.processedOk;
      case 'processedError':
        return ProcessingStatus.processedError;
      default:
        return ProcessingStatus.unknown;
    }
  }
}

