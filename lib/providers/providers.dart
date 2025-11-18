import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/core/camera_service.dart';
import '../services/core/camera_service_impl.dart';
import '../services/core/barcode_scanner_service.dart';
import '../services/core/barcode_scanner_impl.dart';
import '../data/repositories/local_storage_service.dart';
import '../data/repositories/local_storage_impl.dart'
    show LocalStorageServiceImpl;
import '../data/repositories/session_repository.dart';
import '../data/repositories/session_repository_impl.dart';
import '../data/api/audit_api_client.dart';
import 'audit/audit_session_notifier.dart';
import 'audit/audit_review_notifier.dart';

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

/// Session repository provider
final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepositoryImpl();
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
    ref.watch(sessionRepositoryProvider),
    ref.watch(auditApiClientProvider),
  );
});

/// Audit review state provider (family provider keyed by barcode and createdAt)
final auditReviewProvider = StateNotifierProvider.family<
    AuditReviewNotifier, AuditReviewState, ({String barcode, DateTime createdAt})>((ref, key) {
  return AuditReviewNotifier(
    ref.watch(sessionRepositoryProvider),
    ref.watch(auditApiClientProvider),
    key.barcode,
    key.createdAt,
  );
});

