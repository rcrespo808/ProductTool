# Technical Structure & Architecture

This document describes the code layout, providers, and abstractions.

---

## Folder Structure

```
lib/
├── main.dart
│
├── core/
│   ├── camera/
│   │   ├── camera_service.dart
│   │   └── camera_service_impl.dart
│   ├── barcode/
│   │   ├── barcode_scanner_service.dart
│   │   └── barcode_scanner_impl.dart
│   ├── storage/
│   │   ├── local_storage_service.dart
│   │   └── local_storage_impl.dart
│   ├── api/
│   │   └── audit_api_client.dart
│   └── util/
│       └── result.dart
│
├── domain/
│   ├── models/
│   │   ├── audit_session.dart
│   │   └── audit_image.dart
│   └── tags/
│       ├── tag_trie.dart
│       └── tag_repository.dart
│
├── application/
│   ├── audit/
│   │   └── audit_session_notifier.dart
│   └── tags/
│       └── tag_suggestions_notifier.dart
│
└── presentation/
    ├── screens/
    │   ├── home_screen.dart
    │   ├── barcode_scan_screen.dart
    │   └── tag_capture_screen.dart
    └── widgets/
        ├── tag_chip_cloud.dart
        └── tag_autocomplete_input.dart
```

---

## Providers

### Camera service
```dart
final cameraServiceProvider = Provider<CameraService>((ref) {
  return CameraServiceImpl();
});
```

### Barcode scanner
```dart
final barcodeScannerProvider = Provider<BarcodeScannerService>((ref) {
  return BarcodeScannerImpl();
});
```

### Local storage
```dart
final localStorageProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageServiceImpl();
});
```

### Tag repository
```dart
final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final repo = TagRepositoryImpl();
  repo.load();
  return repo;
});
```

### Audit session logic
```dart
final auditSessionProvider =
  StateNotifierProvider<AuditSessionNotifier, AuditSessionState>((ref) {
    return AuditSessionNotifier(
      ref.watch(cameraServiceProvider),
      ref.watch(localStorageProvider),
      ref.watch(tagRepositoryProvider),
    );
});
```

### Tag suggestions
```dart
final tagSuggestionsProvider =
  StateNotifierProvider<TagSuggestionsNotifier, TagSuggestionsState>((ref) {
    return TagSuggestionsNotifier(ref.watch(tagRepositoryProvider));
});
```

---

## Key Abstractions

### CameraService
```dart
Future<XFile?> takePhoto()
```

### BarcodeScannerService
```dart
Stream<String> startBarcodeStream()
```

### LocalStorageService
```dart
Future<String> saveImageBytes(Uint8List bytes, {required String fileName})
```

### AuditApiClient
```dart
Future<void> uploadSession(AuditSession session)
```

---

## Domain Models

### AuditSession
```dart
class AuditSession {
  String barcode;
  List<AuditImage> images;
}
```

### AuditImage
```dart
class AuditImage {
  String localPath;
  List<String> tags;
  String fileName;
}
```

### Tag Trie
- Insert tags
- Suggest prefix matches
- Usage count for relevance
- JSON serialization
- Backed by local persistence (SharedPreferences)