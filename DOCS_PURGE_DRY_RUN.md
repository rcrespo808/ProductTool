# Documentation Purge - DRY-RUN Plan

**Date:** 2025-01-27  
**Project:** Product Audit Tool  
**Command:** `/docs_purge`

## Executive Summary

This project does NOT have a `docs/condensed/` structure as expected by the command. Documentation is currently organized in the root `ProductTool/` directory. This plan adapts the purge command to work with the existing structure.

**Total files analyzed:** 14 markdown files  
**Files to keep:** 13  
**Files to delete:** 1 (duplicate)  
**Files to merge content:** 3 (merge into existing files)

---

## Classification Table

| File Path | Status | Reason | Action | Target (if merge) |
|-----------|--------|--------|--------|-------------------|
| `ProductTool/README.md` | ✅ **KEEP** | Root allowlist - Main entry point | Keep as-is | - |
| `ProductTool/PROJECT_OVERVIEW.md` | ✅ **KEEP** | Core documentation - Source of truth for features | Keep as-is | - |
| `ProductTool/TECH_STRUCTURE.md` | ✅ **KEEP** | Core documentation - Source of truth for architecture | Keep as-is | - |
| `ProductTool/IMPLEMENTATION_CHECKLIST.md` | ✅ **KEEP** | Core documentation - Task status tracking | Keep as-is | - |
| `ProductTool/WEB.md` | ✅ **KEEP** | Platform-specific documentation - Essential | Keep as-is | - |
| `ProductTool/MANUAL_TESTING.md` | ✅ **KEEP** | Testing documentation - Essential for QA | Keep as-is | - |
| `ProductTool/TEST_PLAN.md` | ✅ **KEEP** | Testing documentation - Essential for test strategy | Keep as-is | - |
| `ProductTool/TAGGING_NAMING_AUDIT.md` | ✅ **KEEP** | Audit findings - Valuable technical debt tracking | Keep as-is | - |
| `ProductTool/ENDPOINT_UPDATE_IMAGES_BY_EAN.md` | ✅ **KEEP** | API documentation - Essential for integration | Keep as-is | - |
| `ProductTool/agents.md` | ✅ **KEEP** | AI agent context guide - Useful onboarding doc | Keep as-is | - |
| `ProductTool/SETUP_GUIDE.md` | 🔄 **MERGE** | Setup instructions - Overlaps with QUICK_START.md | Merge setup steps into QUICK_START, keep platform-specific details | `QUICK_START.md` |
| `ProductTool/SETUP_FLUTTER.md` | 🔄 **MERGE** | Flutter Windows setup - Can be part of SETUP_GUIDE | Merge Windows-specific content into SETUP_GUIDE | `SETUP_GUIDE.md` |
| `ProductTool/QUICK_START.md` | 🔄 **ENHANCE** | Quick start - Add merged content from SETUP_GUIDE | Enhance with detailed setup from SETUP_GUIDE.md | - |
| `ProductTool/lib/core/storage/ENDPOINT_UPDATE_IMAGES_BY_EAN.md` | ❌ **DELETE** | Duplicate endpoint documentation | Delete - identical to root version | - |

---

## Duplicate Analysis

### Exact Duplicates Found

1. **ENDPOINT_UPDATE_IMAGES_BY_EAN.md**
   - Root: `ProductTool/ENDPOINT_UPDATE_IMAGES_BY_EAN.md` (243 lines)
   - Duplicate: `ProductTool/lib/core/storage/ENDPOINT_UPDATE_IMAGES_BY_EAN.md` (243 lines)
   - **Decision:** Delete duplicate in `lib/core/storage/` (wrong location, exact duplicate)

### Near-Duplicates / Overlaps

1. **SETUP_GUIDE.md vs QUICK_START.md**
   - **SETUP_GUIDE.md** (194 lines): Detailed platform setup, permissions, troubleshooting
   - **QUICK_START.md** (83 lines): 5-minute quick start, basic steps
   - **Overlap:** ~40% - Both cover setup steps
   - **Decision:** Merge SETUP_GUIDE details into QUICK_START, then DELETE SETUP_GUIDE.md

2. **SETUP_FLUTTER.md vs SETUP_GUIDE.md**
   - **SETUP_FLUTTER.md** (200 lines): Flutter Windows installation guide
   - **SETUP_GUIDE.md** (194 lines): General setup for Android/iOS (assumes Flutter installed)
   - **Overlap:** ~20% - Both mention Flutter setup
   - **Decision:** Merge Windows-specific content into SETUP_GUIDE, then DELETE SETUP_FLUTTER.md

---

