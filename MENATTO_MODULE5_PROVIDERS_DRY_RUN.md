# /menatto — Module 5: Providers Module — DRY-RUN

**Date:** 2025-01-27  
**Module:** Providers Module  
**Scope:** `lib/application/` → `lib/providers/` + `lib/core/providers.dart` → `lib/providers/providers.dart`

---

## 1. Inventory & Size Map

| File Path | Lines | Status | Notes |
|-----------|-------|--------|-------|
| `lib/application/audit/audit_session_notifier.dart` | 225 | ✅ OK | StateNotifier (below 250 threshold) |
| `lib/application/tags/tag_suggestions_notifier.dart` | 57 | ✅ OK | StateNotifier (well below threshold) |
| `lib/core/providers.dart` | 57 | ✅ OK | Provider definitions (will move to providers/) |

**Summary:**
- **Total files:** 3 (2 notifiers + 1 provider file)
- **Total lines:** 339
- **Threshold:** Providers ≤250 lines
- **Status:** ✅ All files are appropriately sized

---

## 2. Misplacement Scan

### Current Location
- `lib/application/` ❌ **MISPLACED** (should be `providers/`)
- `lib/core/providers.dart` ❌ **MISPLACED** (provider definitions should be in `providers/`)

### Target Location (per architecture)
- Should be in: `lib/providers/`

### Analysis

**Notifiers:**
- `lib/application/audit/audit_session_notifier.dart` (225 lines)
  - ✅ **Uses StateNotifier** - `extends StateNotifier<AuditSessionState>`
  - ✅ **Uses Riverpod** - Imports `package:flutter_riverpod/flutter_riverpod.dart`
  - ✅ **No Flutter UI** - No Widget, BuildContext, or UI-related imports
  - ✅ **State management** - Pure application state logic
  - ✅ **File size**: 225 lines (below 250 threshold) ✅

- `lib/application/tags/tag_suggestions_notifier.dart` (57 lines)
  - ✅ **Uses StateNotifier** - `extends StateNotifier<TagSuggestionsState>`
  - ✅ **Uses Riverpod** - Imports `package:flutter_riverpod/flutter_riverpod.dart`
  - ✅ **No Flutter UI** - Pure state management
  - ✅ **File size**: 57 lines (well below threshold) ✅

