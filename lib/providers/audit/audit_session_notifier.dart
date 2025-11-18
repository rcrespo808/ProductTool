import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/models/audit_session.dart';
import '../../domain/models/audit_image.dart';
import '../../domain/models/audit_session_status.dart';
import '../../domain/models/file_naming.dart';
import '../../services/core/camera_service.dart';
import '../../data/repositories/local_storage_service.dart';
import '../../data/repositories/session_repository.dart';
import '../../data/api/audit_api_client.dart';
import '../../utils/result.dart';

/// State for the audit session
class AuditSessionState {
  final AuditSession? session;
  final bool isLoading;
  final String? error;

  const AuditSessionState({
    this.session,
    this.isLoading = false,
    this.error,
  });

  bool get hasSession => session != null;
  int get imageCount => session?.imageCount ?? 0;
  String? get barcode => session?.barcode;

  AuditSessionState copyWith({
    AuditSession? session,
    bool? isLoading,
    String? error,
  }) =>
      AuditSessionState(
        session: session ?? this.session,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
}

/// Notifier for managing audit session state
class AuditSessionNotifier extends StateNotifier<AuditSessionState> {
  final CameraService _cameraService;
  final LocalStorageService _storageService;
  final SessionRepository _sessionRepository;
  final AuditApiClient _apiClient;

  AuditSessionNotifier(
    this._cameraService,
    this._storageService,
    this._sessionRepository,
    this._apiClient,
  ) : super(const AuditSessionState());

  /// Extracts file extension from XFile
  /// Falls back to 'jpg' if extraction fails
  String _getFileExtension(XFile file) {
    final path = file.path;

    // Try to extract from path
    if (path.contains('.')) {
      final parts = path.split('.');
      if (parts.length > 1) {
        final ext = parts.last.toLowerCase();
        // Validate common image extensions
        if (['jpg', 'jpeg', 'png', 'webp', 'gif'].contains(ext)) {
          return ext == 'jpeg' ? 'jpg' : ext; // Normalize jpeg to jpg
        }
      }
    }

    // Fallback to mimeType if available
    try {
      final mimeType = file.mimeType;
      if (mimeType != null) {
        if (mimeType.contains('jpeg') || mimeType.contains('jpg')) {
          return 'jpg';
        }
        if (mimeType.contains('png')) {
          return 'png';
        }
        if (mimeType.contains('webp')) {
          return 'webp';
        }
        if (mimeType.contains('gif')) {
          return 'gif';
        }
      }
    } catch (_) {
      // If mimeType access fails, continue to default
    }

    // Default to jpg if all else fails
    return 'jpg';
  }

  /// Starts a new audit session with a barcode
  /// If there's an in-progress session, it will be auto-completed first
  void startSession(String barcode) async {
    if (barcode.trim().isEmpty) {
      state = state.copyWith(error: 'Barcode cannot be empty');
      return;
    }

    // Auto-complete existing in-progress session if any
    if (state.session != null && 
        state.session!.status == AuditSessionStatus.inProgress) {
      // Only complete if it has at least one image
      if (state.session!.imageCount > 0) {
        await _finishCurrentSession(silent: true);
      } else {
        // Clear empty session silently
        state = const AuditSessionState();
      }
    }

    // Create new session with inProgress status
    final now = DateTime.now();
    final session = AuditSession(
      barcode: barcode.trim(),
      status: AuditSessionStatus.inProgress,
      createdAt: now,
    );
    
    state = state.copyWith(
      session: session,
      error: null,
    );
  }

  /// Captures a photo and saves it to local storage with sequential naming
  Future<void> capturePhoto() async {
    if (state.session == null) {
      state = state.copyWith(error: 'No active session');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // 1. Take photo
      final photoResult = await _cameraService.takePhoto();
      if (photoResult.isFailure) {
        state = state.copyWith(
          isLoading: false,
          error: photoResult.errorMessage ?? 'Failed to capture photo',
        );
        return;
      }

      final photoFile = photoResult.valueOrNull!;
      final photoBytes = await photoFile.readAsBytes();

      // 2. Extract file extension from photo file
      final extension = _getFileExtension(photoFile);

      // 3. Calculate 1-based index (next photo index)
      final nextIndex = state.session!.imageCount + 1;

      // 4. Generate file name: {barcode}__{index}.jpg
      final fileName = FileNaming.generateFileName(
        barcode: state.session!.barcode,
        index: nextIndex,
        extension: extension,
      );

      // 5. Save image to local storage
      final saveResult = await _storageService.saveImageBytes(
        photoBytes,
        fileName: fileName,
      );

      if (saveResult.isFailure) {
        state = state.copyWith(
          isLoading: false,
          error: saveResult.errorMessage ?? 'Failed to save image',
        );
        return;
      }

      final savedPath = saveResult.valueOrNull!;
      final now = DateTime.now();

      // 6. Create AuditImage with 1-based index and timestamp
      final auditImage = AuditImage(
        localPath: savedPath,
        fileName: fileName,
        index: nextIndex,
        createdAt: now,
      );

      // 7. Add image to session
      final updatedSession = state.session!.addImage(auditImage);
      state = state.copyWith(
        session: updatedSession,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error capturing photo: ${e.toString()}',
      );
    }
  }

  /// Finishes the current session (marks as completed and persists)
  /// Returns Result for error handling
  Future<Result<void>> finishSession() async {
    if (state.session == null) {
      return const Failure('No active session');
    }

    if (state.session!.imageCount == 0) {
      return const Failure('Cannot finish session with 0 images');
    }

    return await _finishCurrentSession(silent: false);
  }

  /// Internal method to finish current session
  Future<Result<void>> _finishCurrentSession({required bool silent}) async {
    if (state.session == null) {
      return const Success(null);
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final now = DateTime.now();
      final completedSession = state.session!.copyWith(
        status: AuditSessionStatus.completed,
        completedAt: now,
      );

      // Save to repository
      final saveResult = await _sessionRepository.saveSession(completedSession);

      if (saveResult.isFailure) {
        state = state.copyWith(
          isLoading: false,
          error: silent ? null : saveResult.errorMessage ?? 'Failed to save session',
        );
        return saveResult;
      }

      // Clear in-memory session
      state = const AuditSessionState(isLoading: false);
      return const Success(null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: silent ? null : 'Error finishing session: ${e.toString()}',
      );
      return Failure(
        'Error finishing session: ${e.toString()}',
        e,
      );
    }
  }

  /// Clears the current session (does not persist)
  /// Used for canceling/abandoning a session
  void clearSession() {
    state = const AuditSessionState();
  }

  /// Uploads the current session to the backend (future use)
  Future<void> uploadSession() async {
    if (state.session == null) {
      state = state.copyWith(error: 'No session to upload');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    final result = await _apiClient.uploadSession(state.session!);

    if (result.isFailure) {
      state = state.copyWith(
        isLoading: false,
        error: result.errorMessage ?? 'Failed to upload session',
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }
}

