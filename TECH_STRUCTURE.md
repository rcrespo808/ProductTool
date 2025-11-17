# Technical Structure & Architecture

This document describes the code layout, providers, and abstractions.

---

## Folder Structure

```
lib/
├── main.dart
│
├── presentation/              # Flutter UI layer
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── barcode_scan_screen.dart
│   │   ├── barcode_scan_screen_mobile.dart
│   │   ├── barcode_scan_screen_mobile_wrapper.dart
│   │   ├── barcode_scan_screen_web.dart
│   │   └── tag_capture_screen.dart
│   └── widgets/
│       ├── components/        # Reusable UI components
│       │   ├── info_chip.dart
│       │   ├── session_info_bar.dart
│       │   ├── selected_tags_section.dart
│       │   └── tag_action_buttons.dart
│       ├── tag_chip_cloud.dart
│       └── tag_autocomplete_input.dart
│
├── providers/                 # Riverpod state management
│   ├── audit/
│   │   └── audit_session_notifier.dart
│   ├── tags/
│   │   └── tag_suggestions_notifier.dart
│   └── providers.dart         # Provider definitions
│
├── domain/                    # Pure business logic (no Flutter)
│   ├── models/
│   │   ├── audit_image.dart
│   │   ├── audit_session.dart
│   │   └── file_naming.dart
│   └── tags/
│       └── tag_trie.dart
│
├── data/                      # Data layer (repositories & API clients, no Flutter)
│   ├── api/
│   │   └── audit_api_client.dart
│   └── repositories/
│       ├── tag_repository.dart
│       ├── local_storage_service.dart
│       ├── local_storage_impl_mobile.dart
│       ├── local_storage_impl_web.dart
│       ├── local_storage_impl_stub.dart
│       └── local_storage_impl.dart
│
├── services/                  # Cross-cutting services (no Flutter)
│   └── core/
│       ├── camera_service.dart
│       ├── camera_service_impl.dart
│       ├── barcode_scanner_service.dart
│       └── barcode_scanner_impl.dart
│
└── utils/                     # Pure utilities
    └── result.dart            # Result<T> error handling pattern
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

**Note:** Provider definitions are located in `lib/providers/providers.dart`.

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

---

## Architectural Principles

### Dependency Direction
- `presentation → providers → data → api`
- `presentation → domain` (types only)
- **Domain layer must not import Flutter** - Pure business logic only
- **Data layer must not import Flutter** - Platform-agnostic repositories/API clients
- All Riverpod providers live in `providers/` directory

### Layer Separation
- **Presentation**: Flutter UI widgets and screens
- **Providers**: Riverpod state management (Notifier/AsyncNotifier)
- **Domain**: Pure business logic models and data structures (no dependencies on Flutter)
- **Data**: Repositories and API clients (no Flutter dependencies)
- **Services**: Cross-cutting services (camera, barcode scanning)
- **Utils**: Pure utility functions

### File Size Guidelines
- Screens (pages): ≤300 lines
- Widgets: ≤200 lines
- Providers: ≤250 lines
- Long files should be split into smaller components

---

## Structure Updates (2025-01-27)

**Refactoring completed:** All files restructured to match intended architecture.

### Key Changes
- Moved `core/util/` → `utils/`
- Moved `core/camera/` and `core/barcode/` → `services/core/`
- Moved `core/api/` → `data/api/`
- Moved `core/storage/` → `data/repositories/`
- Moved `application/` → `providers/`
- Moved `domain/tags/tag_repository.dart` → `data/repositories/` (removed Flutter dependency from domain)
- Split `tag_capture_screen.dart` into components

**Full refactor map:** See `docs/structure/REFMAP-20250127.md` for complete migration details.