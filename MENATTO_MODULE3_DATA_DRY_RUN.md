# /menatto — Module 3: Data Module — DRY-RUN

**Date:** 2025-01-27  
**Module:** Data Module  
**Scope:** `lib/core/api/`, `lib/core/storage/`, `lib/domain/tags/tag_repository.dart` → `lib/data/`

---

## 1. Inventory & Size Map

| File Path | Lines | Status | Notes |
|-----------|-------|--------|-------|
| `lib/core/api/audit_api_client.dart` | 25 | ✅ OK | API client, no Flutter |
| `lib/core/storage/local_storage_service.dart` | 15 | ✅ OK | Abstract interface |
| `lib/core/storage/local_storage_impl.dart` | 12 | ✅ OK | Conditional export |
| `lib/core/storage/local_storage_impl_mobile.dart` | 58 | ✅ OK | Mobile implementation |
| `lib/core/storage/local_storage_impl_web.dart` | 48 | ✅ OK | Web implementation |
| `lib/core/storage/local_storage_impl_stub.dart` | 20 | ✅ OK | Stub implementation |
| `lib/domain/tags/tag_repository.dart` | 124 | ⚠️ **VIOLATION** | Uses SharedPreferences (Flutter package) |

**Summary:**
- **Total files:** 7
- **Total lines:** 302
- **Threshold:** No threshold for data layer
- **Status:** ⚠️ 1 violation found (TagRepository uses Flutter package)

---

## 2. Misplacement Scan

### Current Location
- `lib/core/api/` ❌ **MISPLACED**
- `lib/core/storage/` ❌ **MISPLACED**
- `lib/domain/tags/tag_repository.dart` ❌ **CRITICAL VIOLATION**

### Target Location (per architecture)
- API clients: `lib/data/api/`
- Repositories: `lib/data/repositories/`

### Analysis

