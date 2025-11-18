import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/audit_session.dart';
import '../../domain/models/audit_image.dart';
import '../../domain/models/processing_status.dart';
import '../../domain/models/review_status.dart';
import '../../data/repositories/session_repository.dart';
import '../../data/api/audit_api_client.dart';
import '../../data/api/product_image_status.dart';
import '../../utils/result.dart';
import '../../utils/backend_image_mapper.dart';

/// State for audit review
class AuditReviewState {
  final AuditSession? session;
  final bool isLoading;
  final bool isCheckingBackend;
  final String? error;

  const AuditReviewState({
    this.session,
    this.isLoading = false,
    this.isCheckingBackend = false,
    this.error,
  });

  bool get hasSession => session != null;

  AuditReviewState copyWith({
    AuditSession? session,
    bool? isLoading,
    bool? isCheckingBackend,
    String? error,
  }) =>
      AuditReviewState(
        session: session ?? this.session,
        isLoading: isLoading ?? this.isLoading,
        isCheckingBackend: isCheckingBackend ?? this.isCheckingBackend,
        error: error ?? this.error,
      );
}

/// Notifier for managing audit review state
class AuditReviewNotifier extends StateNotifier<AuditReviewState> {
  final SessionRepository _sessionRepository;
  final AuditApiClient _apiClient;
  final String _barcode;
  final DateTime _createdAt;

  AuditReviewNotifier(
    this._sessionRepository,
    this._apiClient,
    this._barcode,
    this._createdAt,
  ) : super(const AuditReviewState()) {
    loadSession();
  }

  /// Loads the session from repository
  Future<void> loadSession() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _sessionRepository.getAllSessions();
    if (result.isFailure) {
      state = state.copyWith(
        isLoading: false,
        error: result.errorMessage ?? 'Failed to load session',
      );
      return;
    }

    final sessions = result.valueOrNull ?? [];
    final session = sessions.firstWhere(
      (s) => s.barcode == _barcode && s.createdAt == _createdAt,
      orElse: () => sessions.firstWhere(
        (s) => s.barcode == _barcode,
        orElse: () => throw StateError('Session not found'),
      ),
    );

    state = state.copyWith(
      session: session,
      isLoading: false,
    );

    // Automatically check backend status when session is loaded
    await checkBackendStatus();
  }

  /// Checks backend status for all images in the session
  Future<void> checkBackendStatus() async {
    if (state.session == null) {
      return;
    }

    state = state.copyWith(isCheckingBackend: true, error: null);

    try {
      final result = await _apiClient.getProductImageStatus(state.session!.barcode);
      if (result.isFailure) {
        state = state.copyWith(
          isCheckingBackend: false,
          error: result.errorMessage ?? 'Failed to check backend status',
        );
        return;
      }

      final imageStatus = result.valueOrNull!;
      await _updateProcessingStatuses(imageStatus);
    } catch (e) {
      state = state.copyWith(
        isCheckingBackend: false,
        error: 'Error checking backend status: ${e.toString()}',
      );
    }
  }

  /// Updates processing statuses based on backend response
  Future<void> _updateProcessingStatuses(ProductImageStatus imageStatus) async {
    if (state.session == null) {
      return;
    }

    // Map backend images to local indices
    final backendMapping = BackendImageMapper.mapBackendImagesToLocalIndices(
      imageStatus.imagesPathList,
    );

    // Update images with processing status
    final updatedImages = state.session!.images.map((image) {
      final backendUrl = backendMapping[image.index];
      final isFailed = backendUrl != null &&
          BackendImageMapper.isFailedImage(backendUrl, imageStatus.failedImages);

      ProcessingStatus newStatus;
      String? backendRef;

      if (backendUrl != null && !isFailed) {
        newStatus = ProcessingStatus.processedOk;
        backendRef = backendUrl;
      } else if (isFailed) {
        newStatus = ProcessingStatus.processedError;
      } else {
        // Image not found in backend response
        // If it was previously unknown, keep it as unknown
        // Otherwise, mark as pending if backend has processed some images
        if (imageStatus.totalSuccessful > 0) {
          newStatus = ProcessingStatus.processedError; // Missing from backend
        } else {
          newStatus = ProcessingStatus.pending; // Backend hasn't processed yet
        }
      }

      return image.copyWith(
        processingStatus: newStatus,
        backendReference: backendRef ?? image.backendReference,
      );
    }).toList();

    final updatedSession = state.session!.copyWith(images: updatedImages);
    state = state.copyWith(
      session: updatedSession,
      isCheckingBackend: false,
    );

    // Persist updated session
    await _sessionRepository.saveSession(updatedSession);
  }

  /// Approves an image by index
  Future<void> approveImage(int index) async {
    if (state.session == null) {
      return;
    }

    final updatedImages = state.session!.images.map((image) {
      if (image.index == index) {
        return image.copyWith(reviewStatus: ReviewStatus.approved);
      }
      return image;
    }).toList();

    await _updateSessionImages(updatedImages);
  }

  /// Rejects an image by index
  Future<void> rejectImage(int index) async {
    if (state.session == null) {
      return;
    }

    final updatedImages = state.session!.images.map((image) {
      if (image.index == index) {
        return image.copyWith(reviewStatus: ReviewStatus.rejected);
      }
      return image;
    }).toList();

    await _updateSessionImages(updatedImages);
  }

  /// Approves all images that were processed successfully by backend
  Future<void> approveAllProcessed() async {
    if (state.session == null) {
      return;
    }

    final updatedImages = state.session!.images.map((image) {
      if (image.processingStatus == ProcessingStatus.processedOk &&
          image.reviewStatus != ReviewStatus.approved) {
        return image.copyWith(reviewStatus: ReviewStatus.approved);
      }
      return image;
    }).toList();

    await _updateSessionImages(updatedImages);
  }

  /// Updates session images and persists
  Future<void> _updateSessionImages(List<AuditImage> updatedImages) async {
    if (state.session == null) {
      return;
    }

    final updatedSession = state.session!.copyWith(images: updatedImages);
    state = state.copyWith(session: updatedSession);

    // Persist updated session
    final result = await _sessionRepository.saveSession(updatedSession);
    if (result.isFailure) {
      state = state.copyWith(
        error: result.errorMessage ?? 'Failed to save review status',
      );
    }
  }
}

