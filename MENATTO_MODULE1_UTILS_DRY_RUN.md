# /menatto — Module 1: Utils Module — DRY-RUN

**Date:** 2025-01-27  
**Module:** Utils Module  
**Scope:** `lib/core/util/` → `lib/utils/`

---

## 1. Inventory & Size Map

| File Path | Lines | Status | Notes |
|-----------|-------|--------|-------|
| `lib/core/util/result.dart` | 37 | ✅ OK | Pure utility, no Flutter imports |

**Summary:**
- **Total files:** 1
- **Total lines:** 37
- **Threshold:** No threshold for utils (pure utilities)
- **Status:** ✅ File is appropriately sized

---

## 2. Misplacement Scan

### Current Location
- `lib/core/util/result.dart` ❌ **MISPLACED**

### Target Location (per architecture)
- Should be in: `lib/utils/result.dart`

### Analysis

**File:** `lib/core/util/result.dart`
- ✅ **No Flutter imports** - Pure Dart code
- ✅ **No Widget/BuildContext** - Utility type definitions
- ✅ **Pure utility** - Result<T> sealed class for error handling
- ✅ **No business logic** - Generic utility type

**Violations:**
- ❌ **Wrong directory**: File is in `core/util/` but should be in `utils/` according to target architecture
- ✅ **No Flutter dependency**: Confirmed no `package:flutter` imports

---

## 3. Dependency Analysis

### Files That Import `result.dart`

| File | Current Import | Will Change To |
|------|---------------|----------------|
| `lib/presentation/screens/tag_capture_screen.dart` | `import '../../core/util/result.dart';` | `import '../../utils/result.dart';` |
| `lib/application/audit/audit_session_notifier.dart` | `import '../../core/util/result.dart';` | `import '../../utils/result.dart';` |
| `lib/domain/tags/tag_repository.dart` | `import '../../core/util/result.dart';` | `import '../../utils/result.dart';` |

**Total files affected:** 3

---

## 4. Move Plan

### Refactor Map

| Old Path | New Path | Type | Reason |
|----------|----------|------|--------|
| `lib/core/util/result.dart` | `lib/utils/result.dart` | Move | Align with target architecture - utils/ for pure utilities |

### Directory Creation
- Create: `lib/utils/` (if doesn't exist)

### Import Updates Required
- **Files to update:** 3
  1. `lib/presentation/screens/tag_capture_screen.dart`
  2. `lib/application/audit/audit_session_notifier.dart`
  3. `lib/domain/tags/tag_repository.dart`

---

## 5. Split Plan

**Not applicable** - File is 37 lines, well below any threshold. No splitting needed.

---

## 6. Dependency Violations

### Reverse Dependencies Check

✅ **No violations found:**
- `utils/` → (nothing) - Utils should not depend on other modules
- Other modules can depend on `utils/` ✅

### Flutter Import Check

✅ **No Flutter imports in result.dart:**
```dart
// Verified: No `package:flutter` imports
// File contains only:
// - sealed class Result<T>
// - Success/Failure classes
// - Extension methods
```

---

## 7. Risk & Test Impact

### Risk Assessment
- **Risk Level:** 🟢 **LOW**
  - Simple file move with path update
  - No behavior changes
  - No API changes
  - No dependencies on external services

### Test Impact
- **Files affected:** 3 import statements
- **Tests:** Currently no tests found (test/ directory is empty)
- **Golden files:** None expected for this module
- **Manual testing:** No impact - pure refactor

### Estimated Diff Size
- **Files changed:** 4 files (1 move + 3 import updates)
- **Lines changed:** ~6-9 lines (import paths only)
- **Estimated PR size:** Small (~50 lines diff)

---

## 8. Preview: New Tree Structure

### After Refactor

```
lib/
├── main.dart
├── core/
│   ├── api/
│   ├── barcode/
│   ├── camera/
│   ├── providers.dart
│   └── storage/
│       └── (util/ removed)
├── utils/                    # ← NEW
│   └── result.dart          # ← MOVED from core/util/
├── domain/
│   ├── models/
│   └── tags/
├── application/
│   ├── audit/
│   └── tags/
└── presentation/
    ├── screens/
    └── widgets/
```

### Directory Cleanup
- After move: `lib/core/util/` directory will be empty
- **Action:** Delete empty `lib/core/util/` directory after move

---

## 9. Validation Checklist

### Pre-Refactor Checks
- [x] File identified: `lib/core/util/result.dart`
- [x] Size verified: 37 lines (appropriate)
- [x] No Flutter imports: ✅ Confirmed
- [x] Dependencies identified: 3 files import this
- [x] Reverse dependencies: ✅ None (utils has no dependencies)

### Post-Refactor Checks (to verify after APPLY)
- [ ] File moved to `lib/utils/result.dart`
- [ ] All 3 imports updated
- [ ] Empty `lib/core/util/` directory deleted
- [ ] `flutter analyze` passes
- [ ] No broken imports
- [ ] App compiles successfully

---

## 10. Execution Steps (for APPLY phase)

1. **Create target directory:**
   - Create `lib/utils/` if it doesn't exist

2. **Move file:**
   - Move `lib/core/util/result.dart` → `lib/utils/result.dart`

3. **Update imports (3 files):**
   - Update `lib/presentation/screens/tag_capture_screen.dart`
   - Update `lib/application/audit/audit_session_notifier.dart`
   - Update `lib/domain/tags/tag_repository.dart`
   - Change: `import '../../core/util/result.dart';` → `import '../../utils/result.dart';`

4. **Cleanup:**
   - Delete empty `lib/core/util/` directory

5. **Verify:**
   - Run `flutter analyze`
   - Verify app compiles
   - Check no broken imports

---

## 11. Expected Outcome

### Files Changed
- ✅ 1 file moved: `core/util/result.dart` → `utils/result.dart`
- ✅ 3 files updated: Import paths fixed
- ✅ 1 directory deleted: `core/util/` (empty)

### Architecture Compliance
- ✅ Utils in correct location: `lib/utils/`
- ✅ No Flutter imports in utils/
- ✅ Utils have no dependencies
- ✅ Other modules can depend on utils/ ✅

### No Breaking Changes
- ✅ Public API unchanged
- ✅ Behavior unchanged
- ✅ Import paths updated consistently
- ✅ All references updated

---

## Summary

**Module 1: Utils Module** is a **simple, low-risk refactor**:
- 1 file to move (37 lines)
- 3 import statements to update
- No Flutter dependencies
- No behavior changes
- Estimated completion: ~5 minutes

**Recommendation:** ✅ **SAFE TO PROCEED** - This is the simplest module and should be done first as a foundation for other modules.

---

**Next:** After Module 1 is complete, proceed to Module 2: Services Module.

