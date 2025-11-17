# Code Structure Restructuring - Module Plan

This document lists all modules that need restructuring using `/menatto` command.

## Module List

Based on the current structure analysis, the project needs restructuring into these modules:

### 1. **Presentation Module** (`lib/presentation/`)
**Current Status:** Mostly correct, but has violations
- **Location:** `lib/presentation/`
- **Target:** `lib/presentation/` (keep)
- **Issues:**
  - `tag_capture_screen.dart` (323 lines) exceeds 300-line threshold for pages
  - Should split into components
  
**Files:**
- `presentation/screens/home_screen.dart` (67 lines) ✅
- `presentation/screens/barcode_scan_screen.dart` (12 lines) ✅
- `presentation/screens/barcode_scan_screen_mobile.dart` (101 lines) ✅
- `presentation/screens/barcode_scan_screen_mobile_wrapper.dart` (113 lines) ✅
- `presentation/screens/barcode_scan_screen_web.dart` (25 lines) ✅
- `presentation/screens/tag_capture_screen.dart` (323 lines) ⚠️ **NEEDS SPLIT**
- `presentation/widgets/tag_autocomplete_input.dart` (78 lines) ✅
- `presentation/widgets/tag_chip_cloud.dart` (46 lines) ✅

---

### 2. **Providers Module** (`lib/application/` → `lib/providers/`)
**Current Status:** Needs renaming
- **Current:** `lib/application/`
- **Target:** `lib/providers/`
- **Issues:**
  - Directory should be renamed from `application/` to `providers/`
  - Files are appropriately sized (<250 lines)

**Files:**
- `application/audit/audit_session_notifier.dart` (197 lines) ✅
- `application/tags/tag_suggestions_notifier.dart` (48 lines) ✅

---

### 3. **Domain Module** (`lib/domain/`)
**Current Status:** Has violations - TagRepository should be in data/
- **Location:** `lib/domain/`
- **Target:** `lib/domain/` (keep, but move TagRepository)
- **Issues:**
  - `domain/tags/tag_repository.dart` uses SharedPreferences (Flutter package) - violates domain purity
  - TagRepository should move to `data/repositories/`
  - Domain should only have pure business logic models

**Files:**
- `domain/models/audit_image.dart` (24 lines) ✅
- `domain/models/audit_session.dart` (37 lines) ✅
- `domain/models/file_naming.dart` (70 lines) ✅
- `domain/tags/tag_trie.dart` (114 lines) ✅
- `domain/tags/tag_repository.dart` (111 lines) ⚠️ **NEEDS MOVE to data/repositories/**

---

### 4. **Data Module** (`lib/core/api/`, `lib/core/storage/`, `lib/domain/tags/tag_repository.dart` → `lib/data/`)
**Current Status:** Scattered across core/ and domain/
- **Current:** 
  - `lib/core/api/`
  - `lib/core/storage/`
  - `lib/domain/tags/tag_repository.dart`
- **Target:** `lib/data/`
- **Issues:**
  - API clients should be in `data/api/`
  - Repositories should be in `data/repositories/`
  - TagRepository should move from domain/ to data/repositories/
  - Must not import Flutter packages

**Files:**
- `core/api/audit_api_client.dart` (25 lines) → `data/api/audit_api_client.dart`
- `core/storage/local_storage_service.dart` (13 lines) → `data/repositories/local_storage_service.dart`
- `core/storage/local_storage_impl.dart` (9 lines) → `data/repositories/local_storage_impl.dart`
- `core/storage/local_storage_impl_mobile.dart` (50 lines) → `data/repositories/local_storage_impl_mobile.dart`
- `core/storage/local_storage_impl_web.dart` (42 lines) → `data/repositories/local_storage_impl_web.dart`
- `core/storage/local_storage_impl_stub.dart` (18 lines) → `data/repositories/local_storage_impl_stub.dart`
- `domain/tags/tag_repository.dart` (111 lines) → `data/repositories/tag_repository.dart`

---

### 5. **Services Module** (`lib/core/camera/`, `lib/core/barcode/` → `lib/services/`)
**Current Status:** In core/, should be in services/
- **Current:** `lib/core/camera/`, `lib/core/barcode/`
- **Target:** `lib/services/core/`
- **Issues:**
  - Cross-cutting services should be in `services/core/`
  - Must not import Flutter packages

**Files:**
- `core/camera/camera_service.dart` (7 lines) → `services/core/camera_service.dart`
- `core/camera/camera_service_impl.dart` (23 lines) → `services/core/camera_service_impl.dart`
- `core/barcode/barcode_scanner_service.dart` (9 lines) → `services/core/barcode_scanner_service.dart`
- `core/barcode/barcode_scanner_impl.dart` (35 lines) → `services/core/barcode_scanner_impl.dart`

---

### 6. **Utils Module** (`lib/core/util/` → `lib/utils/`)
**Current Status:** In core/, should be in utils/
- **Current:** `lib/core/util/`
- **Target:** `lib/utils/`
- **Issues:**
  - Pure utilities should be in `utils/`

**Files:**
- `core/util/result.dart` (32 lines) → `utils/result.dart`

---

### 7. **Providers Registration** (`lib/core/providers.dart` → `lib/providers/providers.dart`)
**Current Status:** Provider definitions in core/
- **Current:** `lib/core/providers.dart`
- **Target:** `lib/providers/providers.dart`
- **Issues:**
  - All Riverpod providers should be in `providers/` directory

**Files:**
- `core/providers.dart` (48 lines) → `providers/providers.dart`

---

### 8. **Config Module** (Future)
**Current Status:** Not yet implemented
- **Target:** `lib/config/`
- **Notes:** For environment configuration and constants

---

## Module Execution Order

Recommended order for restructuring:

1. **Utils Module** - Simplest, no dependencies
2. **Services Module** - Minimal dependencies
3. **Data Module** - Depends on utils, but no Flutter
4. **Domain Module** - Clean up TagRepository move
5. **Providers Module** - Depends on domain, data, services
6. **Providers Registration** - Depends on providers directory existing
7. **Presentation Module** - Depends on providers, domain

## Summary

- **Total modules to restructure:** 7
- **Files to move:** ~20 files
- **Files to split:** 1 file (tag_capture_screen.dart)
- **Major violations:** TagRepository in domain/ (uses Flutter package)