**Provider Definitions:**
- `lib/core/providers.dart` (57 lines)
  - ✅ **Contains Riverpod providers** - Multiple `Provider` and `StateNotifierProvider` definitions
  - ✅ **Provider registration** - Centralized provider definitions
  - ✅ **Should be in providers/** - Provider definitions belong in providers directory

**Violations:**
- ❌ **Wrong directory**: `application/` should be renamed to `providers/`
- ❌ **Provider definitions misplaced**: `core/providers.dart` should be in `providers/`
- ✅ **No UI violations**: All files are pure state management (no Flutter UI)

---

## 3. Dependency Analysis

### Files That Import These Providers

| File | Current Import | Will Change To |
|------|---------------|----------------|
| `lib/core/providers.dart` | `import '../application/audit/audit_session_notifier.dart';` | `import '../providers/audit/audit_session_notifier.dart';` |
| `lib/core/providers.dart` | `import '../application/tags/tag_suggestions_notifier.dart';` | `import '../providers/tags/tag_suggestions_notifier.dart';` |
| `lib/presentation/screens/tag_capture_screen.dart` | `import '../../core/providers.dart';` | `import '../../providers/providers.dart';` |
| `lib/presentation/widgets/tag_chip_cloud.dart` | `import '../../core/providers.dart';` | `import '../../providers/providers.dart';` |
| `lib/presentation/widgets/tag_autocomplete_input.dart` | `import '../../core/providers.dart';` | `import '../../providers/providers.dart';` |
| `lib/presentation/screens/barcode_scan_screen_mobile_wrapper.dart` | `import '../../core/providers.dart';` | `import '../../providers/providers.dart';` |
| `lib/presentation/screens/barcode_scan_screen_mobile.dart` | `import '../../core/providers.dart';` | `import '../../providers/providers.dart';` |

**Total files affected:** 7

**Internal imports in notifiers:**
- `audit_session_notifier.dart`: All imports use relative paths that will adjust automatically after move ✅
- `tag_suggestions_notifier.dart`: All imports use relative paths that will adjust automatically after move ✅

---

## 4. Move Plan

### Refactor Map

| Old Path | New Path | Type | Reason |
|----------|----------|------|--------|
| `lib/application/audit/audit_session_notifier.dart` | `lib/providers/audit/audit_session_notifier.dart` | Move | Align with target architecture - providers/ for state management |
| `lib/application/tags/tag_suggestions_notifier.dart` | `lib/providers/tags/tag_suggestions_notifier.dart` | Move | Same as above |
| `lib/core/providers.dart` | `lib/providers/providers.dart` | Move | Provider definitions belong in providers/ directory |

### Directory Creation
- Create: `lib/providers/audit/` (if doesn't exist)
- Create: `lib/providers/tags/` (if doesn't exist)

### Import Updates Required
- **External files to update:** 7
  1. `lib/core/providers.dart` → becomes `lib/providers/providers.dart` (2 imports to update internally)
  2. `lib/presentation/screens/tag_capture_screen.dart` (1 import)
  3. `lib/presentation/widgets/tag_chip_cloud.dart` (1 import)
  4. `lib/presentation/widgets/tag_autocomplete_input.dart` (1 import)
  5. `lib/presentation/screens/barcode_scan_screen_mobile_wrapper.dart` (1 import)
  6. `lib/presentation/screens/barcode_scan_screen_mobile.dart` (1 import)

- **Internal imports to update:** 2 (in providers.dart after move)
  1. `lib/providers/providers.dart` - Update imports of notifiers (after moving)

---

## 5. Split Plan

**Not applicable** - All files are well below thresholds:
- `audit_session_notifier.dart`: 225 lines (below 250 threshold) ✅
- `tag_suggestions_notifier.dart`: 57 lines ✅
- `providers.dart`: 57 lines ✅

---

## 6. Dependency Violations

### Reverse Dependencies Check

✅ **No violations found:**
- `providers/` → `domain/`, `data/`, `services/`, `utils/` ✅ (allowed - providers orchestrate other layers)
- Other modules can depend on `providers/` ✅

### Flutter Import Check

**Provider files:**
- ✅ **flutter_riverpod**: Acceptable in providers layer (state management)
- ✅ **No Flutter UI**: No `package:flutter/material.dart` or UI-related imports
- ✅ **Pure state management**: Only Riverpod for state management

**Provider Dependencies:**
- `audit_session_notifier.dart`: Uses `image_picker` (3rd party package for camera) - acceptable in providers ✅
- `tag_suggestions_notifier.dart`: Pure Riverpod ✅

### Dependency Flow

**Current (CORRECT):**
- `providers/` → `domain/`, `data/`, `services/`, `utils/` ✅

**After refactor (CORRECT):**
- Same dependency flow maintained ✅
- All imports use relative paths that will adjust correctly ✅

---

## 7. Risk & Test Impact

### Risk Assessment
- **Risk Level:** 🟡 **MEDIUM**
  - Directory rename (application → providers)
  - Multiple files to update (7 files)
  - Provider definitions file move
  - No behavior changes, but more files affected than previous modules

### Test Impact
- **Files affected:** 10 files (3 moves + 7 import updates)
- **Tests:** Currently no tests found (test/ directory is empty)
- **Golden files:** None expected for this module
- **Manual testing:** No impact - pure refactor

### Estimated Diff Size
- **Files changed:** 10 files (3 moves + 7 import updates)
- **Lines changed:** ~10-12 lines (import paths only)
- **Estimated PR size:** Medium (~80-100 lines diff)

---

## 8. Preview: New Tree Structure

### After Refactor

```
lib/
├── main.dart
├── core/
│   ├── api/                ← EMPTY (can be removed)
│   ├── storage/            ← EMPTY (can be removed)
│   ├── camera/             ← EMPTY (can be removed)
│   ├── barcode/            ← EMPTY (can be removed)
│   ├── util/               ← EMPTY (can be removed)
│   └── providers.dart      ← DELETED (moved to providers/)
├── providers/              ← NEW (renamed from application/)
│   ├── audit/
│   │   └── audit_session_notifier.dart  ← MOVED from application/audit/
│   ├── tags/
│   │   └── tag_suggestions_notifier.dart  ← MOVED from application/tags/
│   └── providers.dart      ← MOVED from core/providers.dart
├── domain/
│   ├── models/
│   └── tags/
├── data/
│   ├── api/
│   └── repositories/
├── services/
│   └── core/
├── utils/
│   └── result.dart
└── presentation/
    ├── screens/
    │   ├── tag_capture_screen.dart  ← UPDATED (import changed)
    │   ├── barcode_scan_screen_mobile_wrapper.dart  ← UPDATED
    │   └── barcode_scan_screen_mobile.dart  ← UPDATED
    └── widgets/
        ├── tag_chip_cloud.dart  ← UPDATED
        └── tag_autocomplete_input.dart  ← UPDATED
```

### Directory Cleanup
- After move: `lib/application/` directory will be empty (renamed to providers/)
- After move: `lib/core/providers.dart` will be deleted (moved to providers/providers.dart)

---

## 9. Import Path Changes

### Internal Imports (within moved files)

**Notifier Files (paths adjust automatically):**
- `audit_session_notifier.dart`: All imports use relative paths (`../../domain/`, `../../data/`, etc.)
  - **Before:** `import '../../domain/models/audit_session.dart';` (from application/audit/)
  - **After:** `import '../../domain/models/audit_session.dart';` ✅ (same relative path from providers/audit/)
- `tag_suggestions_notifier.dart`: Same - relative paths remain correct ✅

### Provider Definitions File

**Before:**
- `lib/core/providers.dart`:
  - `import '../application/audit/audit_session_notifier.dart';`
  - `import '../application/tags/tag_suggestions_notifier.dart';`

**After:**
- `lib/providers/providers.dart`:
  - `import 'audit/audit_session_notifier.dart';` (same directory)
  - `import 'tags/tag_suggestions_notifier.dart';` (same directory)

### External Imports

**All files importing core/providers.dart:**
- **Before:** `import '../../core/providers.dart';`
- **After:** `import '../../providers/providers.dart';`

---

## 10. Validation Checklist

### Pre-Refactor Checks
- [x] Files identified: 3 files (2 notifiers + 1 provider file)
- [x] Size verified: All files appropriately sized (57-225 lines)
- [x] Provider detection: ✅ Confirmed (StateNotifier, Provider, StateNotifierProvider)
- [x] Dependencies identified: 7 external files + 2 internal imports
- [x] Reverse dependencies: ✅ None (providers don't depend on presentation)

### Post-Refactor Checks (to verify after APPLY)
- [ ] Files moved to `lib/providers/`
- [ ] Directory renamed: `application/` → `providers/`
- [ ] Provider file moved: `core/providers.dart` → `providers/providers.dart`
- [ ] All 9 imports updated (7 external + 2 internal)
- [ ] `lib/core/providers.dart` deleted
- [ ] `flutter analyze` passes
- [ ] No broken imports
- [ ] App compiles successfully

---

## 11. Execution Steps (for APPLY phase)

1. **Create target directories:**
   - Create `lib/providers/audit/` if it doesn't exist
   - Create `lib/providers/tags/` if it doesn't exist

2. **Move notifier files (2 files):**
   - Move `lib/application/audit/audit_session_notifier.dart` → `lib/providers/audit/audit_session_notifier.dart`
   - Move `lib/application/tags/tag_suggestions_notifier.dart` → `lib/providers/tags/tag_suggestions_notifier.dart`

3. **Move provider definitions file:**
   - Move `lib/core/providers.dart` → `lib/providers/providers.dart`

4. **Update imports in providers.dart:**
   - Change: `import '../application/audit/audit_session_notifier.dart';` → `import 'audit/audit_session_notifier.dart';`
   - Change: `import '../application/tags/tag_suggestions_notifier.dart';` → `import 'tags/tag_suggestions_notifier.dart';`

5. **Update external imports (6 files):**
   - Update all files importing `core/providers.dart`:
     - `lib/presentation/screens/tag_capture_screen.dart`
     - `lib/presentation/widgets/tag_chip_cloud.dart`
     - `lib/presentation/widgets/tag_autocomplete_input.dart`
     - `lib/presentation/screens/barcode_scan_screen_mobile_wrapper.dart`
     - `lib/presentation/screens/barcode_scan_screen_mobile.dart`
   - Change: `import '../../core/providers.dart';` → `import '../../providers/providers.dart';`

6. **Verify notifier internal imports:**
   - Check `audit_session_notifier.dart`: Relative paths should still work ✅ (same relative depth)
   - Check `tag_suggestions_notifier.dart`: Relative paths should still work ✅

7. **Cleanup:**
   - Delete `lib/core/providers.dart` (already moved)
   - Remove empty `lib/application/` directory (if empty after move)

8. **Verify:**
   - Run `flutter analyze`
   - Verify app compiles
   - Check no broken imports

---

## 12. Expected Outcome

### Files Changed
- ✅ 3 files moved: 2 notifiers + 1 provider file
- ✅ 7 files updated: Import paths fixed (6 external + 1 internal)
- ✅ 1 directory renamed: `application/` → `providers/`
- ✅ 1 file deleted: `core/providers.dart` (moved to providers/)

### Architecture Compliance
- ✅ Providers in correct location: `lib/providers/`
- ✅ Provider definitions in providers directory ✅
- ✅ All Riverpod providers/notifiers in providers/ ✅
- ✅ Other modules can depend on providers/ ✅

### No Breaking Changes
- ✅ Public API unchanged
- ✅ Behavior unchanged
- ✅ Import paths updated consistently
- ✅ All references updated

---

## Summary

**Module 5: Providers Module** is a **medium complexity refactor**:
- 3 files to move (339 total lines)
- 9 import statements to update (7 external + 2 internal)
- Directory rename required
- No Flutter UI violations
- No behavior changes
- Estimated completion: ~10-15 minutes

**Recommendation:** ✅ **SAFE TO PROCEED** - This module properly organizes all Riverpod state management into the providers directory.

**Key Achievement:** After this refactor, all Riverpod providers and notifiers will be properly organized in `lib/providers/`, and the `core/` directory will be cleaned up.

---

**Next:** After Module 5 is complete, proceed to Module 6: Providers Registration (cleanup/verification).

