# AI Agents Context Guide - Product Audit Tool

This document provides AI agents and developers with a comprehensive guide to accessing project documentation, understanding context, and locating task definitions.

---

## 📚 Documentation Structure

### Root-Level Documentation (`ProductTool/`)

All project documentation is located in the root directory alongside `lib/` and `pubspec.yaml`.

#### Core Project Documentation

| File | Purpose | When to Read |
|------|---------|--------------|
| **`README.md`** | Project overview and quick start guide | **Start here** - First document to read for general understanding |
| **`PROJECT_OVERVIEW.md`** | Purpose, workflow, naming conventions, tag system | Essential for understanding **what** the app does and **how** it works |
| **`TECH_STRUCTURE.md`** | Architecture, folder structure, providers, abstractions | Essential for understanding **how** the code is organized |
| **`IMPLEMENTATION_CHECKLIST.md`** | Implementation status and checklist items | Check before starting work - shows what's done and what's pending |

#### Setup & Configuration

| File | Purpose | When to Read |
|------|---------|--------------|
| **`QUICK_START.md`** | Quick start guide with Flutter installation and setup | Start here - Complete setup instructions for all platforms |
| **`WEB.md`** | Web platform support and limitations | When working on web-specific features |

#### Testing & Quality

| File | Purpose | When to Read |
|------|---------|--------------|
| **`TEST_PLAN.md`** | Testing strategy and required test suites | Before writing tests - defines test requirements |
| **`MANUAL_TESTING.md`** | Manual testing scenarios and checklist | For manual QA testing |
| **`TAGGING_NAMING_AUDIT.md`** | Comprehensive audit of tagging/naming system | When working on tag/file naming features |

#### API & Integration

| File | Purpose | When to Read |
|------|---------|--------------|
| **`ENDPOINT_UPDATE_IMAGES_BY_EAN.md`** | Backend endpoint specification | When implementing backend integration |

---

## 🗂️ Code Organization Context

### Directory Structure

```
ProductTool/
├── lib/
│   ├── main.dart                 # App entry point, theme configuration
│   │
│   ├── presentation/             # Flutter UI layer
│   │   ├── screens/
│   │   │   ├── home_screen.dart
│   │   │   ├── barcode_scan_screen.dart (platform router)
│   │   │   ├── barcode_scan_screen_mobile.dart
│   │   │   ├── barcode_scan_screen_mobile_wrapper.dart
│   │   │   ├── barcode_scan_screen_web.dart
│   │   │   └── tag_capture_screen.dart
│   │   └── widgets/
│   │       ├── components/       # Reusable UI components
│   │       │   ├── info_chip.dart
│   │       │   ├── session_info_bar.dart
│   │       │   ├── selected_tags_section.dart
│   │       │   └── tag_action_buttons.dart
│   │       ├── tag_autocomplete_input.dart
│   │       └── tag_chip_cloud.dart
│   │
│   ├── providers/                # Riverpod state management
│   │   ├── audit/
│   │   │   └── audit_session_notifier.dart  # Main session state logic
│   │   ├── tags/
│   │   │   └── tag_suggestions_notifier.dart
│   │   └── providers.dart        # Provider definitions
│   │
│   ├── domain/                   # Pure business logic (no Flutter)
│   │   ├── models/
│   │   │   ├── audit_image.dart
│   │   │   ├── audit_session.dart
│   │   │   ├── file_naming.dart  # File naming utilities & sanitization
│   │   │   └── api/              # API request/response models (not yet implemented)
│   │   └── tags/
│   │       └── tag_trie.dart     # Pure tag trie data structure
│   │
│   ├── data/                     # Data layer (repositories & API clients, no Flutter)
│   │   ├── api/
│   │   │   └── audit_api_client.dart  # Backend API abstraction (fake impl exists)
│   │   └── repositories/
│   │       ├── tag_repository.dart
│   │       ├── local_storage_service.dart
│   │       ├── local_storage_impl_mobile.dart
│   │       ├── local_storage_impl_web.dart
│   │       ├── local_storage_impl_stub.dart
│   │       └── local_storage_impl.dart
│   │
│   ├── services/                 # Cross-cutting services (no Flutter)
│   │   └── core/
│   │       ├── camera_service.dart
│   │       ├── camera_service_impl.dart
│   │       ├── barcode_scanner_service.dart
│   │       └── barcode_scanner_impl.dart
│   │
│   └── utils/                    # Pure utilities
│       └── result.dart           # Result<T> error handling pattern
│
├── docs/                         # Documentation
│   └── structure/
│       └── REFMAP-20250127.md   # Refactoring map (file moves)
├── test/                         # Unit & widget tests (currently empty)
├── web/                          # Web-specific configuration
└── [documentation .md files]
```

