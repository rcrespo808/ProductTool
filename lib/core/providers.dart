import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/tags/tag_repository.dart';
import 'camera/camera_service.dart';
import 'camera/camera_service_impl.dart';
import 'barcode/barcode_scanner_service.dart';
import 'barcode/barcode_scanner_impl.dart';
import 'storage/local_storage_service.dart';
import 'storage/local_storage_impl.dart' show LocalStorageServiceImpl;
import 'api/audit_api_client.dart';
import '../application/audit/audit_session_notifier.dart';
import '../application/tags/tag_suggestions_notifier.dart';

/// Camera service provider
final cameraServiceProvider = Provider<CameraService>((ref) {
  return CameraServiceImpl();
});

/// Barcode scanner service provider
final barcodeScannerProvider = Provider<BarcodeScannerService>((ref) {
  return BarcodeScannerImpl();
});

/// Local storage service provider
final localStorageProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageServiceImpl();
});

/// Tag repository provider
final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final repository = TagRepositoryImpl();
  repository.load(); // Load asynchronously on first access
  return repository;
});

/// Audit API client provider
final auditApiClientProvider = Provider<AuditApiClient>((ref) {
  return FakeAuditApiClient();
});

/// Audit session state provider
final auditSessionProvider =
    StateNotifierProvider<AuditSessionNotifier, AuditSessionState>((ref) {
  return AuditSessionNotifier(
    ref.watch(cameraServiceProvider),
    ref.watch(localStorageProvider),
    ref.watch(tagRepositoryProvider),
    ref.watch(auditApiClientProvider),
  );
});

/// Tag suggestions state provider
final tagSuggestionsProvider =
    StateNotifierProvider<TagSuggestionsNotifier, TagSuggestionsState>((ref) {
  return TagSuggestionsNotifier(ref.watch(tagRepositoryProvider));
});

