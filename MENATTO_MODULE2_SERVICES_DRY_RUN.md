# /menatto — Module 2: Services Module — DRY-RUN

**Date:** 2025-01-27  
**Module:** Services Module  
**Scope:** `lib/core/camera/`, `lib/core/barcode/` → `lib/services/core/`

---

## 1. Inventory & Size Map

| File Path | Lines | Status | Notes |
|-----------|-------|--------|-------|
| `lib/core/camera/camera_service.dart` | 9 | ✅ OK | Abstract interface, no Flutter |
| `lib/core/camera/camera_service_impl.dart` | 28 | ✅ OK | Implementation, uses image_picker |
| `lib/core/barcode/barcode_scanner_service.dart` | 11 | ✅ OK | Abstract interface, no Flutter |
| `lib/core/barcode/barcode_scanner_impl.dart` | 42 | ✅ OK | Implementation, uses mobile_scanner |

**Summary:**
- **Total files:** 4
- **Total lines:** 90
- **Threshold:** No threshold for services
- **Status:** ✅ All files are appropriately sized

---

## 2. Misplacement Scan

### Current Location
- `lib/core/camera/` ❌ **MISPLACED**
- `lib/core/barcode/` ❌ **MISPLACED**

### Target Location (per architecture)
- Should be in: `lib/services/core/`

### Analysis