### Key Architectural Patterns

1. **Clean Architecture**: Domain → Application → Presentation layers
2. **Dependency Injection**: Riverpod providers for all services
3. **Abstraction First**: All services have abstract interfaces, implementations are platform-specific
4. **Result Pattern**: Error handling using `Result<T>` instead of exceptions
5. **Platform Detection**: Conditional imports for mobile/web implementations

---

## 📋 Task Definitions & Status

### Where Tasks Are Defined

#### Primary Task Source: `IMPLEMENTATION_CHECKLIST.md`

This file contains the main implementation checklist organized by feature area:
- ✅ Completed items are marked with `[x]`
- ⬜ Pending items are marked with `[ ]`
- Status summary at bottom shows overall completion

**Structure:**
1. Project Setup
2. Core Domain
3. Tag Trie System
4. Services (Camera, Barcode, Storage, API)
5. Application Layer
6. UI Layer
7. Local Persistence
8. Web Support
9. Optional UI Enhancements
10. API Integration
11. Ready for Iteration 2

#### Test Tasks: `TEST_PLAN.md`

Defines required test suites:
- Tag Trie Tests
- File Naming Tests
- AuditSessionNotifier Tests
- TagSuggestionsNotifier Tests
- Service Abstraction Tests
- UI Tests
- Integration Tests

#### Audit Findings: `TAGGING_NAMING_AUDIT.md`

Contains prioritized issues and recommendations:
- Critical issues (high priority)
- Medium priority improvements
- Low priority enhancements

---

## 🎯 Context Access Patterns

### When Starting a New Feature

1. **Read** `PROJECT_OVERVIEW.md` to understand the feature's purpose
2. **Read** `TECH_STRUCTURE.md` to understand where code should go
3. **Check** `IMPLEMENTATION_CHECKLIST.md` for existing tasks
4. **Review** `TEST_PLAN.md` for testing requirements
5. **Examine** existing similar code in `lib/` for patterns

### When Fixing a Bug

1. **Check** relevant documentation in root `.md` files
2. **Review** audit files (`TAGGING_NAMING_AUDIT.md`) for known issues
3. **Examine** `IMPLEMENTATION_CHECKLIST.md` to see if bug relates to incomplete features
4. **Check** `MANUAL_TESTING.md` for test scenarios that might have caught the bug

### When Adding Tests

1. **Read** `TEST_PLAN.md` for test requirements
2. **Check** `IMPLEMENTATION_CHECKLIST.md` for test status
3. **Examine** existing test structure (if any) in `test/` directory
4. **Review** `MANUAL_TESTING.md` for manual test scenarios to automate

### When Working on API Integration

1. **Read** `ENDPOINT_UPDATE_IMAGES_BY_EAN.md` for endpoint specification
2. **Check** `PROJECT_OVERVIEW.md` for integration requirements
3. **Review** `lib/core/api/audit_api_client.dart` for existing API abstraction
4. **Examine** `TECH_STRUCTURE.md` for API client architecture

---

## 🔍 Finding Specific Information

### File Naming & Tagging System
- **Overview**: `PROJECT_OVERVIEW.md` → "Naming Convention" section
- **Detailed Audit**: `TAGGING_NAMING_AUDIT.md`
- **Implementation**: `lib/domain/models/file_naming.dart`
- **Usage**: `lib/providers/audit/audit_session_notifier.dart`

### Tag System & Trie
- **Overview**: `PROJECT_OVERVIEW.md` → "Tag System" section
- **Architecture**: `TECH_STRUCTURE.md` → "Domain Models" section
- **Implementation**: `lib/domain/tags/`
- **UI Integration**: `lib/presentation/widgets/tag_*.dart`

### State Management
- **Architecture**: `TECH_STRUCTURE.md` → "Providers" section
- **Providers**: `lib/providers/providers.dart`
- **Application Logic**: `lib/providers/` (audit/, tags/)

