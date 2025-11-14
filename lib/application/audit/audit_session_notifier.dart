import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import '../../domain/models/audit_session.dart';
import '../../domain/models/audit_image.dart';
import '../../domain/models/file_naming.dart';
import '../../domain/tags/tag_repository.dart';
import '../../core/camera/camera_service.dart';
import '../../core/storage/local_storage_service.dart';
import '../../core/api/audit_api_client.dart';
import '../../core/util/result.dart';

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

      // 2. Generate file name
      final fileName = FileNaming.generateFileName(
        barcode: state.session!.barcode,
        index: state.session!.imageCount,
        tags: tags,
      );

      // 3. Save image to local storage
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

      // 4. Create AuditImage
      final auditImage = AuditImage(
        localPath: savedPath,
        tags: tags,
        fileName: fileName,
      );

      // 5. Register tags in repository
      if (tags.isNotEmpty) {
        await _tagRepository.registerTags(tags);
      }

      // 6. Add image to session
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

