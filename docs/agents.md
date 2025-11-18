# AI Agents Context Guide - Product Audit Tool

This document provides AI agents and developers with a comprehensive guide to accessing project documentation, understanding context, and locating task definitions.

---

## 📚 Documentation Structure

### Documentation Location (`ProductTool/docs/`)

All project documentation is located in the `docs/` directory. The `README.md` file remains in the root directory as the entry point.

#### Core Project Documentation

| File | Purpose | When to Read |
|------|---------|--------------|
| **`README.md`** (root) | Project overview and quick start guide | **Start here** - First document to read for general understanding |
| **`docs/PROJECT_OVERVIEW.md`** | Purpose, workflow, naming conventions, and implementation status | Essential for understanding **what** the app does, **how** it works, and current status |
| **`docs/TECH_STRUCTURE.md`** | Architecture, folder structure, providers, abstractions | Essential for understanding **how** the code is organized |

#### Setup & Configuration

| File | Purpose | When to Read |
|------|---------|--------------|
| **`docs/QUICK_START.md`** | Quick start guide with Flutter installation and setup | Start here - Complete setup instructions for all platforms |
| **`docs/WEB.md`** | Web platform support and limitations | When working on web-specific features |

#### Testing & Quality

| File | Purpose | When to Read |
|------|---------|--------------|
| **`docs/TEST_PLAN.md`** | Testing strategy, required test suites, and manual testing scenarios | Before writing tests - defines test requirements and manual QA scenarios |

#### API & Integration

| File | Purpose | When to Read |
|------|---------|--------------|
| **`docs/ENDPOINT_UPDATE_IMAGES_BY_EAN.md`** | Backend endpoint specification | When implementing backend integration |

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
│   │   │   └── photo_capture_screen.dart
│   │   └── widgets/
│   │       └── components/       # Reusable UI components
│   │           ├── info_chip.dart
│   │           └── session_info_bar.dart
│   │
│   ├── providers/                # Riverpod state management
│   │   ├── audit/
│   │   │   └── audit_session_notifier.dart  # Main session state logic
│   │   └── providers.dart        # Provider definitions
│   │
│   ├── domain/                   # Pure business logic (no Flutter)
│   │   └── models/
│   │       ├── audit_image.dart
│   │       ├── audit_session.dart
│   │       ├── audit_session_status.dart  # Status enum (inProgress, completed)
│   │       ├── file_naming.dart  # File naming utilities (1-based sequential: {barcode}__{index}.jpg)
│   │       └── api/              # API request/response models (not yet implemented)
│   │
│   ├── data/                     # Data layer (repositories & API clients, no Flutter)
│   │   ├── api/
│   │   │   └── audit_api_client.dart  # Backend API abstraction (fake impl exists)
│   │   └── repositories/
│   │       ├── local_storage_service.dart
│   │       ├── local_storage_impl_mobile.dart
│   │       ├── local_storage_impl_web.dart
│   │       ├── local_storage_impl_stub.dart
│   │       ├── local_storage_impl.dart
│   │       ├── session_repository.dart  # Completed session persistence
│   │       └── session_repository_impl.dart
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
│   ├── PROJECT_OVERVIEW.md
│   ├── TECH_STRUCTURE.md
│   ├── QUICK_START.md
│   ├── WEB.md
│   ├── TEST_PLAN.md
│   ├── ENDPOINT_UPDATE_IMAGES_BY_EAN.md
│   └── agents.md
├── test/                         # Unit & widget tests (currently empty)
├── web/                          # Web-specific configuration
└── README.md                     # Entry point documentation
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

#### Primary Task Source: `docs/PROJECT_OVERVIEW.md`

The implementation status section in `docs/PROJECT_OVERVIEW.md` shows:
- ✅ Completed iterations and features
- ⬜ Next steps for future iterations

#### Test Tasks: `docs/TEST_PLAN.md`

Defines required test suites:
- Tag Trie Tests
- File Naming Tests
- AuditSessionNotifier Tests
- TagSuggestionsNotifier Tests
- Service Abstraction Tests
- UI Tests
- Integration Tests


---

## 🎯 Context Access Patterns

### When Starting a New Feature

1. **Read** `docs/PROJECT_OVERVIEW.md` to understand the feature's purpose and current status
2. **Read** `docs/TECH_STRUCTURE.md` to understand where code should go
3. **Review** `docs/TEST_PLAN.md` for testing requirements
4. **Examine** existing similar code in `lib/` for patterns

### When Fixing a Bug

1. **Check** relevant documentation in `docs/` directory
2. **Examine** `docs/PROJECT_OVERVIEW.md` to see if bug relates to incomplete features
3. **Check** `docs/TEST_PLAN.md` for test scenarios that might have caught the bug

### When Adding Tests

1. **Read** `docs/TEST_PLAN.md` for test requirements and manual scenarios
2. **Examine** existing test structure (if any) in `test/` directory
3. **Review** manual testing scenarios in `docs/TEST_PLAN.md` to automate