**API Client:**
- `lib/core/api/audit_api_client.dart` (25 lines)
  - ✅ **No Flutter imports** - Pure Dart code
  - ✅ **Uses utils/** - Imports `../../utils/result.dart` ✅
  - ✅ **Uses domain/** - Imports `../../domain/models/audit_session.dart` ✅ (data can depend on domain)
  - ✅ **API client** - Should be in `data/api/`

**Storage Services (Repositories):**
- `lib/core/storage/local_storage_service.dart` (15 lines)
  - ✅ **No Flutter imports** - Pure Dart interface
  - ✅ **Uses utils/** - Imports `../../utils/result.dart` ✅
  - ✅ **Repository pattern** - Should be in `data/repositories/`

- `lib/core/storage/local_storage_impl_mobile.dart` (58 lines)
  - ✅ **No Flutter imports** - Uses `package:path_provider` (3rd party, acceptable in data layer)
  - ✅ **Uses dart:io** - Core Dart library ✅
  - ✅ **Platform-specific implementation** - Should be in `data/repositories/`

- `lib/core/storage/local_storage_impl_web.dart` (48 lines)
  - ✅ **No Flutter imports** - Uses `dart:html` (core Dart library for web)
  - ⚠️ **dart:html deprecated** - But this is a known issue, not related to this refactor
  - ✅ **Platform-specific implementation** - Should be in `data/repositories/`

- `lib/core/storage/local_storage_impl_stub.dart` (20 lines)
  - ✅ **No Flutter imports** - Pure Dart stub
  - ✅ **Stub implementation** - Should be in `data/repositories/`

- `lib/core/storage/local_storage_impl.dart` (12 lines)
  - ✅ **Conditional export** - Barrel file for platform-specific exports
  - ✅ **Should move with implementations** - Should be in `data/repositories/`

**TagRepository - CRITICAL VIOLATION:**
- `lib/domain/tags/tag_repository.dart` (124 lines)
  - 🚨 **FLUTTER IMPORT VIOLATION**: Uses `package:shared_preferences` (Flutter package)
  - ❌ **Domain purity violated**: Domain layer must not import Flutter packages
  - ✅ **Repository pattern** - Should be in `data/repositories/`
  - **Impact**: This is a critical architectural violation that needs to be fixed

**Violations:**
- ❌ **TagRepository in domain/**: File uses `package:shared_preferences` which violates domain purity
- ❌ **Wrong directory for API**: Should be in `data/api/` not `core/api/`
- ❌ **Wrong directory for repositories**: Should be in `data/repositories/` not `core/storage/`
- ✅ **3rd party packages OK**: `path_provider` is acceptable in data layer (not Flutter UI)
- ✅ **Core Dart libraries OK**: `dart:io`, `dart:html`, `dart:convert` are acceptable

---

## 3. Dependency Analysis

### Files That Import These Services

| File | Current Import | Will Change To |
|------|---------------|----------------|
| `lib/core/providers.dart` | `import '../domain/tags/tag_repository.dart';` | `import '../data/repositories/tag_repository.dart';` |
| `lib/core/providers.dart` | `import 'storage/local_storage_service.dart';` | `import '../data/repositories/local_storage_service.dart';` |
| `lib/core/providers.dart` | `import 'storage/local_storage_impl.dart' show LocalStorageServiceImpl;` | `import '../data/repositories/local_storage_impl.dart' show LocalStorageServiceImpl;` |
| `lib/core/providers.dart` | `import 'api/audit_api_client.dart';` | `import '../data/api/audit_api_client.dart';` |
| `lib/application/audit/audit_session_notifier.dart` | `import '../../domain/tags/tag_repository.dart';` | `import '../../data/repositories/tag_repository.dart';` |
| `lib/application/audit/audit_session_notifier.dart` | `import '../../core/storage/local_storage_service.dart';` | `import '../../data/repositories/local_storage_service.dart';` |
| `lib/application/audit/audit_session_notifier.dart` | `import '../../core/api/audit_api_client.dart';` | `import '../../data/api/audit_api_client.dart';` |
| `lib/application/tags/tag_suggestions_notifier.dart` | `import '../../domain/tags/tag_repository.dart';` | `import '../../data/repositories/tag_repository.dart';` |

**Total files affected:** 3

**Internal imports to update:**
- `local_storage_impl_mobile.dart`: Imports `local_storage_service.dart` (same directory after move) ✅
- `local_storage_impl_web.dart`: Imports `local_storage_service.dart` (same directory after move) ✅
- `local_storage_impl_stub.dart`: Imports `local_storage_service.dart` (same directory after move) ✅
- `local_storage_impl.dart`: Exports platform-specific implementations (same directory after move) ✅
- `tag_repository.dart`: Imports `tag_trie.dart` from domain (needs path update)

---

## 4. Move Plan

### Refactor Map

| Old Path | New Path | Type | Reason |
|----------|----------|------|--------|
| `lib/core/api/audit_api_client.dart` | `lib/data/api/audit_api_client.dart` | Move | Align with target architecture - data/api/ for API clients |
| `lib/core/storage/local_storage_service.dart` | `lib/data/repositories/local_storage_service.dart` | Move | Repositories belong in data/repositories/ |
| `lib/core/storage/local_storage_impl.dart` | `lib/data/repositories/local_storage_impl.dart` | Move | Conditional export, moves with service |
| `lib/core/storage/local_storage_impl_mobile.dart` | `lib/data/repositories/local_storage_impl_mobile.dart` | Move | Platform implementation, moves with service |
| `lib/core/storage/local_storage_impl_web.dart` | `lib/data/repositories/local_storage_impl_web.dart` | Move | Platform implementation, moves with service |
| `lib/core/storage/local_storage_impl_stub.dart` | `lib/data/repositories/local_storage_impl_stub.dart` | Move | Stub implementation, moves with service |
| `lib/domain/tags/tag_repository.dart` | `lib/data/repositories/tag_repository.dart` | Move | **CRITICAL FIX** - Repository uses Flutter package, violates domain purity |

### Directory Creation
- Create: `lib/data/api/` (if doesn't exist)
- Create: `lib/data/repositories/` (if doesn't exist)

### Import Updates Required
- **External files to update:** 3
  1. `lib/core/providers.dart` (4 imports to update)
  2. `lib/application/audit/audit_session_notifier.dart` (3 imports to update)
  3. `lib/application/tags/tag_suggestions_notifier.dart` (1 import to update)

- **Internal imports to update:** 1
  1. `lib/data/repositories/tag_repository.dart` - Update import of `tag_trie.dart` from domain

---

## 5. Split Plan

**Not applicable** - All files are appropriately sized. No splitting needed.

---

## 6. Dependency Violations

### Reverse Dependencies Check

✅ **No violations found:**
- `data/api/` → `domain/`, `utils/` ✅ (allowed - data can depend on domain and utils)
- `data/repositories/` → `domain/`, `utils/` ✅ (allowed)
- Other modules can depend on `data/` ✅

### Flutter Import Check

🚨 **VIOLATION FOUND:**
- `domain/tags/tag_repository.dart`: Uses `package:shared_preferences` ❌
- **Fix**: Move TagRepository to `data/repositories/` ✅

✅ **After move, no violations:**
- All files in `data/` will have no `package:flutter` imports
- 3rd party packages (`path_provider`, `shared_preferences`) are acceptable in data layer
- Core Dart libraries (`dart:io`, `dart:html`, `dart:convert`) are acceptable

### Dependency Flow

**Current (INCORRECT):**
- `domain/tags/tag_repository.dart` → uses `package:shared_preferences` ❌

**After refactor (CORRECT):**
- `data/repositories/tag_repository.dart` → uses `package:shared_preferences` ✅ (data layer can use Flutter packages for persistence)
- `domain/tags/tag_trie.dart` → stays in domain (pure business logic) ✅
- `data/repositories/tag_repository.dart` → depends on `domain/tags/tag_trie.dart` ✅ (data can depend on domain)

---

## 7. Risk & Test Impact

### Risk Assessment
- **Risk Level:** 🟡 **MEDIUM**
  - Multiple files to move (7 files)
  - Multiple imports to update (8 external + 1 internal)
  - **Critical fix**: TagRepository moving from domain to data fixes architectural violation
  - Conditional exports need careful handling
  - No behavior changes, but larger scope than previous modules

### Test Impact
- **Files affected:** 11 files (7 moves + 3 external import updates + 1 internal import update)
- **Tests:** Currently no tests found (test/ directory is empty)
- **Golden files:** None expected for this module
- **Manual testing:** No impact - pure refactor

### Estimated Diff Size
- **Files changed:** 11 files (7 moves + 4 import updates)
- **Lines changed:** ~12-15 lines (import paths only)
- **Estimated PR size:** Medium (~100-120 lines diff)

---

## 8. Preview: New Tree Structure

### After Refactor

```
lib/
├── main.dart
├── core/
│   ├── api/                ← EMPTY (can be removed)
│   ├── storage/            ← EMPTY (can be removed)
│   ├── providers.dart      ← UPDATED (imports changed)
│   └── ...
├── data/                    ← NEW
│   ├── api/                 ← NEW
│   │   └── audit_api_client.dart  ← MOVED from core/api/
│   └── repositories/        ← NEW
│       ├── local_storage_service.dart        ← MOVED from core/storage/
│       ├── local_storage_impl.dart           ← MOVED from core/storage/
│       ├── local_storage_impl_mobile.dart    ← MOVED from core/storage/
│       ├── local_storage_impl_web.dart       ← MOVED from core/storage/
│       ├── local_storage_impl_stub.dart      ← MOVED from core/storage/
│       └── tag_repository.dart               ← MOVED from domain/tags/ (CRITICAL FIX)
├── domain/
│   ├── models/
│   └── tags/
│       └── tag_trie.dart    ← STAYS (pure business logic)
├── services/
│   └── core/
├── utils/
│   └── result.dart
├── application/
│   ├── audit/
│   │   └── audit_session_notifier.dart  ← UPDATED (imports changed)
│   └── tags/
│       └── tag_suggestions_notifier.dart  ← UPDATED (imports changed)
└── presentation/
    ├── screens/
    └── widgets/
```

### Directory Cleanup
- After move: `lib/core/api/` directory will be empty
- After move: `lib/core/storage/` directory will be empty
- **Action:** Delete empty directories after move

---

## 9. Import Path Changes

### Internal Imports (within moved files)

**Storage Service Files (same directory after move - no change needed):**
- `local_storage_impl_mobile.dart`: `import 'local_storage_service.dart';` ✅
- `local_storage_impl_web.dart`: `import 'local_storage_service.dart';` ✅
- `local_storage_impl_stub.dart`: `import 'local_storage_service.dart';` ✅
- `local_storage_impl.dart`: Exports remain the same ✅

**TagRepository (needs path update):**
- **Before:** `import 'tag_trie.dart';` (same directory in domain/tags/)
- **After:** `import '../../domain/tags/tag_trie.dart';` (from data/repositories/ to domain/tags/)

**API Client (needs path update):**
- **Before:** `import '../../domain/models/audit_session.dart';`
- **After:** `import '../../domain/models/audit_session.dart';` ✅ (same relative path from data/api/)

**Storage Service Files (utils import - needs path update):**
- **Before:** `import '../../utils/result.dart';` (from core/storage/)
- **After:** `import '../../utils/result.dart';` ✅ (same relative path from data/repositories/)

### External Imports

**core/providers.dart:**
- **Before:**
  - `import '../domain/tags/tag_repository.dart';`
  - `import 'storage/local_storage_service.dart';`
  - `import 'storage/local_storage_impl.dart' show LocalStorageServiceImpl;`
  - `import 'api/audit_api_client.dart';`
- **After:**
  - `import '../data/repositories/tag_repository.dart';`
  - `import '../data/repositories/local_storage_service.dart';`
  - `import '../data/repositories/local_storage_impl.dart' show LocalStorageServiceImpl;`
  - `import '../data/api/audit_api_client.dart';`

**application/audit/audit_session_notifier.dart:**
- **Before:**
  - `import '../../domain/tags/tag_repository.dart';`
  - `import '../../core/storage/local_storage_service.dart';`
  - `import '../../core/api/audit_api_client.dart';`
- **After:**
  - `import '../../data/repositories/tag_repository.dart';`
  - `import '../../data/repositories/local_storage_service.dart';`
  - `import '../../data/api/audit_api_client.dart';`

**application/tags/tag_suggestions_notifier.dart:**
- **Before:** `import '../../domain/tags/tag_repository.dart';`
- **After:** `import '../../data/repositories/tag_repository.dart';`

---

## 10. Validation Checklist

### Pre-Refactor Checks
- [x] Files identified: 7 files (1 API client, 5 storage services, 1 repository)
- [x] Size verified: All files appropriately sized (12-124 lines)
- [x] Violations identified: 1 critical violation (TagRepository uses Flutter package)
- [x] Dependencies identified: 3 external files + 1 internal import
- [x] Reverse dependencies: ✅ None (data has no dependencies on other modules except domain/utils)

### Post-Refactor Checks (to verify after APPLY)
- [ ] Files moved to `lib/data/api/` and `lib/data/repositories/`
- [ ] All 11 imports updated (8 external + 1 internal + 2 conditional exports)
- [ ] Empty `lib/core/api/` directory deleted
- [ ] Empty `lib/core/storage/` directory deleted
- [ ] `flutter analyze` passes
- [ ] No broken imports
- [ ] App compiles successfully
- [ ] **CRITICAL**: Domain no longer has Flutter imports ✅

---

## 11. Execution Steps (for APPLY phase)

1. **Create target directories:**
   - Create `lib/data/api/` if it doesn't exist
   - Create `lib/data/repositories/` if it doesn't exist

2. **Move API client (1 file):**
   - Move `lib/core/api/audit_api_client.dart` → `lib/data/api/audit_api_client.dart`

3. **Move storage services (5 files):**
   - Move `lib/core/storage/local_storage_service.dart` → `lib/data/repositories/local_storage_service.dart`
   - Move `lib/core/storage/local_storage_impl.dart` → `lib/data/repositories/local_storage_impl.dart`
   - Move `lib/core/storage/local_storage_impl_mobile.dart` → `lib/data/repositories/local_storage_impl_mobile.dart`
   - Move `lib/core/storage/local_storage_impl_web.dart` → `lib/data/repositories/local_storage_impl_web.dart`
   - Move `lib/core/storage/local_storage_impl_stub.dart` → `lib/data/repositories/local_storage_impl_stub.dart`

4. **Move TagRepository (1 file - CRITICAL FIX):**
   - Move `lib/domain/tags/tag_repository.dart` → `lib/data/repositories/tag_repository.dart`

5. **Update internal imports (1 file):**
   - Update `lib/data/repositories/tag_repository.dart`:
     - Change: `import 'tag_trie.dart';` → `import '../../domain/tags/tag_trie.dart';`

6. **Update external imports (3 files):**
   - Update `lib/core/providers.dart` (4 imports)
   - Update `lib/application/audit/audit_session_notifier.dart` (3 imports)
   - Update `lib/application/tags/tag_suggestions_notifier.dart` (1 import)

7. **Cleanup:**
   - Delete empty `lib/core/api/` directory
   - Delete empty `lib/core/storage/` directory

8. **Verify:**
   - Run `flutter analyze`
   - Verify app compiles
   - Check no broken imports
   - **Verify domain/ has no Flutter imports** ✅

---

## 12. Expected Outcome

### Files Changed
- ✅ 7 files moved: API client + 5 storage services + TagRepository
- ✅ 4 files updated: Import paths fixed
- ✅ 2 directories deleted: `core/api/` and `core/storage/` (empty)

### Architecture Compliance
- ✅ API clients in correct location: `lib/data/api/`
- ✅ Repositories in correct location: `lib/data/repositories/`
- ✅ **CRITICAL FIX**: TagRepository moved out of domain (fixes Flutter import violation)
- ✅ No Flutter imports in domain/ ✅
- ✅ Data layer can use Flutter packages for persistence ✅

### No Breaking Changes
- ✅ Public API unchanged
- ✅ Behavior unchanged
- ✅ Import paths updated consistently
- ✅ All references updated

---

## Summary

**Module 3: Data Module** is a **medium complexity refactor** with a **critical architectural fix**:
- 7 files to move (302 total lines)
- 11 import statements to update (8 external + 1 internal + 2 conditional exports)
- **CRITICAL**: Fixes TagRepository violation (Flutter package in domain)
- No Flutter dependencies in domain after move
- No behavior changes
- Estimated completion: ~10-15 minutes

**Recommendation:** ✅ **SAFE TO PROCEED** - This module fixes a critical architectural violation while reorganizing the data layer.

**Key Benefit:** After this refactor, `domain/` will be pure business logic with no Flutter dependencies, and `data/` will properly contain all repositories and API clients.

---

**Next:** After Module 3 is complete, proceed to Module 4: Domain Module (cleanup verification).

