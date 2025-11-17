# Implementation Checklist

Status of implementation for Iteration 1 of the Product Audit Tool.

**Status:** ✅ **Iteration 1 Complete** - All core features implemented and working on mobile and web.

---

# 1. Project Setup
- [x] Create Flutter project
- [x] Add dependencies:
  - [x] camera (0.10.5+5)
  - [x] image_picker (1.0.5)
  - [x] mobile_scanner (5.0.0)
  - [x] flutter_riverpod (2.4.9)
  - [x] shared_preferences (2.2.2)
  - [x] path_provider (2.1.1)
  - [x] equatable (2.0.5)
- [x] Setup folder structure per TECH_STRUCTURE.md

---

# 2. Core Domain
- [x] Implement `AuditSession` + `AuditImage`
- [x] Implement file naming helper (`FileNaming`)
- [x] Implement tag sanitization function

---

# 3. Tag Trie System
- [x] Create Trie node class (`TrieNode`)
- [x] Implement insert(tag)
- [x] Implement suggest(prefix)
- [x] Implement usageCount increment
- [x] Implement JSON serialization
- [x] Implement TagRepository with:
  - [x] load()
  - [x] save()
  - [x] registerTags()
  - [x] suggest()

---

# 4. Services (abstract first, then implementation)
### CameraService
- [x] Define abstract interface
- [x] Create mobile implementation (`CameraServiceImpl`)

### BarcodeScannerService
- [x] Define abstract interface
- [x] Create mobile implementation using `mobile_scanner` (`BarcodeScannerImpl`)

### LocalStorageService
- [x] Define abstract interface
- [x] Implement mobile using `dart:io` + `path_provider` (`LocalStorageServiceImpl` mobile)
- [x] Implement web using browser download API (`LocalStorageServiceImpl` web)
- [x] Implement stub for testing

### AuditApiClient
- [x] Define abstract interface
- [x] Create FakeAuditApiClient (no-op)

---

# 5. Application Layer
### AuditSessionNotifier
- [x] startSession(barcode)
- [x] captureTaggedPhoto(tags)
- [x] clearSession()
- [x] uploadSession() (with FakeApiClient)

### TagSuggestionsNotifier
- [x] updateQuery()
- [x] integrate with trie suggestions

---

# 6. UI Layer
### HomeScreen
- [x] Start button → barcode scan

### BarcodeScanScreen
- [x] Platform detection (web vs mobile)
- [x] Mobile: Integrate `BarcodeScannerService`
- [x] Web: Manual barcode entry fallback
- [x] On detect → startSession → navigate to TagCaptureScreen

### TagCaptureScreen
- [x] Show barcode & photo count
- [x] Take photo button
- [x] Tag chips cloud (Trie)
- [x] Autocomplete text field
- [x] Save photo (calls notifier)
- [x] Finish button
- [x] Error handling and user feedback

### Widgets
- [x] TagChipCloud widget
- [x] TagAutocompleteInput widget

---

# 7. Local Persistence
- [x] Images save into app-documents folder (mobile)
- [x] Images download via browser API (web)
- [x] Tag trie JSON stored in SharedPreferences
- [x] Platform-specific storage implementations

---

# 8. Web Support
- [x] Platform detection for services
- [x] Web-compatible barcode entry (manual input)
- [x] Web-compatible file storage (downloads)
- [x] Conditional imports for platform-specific code

---

# 9. Optional UI Enhancements (phase 1.5)
- [ ] Animations on chip selection
- [ ] Animated autocomplete dropdown
- [ ] Frequency-based chip sizing

---

# 10. API Integration
- [x] Session JSON generation (toJson methods)
- [x] FakeAuditApiClient implemented
- [ ] Real backend upload (future)

---

# 11. Ready for Iteration 2
- [ ] Add ReviewSessionScreen
- [ ] Add batch upload to server
- [ ] Add authentication (optional)
- [ ] Add UI animations and enhancements

---

## Implementation Status Summary

**Iteration 1 (Complete):**
- ✅ All core features implemented
- ✅ Mobile support (Android/iOS)
- ✅ Web support with platform detection
- ✅ Tag trie system with persistence
- ✅ Photo capture and tagging
- ✅ Barcode scanning (mobile) / manual entry (web)
- ✅ File naming convention implemented
- ✅ Session management working
- ✅ All services abstracted for testability