### Platform-Specific Code
- **Web Support**: `WEB.md`
- **Setup**: `QUICK_START.md` for all platforms, `WEB.md` for web-specific details
- **Implementation**: Conditional imports in `lib/data/repositories/`, `lib/services/core/`, etc.

---

## 🚀 Workflow Guidelines

### Before Making Changes

1. ✅ Read relevant documentation (see Context Access Patterns above)
2. ✅ Check `IMPLEMENTATION_CHECKLIST.md` for existing tasks
3. ✅ Review similar existing code for patterns
4. ✅ Understand the architecture from `TECH_STRUCTURE.md`

### During Implementation

1. ✅ Follow existing code patterns and abstractions
2. ✅ Use `Result<T>` pattern for error handling
3. ✅ Add providers in `lib/providers/providers.dart`
4. ✅ Keep services abstracted (interface + implementation)
5. ✅ Update `IMPLEMENTATION_CHECKLIST.md` when tasks complete

### After Implementation

1. ✅ Update `IMPLEMENTATION_CHECKLIST.md` with completed tasks
2. ✅ Add tests per `TEST_PLAN.md` requirements
3. ✅ Update documentation if architecture changes significantly
4. ✅ Verify manual testing scenarios in `MANUAL_TESTING.md` still pass

---

## 📝 Documentation Standards

### When to Update Documentation

- **DO** update when:
  - Architecture changes significantly
  - New features are added (update checklist)
  - Bugs reveal documentation gaps
  - API contracts change

- **DON'T** update when:
  - Making minor implementation changes
  - Refactoring without changing behavior
  - Fixing typos or formatting (unless critical)

### Documentation Hierarchy

1. **README.md** - Entry point, references other docs
2. **PROJECT_OVERVIEW.md** - Source of truth for features
3. **TECH_STRUCTURE.md** - Source of truth for architecture
4. **IMPLEMENTATION_CHECKLIST.md** - Source of truth for task status
5. **Other docs** - Supporting/specialized documentation

---

## 🎨 Code Conventions Reference

### From Documentation

- **Naming Convention**: See `PROJECT_OVERVIEW.md` → "Naming Convention"
- **Tag System**: See `PROJECT_OVERVIEW.md` → "Tag System"
- **Service Abstractions**: See `TECH_STRUCTURE.md` → "Key Abstractions"
- **State Management**: See `TECH_STRUCTURE.md` → "Providers"

### From Codebase Patterns

- Error handling: Use `Result<T>` from `lib/utils/result.dart`
- Platform detection: Use conditional imports
- Service pattern: Abstract interface + implementation(s)
- State management: Riverpod `StateNotifier` for complex state

---

## 🔗 Quick Reference Links

### Essential Reading Order for New Agents

1. `README.md` (5 min) - Overview
2. `PROJECT_OVERVIEW.md` (10 min) - What & Why
3. `TECH_STRUCTURE.md` (15 min) - How
4. `IMPLEMENTATION_CHECKLIST.md` (5 min) - Status
5. Explore `lib/` structure (10 min) - Code walkthrough

### For Specific Features

- **Tag System**: `PROJECT_OVERVIEW.md` + `lib/domain/tags/`
- **File Naming**: `PROJECT_OVERVIEW.md` + `lib/domain/models/file_naming.dart`
- **UI Components**: `TECH_STRUCTURE.md` + `lib/presentation/`
- **API Integration**: `ENDPOINT_UPDATE_IMAGES_BY_EAN.md` + `lib/data/api/`

---

## 🐛 Known Issues & Audits

### Active Issues

See `TAGGING_NAMING_AUDIT.md` for comprehensive issue list:
- Critical issues (should be fixed first)
- Medium priority (important improvements)
- Low priority (nice-to-have)

### Completed Fixes

- ✅ Tag normalization consistency
- ✅ File naming format with separators
- ✅ Case-insensitive duplicate detection
- ✅ Text visibility issues
- ✅ Error handling improvements

---

## 📞 Getting Help

### For Architecture Questions
→ Check `TECH_STRUCTURE.md` first

### For Feature Requirements
→ Check `PROJECT_OVERVIEW.md` first

### For Task Status
→ Check `IMPLEMENTATION_CHECKLIST.md` first

### For Testing Requirements
→ Check `TEST_PLAN.md` first

### For Setup Issues
→ Check `QUICK_START.md`

---

**Last Updated**: 2025-01-27  
**Project Phase**: Iteration 1 Complete, Iteration 2 In Progress