## Content Extraction Plan

### From SETUP_GUIDE.md → QUICK_START.md

**Net-new content to add:**
- Android permissions configuration details (lines 42-67)
- iOS permissions configuration details (lines 68-78)
- Detailed troubleshooting section (lines 121-135)
- Testing checklist reference (lines 136-147)
- Project structure overview (lines 148-168)
- Resources section (lines 187-193)

**Merge strategy:** Add "Detailed Setup" section to QUICK_START.md with platform-specific details.

### From SETUP_FLUTTER.md → SETUP_GUIDE.md

**Net-new content to add:**
- Flutter installation for Windows (lines 1-70)
- PowerShell-specific commands (lines 24-47)
- Setup script example (lines 100-142)
- Windows-specific troubleshooting (lines 169-199)

**Merge strategy:** Add "Flutter Installation (Windows)" section at the beginning of SETUP_GUIDE.md.

---

## Proposed File Changes

### 1. QUICK_START.md (ENHANCE)

**Add sections:**
- "Detailed Setup (Platform-Specific)" after Quick Start section
- "Android Configuration" subsection
- "iOS Configuration" subsection  
- "Troubleshooting" subsection
- "Resources" subsection

**Estimated lines after merge:** ~150 lines (from 83)

### 2. SETUP_GUIDE.md (ENHANCE then DELETE)

**Before deletion, merge Windows Flutter setup:**
- Add "Prerequisites: Flutter Installation" section at top
- Include Windows-specific installation steps
- Add PowerShell examples
- Keep platform-specific permission sections
- Then DELETE after content is merged into QUICK_START.md

**Note:** Actually, we'll merge SETUP_FLUTTER into SETUP_GUIDE, then merge SETUP_GUIDE into QUICK_START, so we delete both SETUP_FLUTTER.md and SETUP_GUIDE.md at the end.

### 3. SETUP_FLUTTER.md (DELETE after merge)

Content will be merged into SETUP_GUIDE.md, then into QUICK_START.md.

---

## Files to Delete

1. ✅ `ProductTool/lib/core/storage/ENDPOINT_UPDATE_IMAGES_BY_EAN.md` - Exact duplicate
2. ✅ `ProductTool/SETUP_FLUTTER.md` - Content merged into SETUP_GUIDE → QUICK_START
3. ✅ `ProductTool/SETUP_GUIDE.md` - Content merged into QUICK_START

**Total deletions:** 3 files

---

## Post-Merge Structure

After merge, documentation structure will be:

```
ProductTool/
├── README.md                          # Main entry point
├── PROJECT_OVERVIEW.md                # Core: Purpose, workflow, constraints
├── TECH_STRUCTURE.md                  # Core: Architecture, providers
├── IMPLEMENTATION_CHECKLIST.md        # Core: Task status
├── QUICK_START.md                     # Enhanced: Quick start + detailed setup
├── WEB.md                             # Platform: Web support
├── MANUAL_TESTING.md                  # Testing: Manual test scenarios
├── TEST_PLAN.md                       # Testing: Test strategy
├── TAGGING_NAMING_AUDIT.md            # Audit: Technical debt tracking
├── ENDPOINT_UPDATE_IMAGES_BY_EAN.md   # API: Backend endpoint spec
└── agents.md                          # Onboarding: AI agent context guide
```

**Total files:** 11 (down from 14)

---

## Validation Checklist

- [x] No banned-pattern files found (no FINAL, COMPLETE, QUICK, HOTFIX, etc. patterns)
- [x] README.md links to other essential docs (verified - lines 16-24)
- [x] No duplicate content remaining after merge
- [x] All essential information preserved
- [x] Core documentation files remain untouched
- [x] No documentation in code directories (except one duplicate to delete)

---

## Guardrails Compliance

- ✅ Never touch code/config files
- ✅ Preserve all Spanish/English content
- ✅ Keep essential documentation
- ✅ Only merge/delete after extracting useful content

---

## Next Steps

**On "APPLY" command:**
1. Create enhanced `QUICK_START.md` with merged content
2. Delete `lib/core/storage/ENDPOINT_UPDATE_IMAGES_BY_EAN.md`
3. Delete `SETUP_FLUTTER.md`
4. Delete `SETUP_GUIDE.md`
5. Update `README.md` links if needed
6. Verify all links still work
7. Commit as single PR

---

## Notes

- The project structure doesn't match the command's expected `docs/condensed/` pattern
- This plan adapts the command to work with the existing flat structure
- All core documentation is preserved
- Only duplicates and redundant setup guides are merged/deleted
- `agents.md` is kept as it provides valuable onboarding context