### When Working on API Integration

1. **Read** `docs/ENDPOINT_UPDATE_IMAGES_BY_EAN.md` for endpoint specification
2. **Check** `docs/PROJECT_OVERVIEW.md` for integration requirements
3. **Review** `lib/data/api/audit_api_client.dart` for existing API abstraction
4. **Examine** `docs/TECH_STRUCTURE.md` for API client architecture

---

## 🔍 Finding Specific Information

### File Naming System
- **Overview**: `docs/PROJECT_OVERVIEW.md` → "Naming Convention" section
- **Format**: `{barcode}__{index}.jpg` (sequential naming, no tags)
- **Implementation**: `lib/domain/models/file_naming.dart`
- **Usage**: `lib/providers/audit/audit_session_notifier.dart`

### State Management
- **Architecture**: `docs/TECH_STRUCTURE.md` → "Providers" section
- **Providers**: `lib/providers/providers.dart`
- **Application Logic**: `lib/providers/audit/` (audit session only)

### Platform-Specific Code
- **Web Support**: `docs/WEB.md`
- **Setup**: `docs/QUICK_START.md` for all platforms, `docs/WEB.md` for web-specific details
- **Implementation**: Conditional imports in `lib/data/repositories/`, `lib/services/core/`, etc.

---

## 🚀 Workflow Guidelines

### Before Making Changes

1. ✅ Read relevant documentation (see Context Access Patterns above)
2. ✅ Check `docs/PROJECT_OVERVIEW.md` for current status and tasks
3. ✅ Review similar existing code for patterns
4. ✅ Understand the architecture from `docs/TECH_STRUCTURE.md`

### During Implementation

1. ✅ Follow existing code patterns and abstractions
2. ✅ Use `Result<T>` pattern for error handling
3. ✅ Add providers in `lib/providers/providers.dart` (no tag providers needed)
4. ✅ Keep services abstracted (interface + implementation)
5. ✅ Update `docs/PROJECT_OVERVIEW.md` when significant milestones complete

### After Implementation

1. ✅ Update `docs/PROJECT_OVERVIEW.md` with completed milestones
2. ✅ Add tests per `docs/TEST_PLAN.md` requirements
3. ✅ Update documentation if architecture changes significantly
4. ✅ Verify manual testing scenarios in `docs/TEST_PLAN.md` still pass

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

1. **README.md** (root) - Entry point, references other docs
2. **docs/PROJECT_OVERVIEW.md** - Source of truth for features and implementation status
3. **docs/TECH_STRUCTURE.md** - Source of truth for architecture
4. **docs/TEST_PLAN.md** - Source of truth for testing requirements
5. **Other docs** - Supporting/specialized documentation

---

## 🎨 Code Conventions Reference

### From Documentation

- **Naming Convention**: See `docs/PROJECT_OVERVIEW.md` → "Naming Convention"
- **Tag System**: See `docs/PROJECT_OVERVIEW.md` → "Tag System"
- **Service Abstractions**: See `docs/TECH_STRUCTURE.md` → "Key Abstractions"
- **State Management**: See `docs/TECH_STRUCTURE.md` → "Providers"

### From Codebase Patterns

- Error handling: Use `Result<T>` from `lib/utils/result.dart`
- Platform detection: Use conditional imports
- Service pattern: Abstract interface + implementation(s)
- State management: Riverpod `StateNotifier` for complex state

---

## 🔗 Quick Reference Links

### Essential Reading Order for New Agents

1. `README.md` (5 min) - Overview
2. `docs/PROJECT_OVERVIEW.md` (10 min) - What & Why & Status
3. `docs/TECH_STRUCTURE.md` (15 min) - How
4. `docs/TEST_PLAN.md` (5 min) - Testing requirements
5. Explore `lib/` structure (10 min) - Code walkthrough

### For Specific Features

- **File Naming**: `docs/PROJECT_OVERVIEW.md` + `lib/domain/models/file_naming.dart`
- **UI Components**: `docs/TECH_STRUCTURE.md` + `lib/presentation/`
- **API Integration**: `docs/ENDPOINT_UPDATE_IMAGES_BY_EAN.md` + `lib/data/api/`

---

## 🐛 Known Issues & Audits


---

## 📞 Getting Help

### For Architecture Questions
→ Check `docs/TECH_STRUCTURE.md` first

### For Feature Requirements
→ Check `docs/PROJECT_OVERVIEW.md` first

### For Task Status
→ Check `docs/PROJECT_OVERVIEW.md` implementation status section first

### For Testing Requirements
→ Check `docs/TEST_PLAN.md` first

### For Setup Issues
→ Check `docs/QUICK_START.md`

---

**Last Updated**: 2025-01-27  
**Project Phase**: Iteration 1 Complete, Iteration 2 In Progress