**Camera Service:**
- `lib/core/camera/camera_service.dart` (9 lines)
  - ✅ **No Flutter imports** - Uses `package:image_picker` (3rd party package, OK for services)
  - ✅ **Abstract interface** - Pure abstraction
  - ✅ **Uses utils/** - Imports `../../utils/result.dart` ✅

- `lib/core/camera/camera_service_impl.dart` (28 lines)
  - ✅ **No Flutter imports** - Uses `package:image_picker` (3rd party package, OK)
  - ✅ **Service implementation** - Cross-cutting service
  - ✅ **Uses utils/** - Imports `../../utils/result.dart` ✅

**Barcode Scanner Service:**
- `lib/core/barcode/barcode_scanner_service.dart` (11 lines)
  - ✅ **No Flutter imports** - Pure Dart abstract interface
  - ✅ **Uses utils/** - Imports `../../utils/result.dart` ✅

- `lib/core/barcode/barcode_scanner_impl.dart` (42 lines)
  - ✅ **No Flutter imports** - Uses `package:mobile_scanner` (3rd party package, OK for services)
  - ✅ **Service implementation** - Cross-cutting service
  - ✅ **Uses utils/** - Imports `../../utils/result.dart` ✅

**Violations:**
- ❌ **Wrong directory**: Files are in `core/camera/` and `core/barcode/` but should be in `services/core/` according to target architecture
- ✅ **No Flutter dependency violations**: Confirmed no `package:flutter` imports
- ✅ **3rd party packages OK**: `image_picker` and `mobile_scanner` are acceptable in services layer

---

## 3. Dependency Analysis

### Files That Import These Services

| File | Current Import | Will Change To |
|------|---------------|----------------|
| `lib/core/providers.dart` | `import 'camera/camera_service.dart';` | `import '../services/core/camera_service.dart';` |
| `lib/core/providers.dart` | `import 'camera/camera_service_impl.dart';` | `import '../services/core/camera_service_impl.dart';` |
| `lib/core/providers.dart` | `import 'barcode/barcode_scanner_service.dart';` | `import '../services/core/barcode_scanner_service.dart';` |
| `lib/core/providers.dart` | `import 'barcode/barcode_scanner_impl.dart';` | `import '../services/core/barcode_scanner_impl.dart';` |
| `lib/application/audit/audit_session_notifier.dart` | `import '../../core/camera/camera_service.dart';` | `import '../../services/core/camera_service.dart';` |

**Total files affected:** 2

**Internal imports to update:**
- `lib/services/core/camera_service_impl.dart` imports `camera_service.dart` → needs relative path update
- `lib/services/core/barcode_scanner_impl.dart` imports `barcode_scanner_service.dart` → needs relative path update

---

## 4. Move Plan

### Refactor Map

| Old Path | New Path | Type | Reason |
|----------|----------|------|--------|
| `lib/core/camera/camera_service.dart` | `lib/services/core/camera_service.dart` | Move | Align with target architecture - services/core/ for cross-cutting services |
| `lib/core/camera/camera_service_impl.dart` | `lib/services/core/camera_service_impl.dart` | Move | Same as above |
| `lib/core/barcode/barcode_scanner_service.dart` | `lib/services/core/barcode_scanner_service.dart` | Move | Same as above |
| `lib/core/barcode/barcode_scanner_impl.dart` | `lib/services/core/barcode_scanner_impl.dart` | Move | Same as above |

### Directory Creation
- Create: `lib/services/core/` (if doesn't exist)

### Import Updates Required
- **External files to update:** 2
  1. `lib/core/providers.dart` (4 imports to update)
  2. `lib/application/audit/audit_session_notifier.dart` (1 import to update)

- **Internal imports to update:** 2
  1. `lib/services/core/camera_service_impl.dart` - Update relative import of `camera_service.dart`
  2. `lib/services/core/barcode_scanner_impl.dart` - Update relative import of `barcode_scanner_service.dart`

---

## 5. Split Plan

**Not applicable** - All files are well below any threshold. No splitting needed.

---

## 6. Dependency Violations

### Reverse Dependencies Check

✅ **No violations found:**
- `services/core/` → `utils/` ✅ (allowed)
- Other modules can depend on `services/` ✅

### Flutter Import Check

✅ **No Flutter imports in service files:**
- `camera_service.dart`: No `package:flutter` ✅
- `camera_service_impl.dart`: Uses `image_picker` only ✅
- `barcode_scanner_service.dart`: No Flutter ✅
- `barcode_scanner_impl.dart`: Uses `mobile_scanner` only ✅

### 3rd Party Packages
- ✅ **image_picker**: Acceptable in services layer (device/camera access)
- ✅ **mobile_scanner**: Acceptable in services layer (barcode scanning)
- ✅ **dart:async**: Core Dart library ✅

---

## 7. Risk & Test Impact

### Risk Assessment
- **Risk Level:** 🟢 **LOW**
  - Simple file moves with path updates
  - No behavior changes
  - No API changes
  - No dependencies on external services
  - Services are already abstracted with interfaces

### Test Impact
- **Files affected:** 6 files (4 moves + 2 external import updates + 2 internal import updates)
- **Tests:** Currently no tests found (test/ directory is empty)
- **Golden files:** None expected for this module
- **Manual testing:** No impact - pure refactor

### Estimated Diff Size
- **Files changed:** 6 files (4 moves + 2 import updates)
- **Lines changed:** ~8-10 lines (import paths only)
- **Estimated PR size:** Small (~60-80 lines diff)

---

## 8. Preview: New Tree Structure

### After Refactor

```
lib/
├── main.dart
├── core/
│   ├── api/
│   ├── providers.dart        ← UPDATED (imports changed)
│   ├── storage/
│   └── util/                 ← EMPTY (can be removed)
├── services/                 ← NEW
│   └── core/                 ← NEW
│       ├── camera_service.dart         ← MOVED from core/camera/
│       ├── camera_service_impl.dart    ← MOVED from core/camera/
│       ├── barcode_scanner_service.dart    ← MOVED from core/barcode/
│       └── barcode_scanner_impl.dart       ← MOVED from core/barcode/
├── utils/
│   └── result.dart
├── domain/
│   ├── models/
│   └── tags/
├── application/
│   ├── audit/
│   │   └── audit_session_notifier.dart  ← UPDATED (import changed)
│   └── tags/
└── presentation/
    ├── screens/
    └── widgets/
```

### Directory Cleanup
- After move: `lib/core/camera/` directory will be empty
- After move: `lib/core/barcode/` directory will be empty
- **Action:** Delete empty directories after move

---

## 9. Import Path Changes

### Internal Imports (within moved files)

**Before:**
- `camera_service_impl.dart`: `import 'camera_service.dart';`
- `barcode_scanner_impl.dart`: `import 'barcode_scanner_service.dart';`

**After (same directory, no change needed):**
- `camera_service_impl.dart`: `import 'camera_service.dart';` ✅ (same directory)
- `barcode_scanner_impl.dart`: `import 'barcode_scanner_service.dart';` ✅ (same directory)

**Note:** Since all 4 files move to the same directory (`services/core/`), their relative imports remain the same!

### External Imports

**Before:**
- `core/providers.dart`: 
  - `import 'camera/camera_service.dart';`
  - `import 'camera/camera_service_impl.dart';`
  - `import 'barcode/barcode_scanner_service.dart';`
  - `import 'barcode/barcode_scanner_impl.dart';`

**After:**
- `core/providers.dart`:
  - `import '../services/core/camera_service.dart';`
  - `import '../services/core/camera_service_impl.dart';`
  - `import '../services/core/barcode_scanner_service.dart';`
  - `import '../services/core/barcode_scanner_impl.dart';`

**Before:**
- `application/audit/audit_session_notifier.dart`: 
  - `import '../../core/camera/camera_service.dart';`

**After:**
- `application/audit/audit_session_notifier.dart`:
  - `import '../../services/core/camera_service.dart';`

---

## 10. Validation Checklist

### Pre-Refactor Checks
- [x] Files identified: 4 service files
- [x] Size verified: All files appropriately sized (9-42 lines)
- [x] No Flutter imports: ✅ Confirmed
- [x] Dependencies identified: 2 external files + 2 internal imports
- [x] Reverse dependencies: ✅ None (services have no dependencies on other modules except utils/)

### Post-Refactor Checks (to verify after APPLY)
- [ ] Files moved to `lib/services/core/`
- [ ] All 6 imports updated (4 external + 2 internal)
- [ ] Empty `lib/core/camera/` directory deleted
- [ ] Empty `lib/core/barcode/` directory deleted
- [ ] `flutter analyze` passes
- [ ] No broken imports
- [ ] App compiles successfully

---

## 11. Execution Steps (for APPLY phase)

1. **Create target directory:**
   - Create `lib/services/core/` if it doesn't exist

2. **Move files (4 files):**
   - Move `lib/core/camera/camera_service.dart` → `lib/services/core/camera_service.dart`
   - Move `lib/core/camera/camera_service_impl.dart` → `lib/services/core/camera_service_impl.dart`
   - Move `lib/core/barcode/barcode_scanner_service.dart` → `lib/services/core/barcode_scanner_service.dart`
   - Move `lib/core/barcode/barcode_scanner_impl.dart` → `lib/services/core/barcode_scanner_impl.dart`

3. **Update external imports (2 files):**
   - Update `lib/core/providers.dart`:
     - Change: `import 'camera/camera_service.dart';` → `import '../services/core/camera_service.dart';`
     - Change: `import 'camera/camera_service_impl.dart';` → `import '../services/core/camera_service_impl.dart';`
     - Change: `import 'barcode/barcode_scanner_service.dart';` → `import '../services/core/barcode_scanner_service.dart';`
     - Change: `import 'barcode/barcode_scanner_impl.dart';` → `import '../services/core/barcode_scanner_impl.dart';`
   - Update `lib/application/audit/audit_session_notifier.dart`:
     - Change: `import '../../core/camera/camera_service.dart';` → `import '../../services/core/camera_service.dart';`

4. **Verify internal imports:**
   - Check `camera_service_impl.dart`: Should still have `import 'camera_service.dart';` (same directory) ✅
   - Check `barcode_scanner_impl.dart`: Should still have `import 'barcode_scanner_service.dart';` (same directory) ✅

5. **Cleanup:**
   - Delete empty `lib/core/camera/` directory
   - Delete empty `lib/core/barcode/` directory

6. **Verify:**
   - Run `flutter analyze`
   - Verify app compiles
   - Check no broken imports

---

## 12. Expected Outcome

### Files Changed
- ✅ 4 files moved: `core/camera/*` and `core/barcode/*` → `services/core/*`
- ✅ 2 files updated: Import paths fixed
- ✅ 2 directories deleted: `core/camera/` and `core/barcode/` (empty)

### Architecture Compliance
- ✅ Services in correct location: `lib/services/core/`
- ✅ No Flutter imports in services/
- ✅ Services use utils/ ✅
- ✅ Other modules can depend on services/ ✅

### No Breaking Changes
- ✅ Public API unchanged
- ✅ Behavior unchanged
- ✅ Import paths updated consistently
- ✅ All references updated

---

## Summary

**Module 2: Services Module** is a **simple, low-risk refactor**:
- 4 files to move (90 total lines)
- 6 import statements to update (4 external + 2 internal, but 2 internal stay the same)
- No Flutter dependencies
- No behavior changes
- Estimated completion: ~5-10 minutes

**Recommendation:** ✅ **SAFE TO PROCEED** - This module is straightforward and builds on Module 1.

---

**Next:** After Module 2 is complete, proceed to Module 3: Data Module.

