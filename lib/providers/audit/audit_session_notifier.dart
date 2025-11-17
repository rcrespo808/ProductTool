import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/models/audit_session.dart';
import '../../domain/models/audit_image.dart';
import '../../domain/models/file_naming.dart';
import '../../data/repositories/tag_repository.dart';
import '../../services/core/camera_service.dart';
import '../../data/repositories/local_storage_service.dart';
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
  final TagRepository _tagRepository;
  final AuditApiClient _apiClient;

  AuditSessionNotifier(
    this._cameraService,
    this._storageService,
    this._tagRepository,
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
  void startSession(String barcode) {
    if (barcode.trim().isEmpty) {
      state = state.copyWith(error: 'Barcode cannot be empty');
      return;
    }

    final session = AuditSession(barcode: barcode.trim());
    state = state.copyWith(
      session: session,
      error: null,
    );
  }

  /// Captures a photo and tags it, then saves to local storage
  Future<void> captureTaggedPhoto(List<String> tags) async {
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

      // 3. Normalize tags for file naming (will also be used for storage)
      final normalizedTags = tags
          .map((tag) => FileNaming.normalizeTag(tag))
          .where((tag) => tag.isNotEmpty)
          .toList();

      // 4. Generate file name
      final fileName = FileNaming.generateFileName(
        barcode: state.session!.barcode,
        index: state.session!.imageCount,
        tags: normalizedTags,
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

      // 6. Create AuditImage
      final auditImage = AuditImage(
        localPath: savedPath,
        tags: normalizedTags,
        fileName: fileName,
      );

      // 7. Register tags in repository
      if (normalizedTags.isNotEmpty) {
        final tagResult = await _tagRepository.registerTags(normalizedTags);
        // Log error if tag registration fails, but don't fail photo capture
        // Tags are saved in memory and will be lost on restart, but photo is more important
        if (tagResult.isFailure) {
          // Could log to analytics/crashlytics in production
          // For now, silently continue - photo capture succeeded
        }
      }

      // 8. Add image to session
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

  /// Clears the current session
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