**Next Steps (Iteration 2):**
- Review and export session screen
- Backend API integration (real upload)
- UI enhancements and animations
- Additional testing and polish

---

# 12. Code Structure Restructuring (/menatto)

## Module 1: Utils Module
- [x] Run `/menatto` on `lib/core/util/` → `lib/utils/`
- [x] Move `core/util/result.dart` to `utils/result.dart`
- [x] Update all imports referencing `core/util/result.dart` (12 files updated)
- [x] Verify no Flutter imports in utils/
- [x] Run `flutter analyze` and fix any errors ✅

## Module 2: Services Module
- [x] Run `/menatto` on `lib/core/camera/` and `lib/core/barcode/` → `lib/services/core/`
- [x] Move camera service files to `services/core/` (2 files)
- [x] Move barcode scanner files to `services/core/` (2 files)
- [x] Update all imports (2 external files: providers.dart, audit_session_notifier.dart)
- [x] Verify no Flutter imports in services/
- [x] Run `flutter analyze` and fix any errors ✅

## Module 3: Data Module
- [x] Run `/menatto` on `lib/core/api/`, `lib/core/storage/`, and `lib/domain/tags/tag_repository.dart` → `lib/data/`
- [x] Move API client to `data/api/` (1 file)
- [x] Move storage services to `data/repositories/` (5 files)
- [x] Move TagRepository from `domain/tags/` to `data/repositories/` ✅ **CRITICAL FIX** (fixes Flutter import violation)
- [x] Update all imports (4 files: providers.dart, audit_session_notifier.dart, tag_suggestions_notifier.dart, tag_repository.dart)
- [x] Verify no Flutter imports in domain/ ✅ (domain is now pure)
- [x] Run `flutter analyze` and fix any errors ✅

## Module 4: Domain Module
- [x] Run `/menatto` on `lib/domain/`
- [x] Verify TagRepository moved to data/ (from Module 3) ✅ **CONFIRMED**
- [x] Ensure domain/ contains only pure business logic models ✅
- [x] Verify no Flutter imports remain in domain/ ✅ **0 Flutter imports found**
- [x] Update any remaining imports ✅ (No changes needed - all imports correct)
- [x] Run `flutter analyze` and fix any errors ✅ (Verification complete - domain is pure)

## Module 5: Providers Module
- [x] Run `/menatto` on `lib/application/` → `lib/providers/`
- [x] Rename `application/` directory to `providers/` (moved files)
- [x] Move provider definitions from `core/providers.dart` to `providers/providers.dart`
- [x] Update all imports referencing `application/` or `core/providers.dart` (7 files updated)
- [x] Verify all Riverpod providers are in `providers/` ✅
- [x] Run `flutter analyze` and fix any errors ✅

## Module 6: Providers Registration
- [x] Merge provider definitions from `core/providers.dart` into `providers/providers.dart` ✅ (completed in Module 5)
- [x] Delete `core/providers.dart` after moving content ✅ (deleted)
- [x] Update all imports ✅ (completed in Module 5)
- [x] Run `flutter analyze` and fix any errors ✅ (no errors)

## Module 7: Presentation Module
- [x] Run `/menatto` on `lib/presentation/`
- [x] Split `tag_capture_screen.dart` (352 → 234 lines) into smaller components ✅
- [x] Extract components to `presentation/widgets/components/` ✅ (4 components created)
- [x] Verify all screens are ≤300 lines, widgets ≤200 lines ✅
- [x] Update imports if needed ✅ (1 file updated)
- [x] Run `flutter analyze` and fix any errors ✅ (2 info-level deprecation warnings, unrelated)

## Module 8: Structure Documentation
- [x] Update `TECH_STRUCTURE.md` with new folder structure ✅
- [x] Create refactor map `docs/structure/REFMAP-YYYYMMDD.md` listing old → new paths ✅ (REFMAP-20250127.md created)
- [x] Update `agents.md` with new structure references ✅
- [x] Run `flutter analyze` and verify no errors ✅ (3 info-level deprecation warnings, unrelated)
- [x] Run tests and update golden files if needed ✅ (no tests require updates)