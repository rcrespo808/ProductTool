# Implementation Checklist (for coding agents)

This is the step-by-step execution list to build iteration 1.

---

# 1. Project Setup
- [ ] Create Flutter project
- [ ] Add dependencies:
  - camera or image_picker
  - mobile_scanner / MLKit
  - riverpod
  - shared_preferences
  - path_provider
- [ ] Setup folder structure per TECH_STRUCTURE.md

---

# 2. Core Domain
- [ ] Implement `AuditSession` + `AuditImage`
- [ ] Implement file naming helper
- [ ] Implement tag sanitization function

---

# 3. Tag Trie System
- [ ] Create Trie node class
- [ ] Implement insert(tag)
- [ ] Implement suggest(prefix)
- [ ] Implement usageCount increment
- [ ] Implement JSON serialization
- [ ] Implement TagRepository with:
  - [ ] load()
  - [ ] save()
  - [ ] registerTags()
  - [ ] suggest()

---

# 4. Services (abstract first, then implementation)
### CameraService
- [ ] Define abstract interface
- [ ] Create mobile implementation

### BarcodeScannerService
- [ ] Define abstract interface
- [ ] Create mobile implementation using `mobile_scanner`

### LocalStorageService
- [ ] Define abstract interface
- [ ] Implement using `dart:io` + `path_provider`

### AuditApiClient
- [ ] Define abstract interface
- [ ] Create FakeAuditApiClient (no-op)

---

# 5. Application Layer
### AuditSessionNotifier
- [ ] startSession(barcode)
- [ ] captureTaggedPhoto(tags)
- [ ] clearSession()

### TagSuggestionsNotifier
- [ ] updateQuery()
- [ ] integrate with trie suggestions

---

# 6. UI Layer (Minimal First)
### HomeScreen
- [ ] Start button → barcode scan

### BarcodeScanScreen
- [ ] Integrate `BarcodeScannerService`
- [ ] On detect → startSession → navigate to TagCaptureScreen

### TagCaptureScreen
- [ ] Show barcode & photo count
- [ ] Take photo button
- [ ] Tag chips cloud (Trie)
- [ ] Autocomplete text field
- [ ] Save photo (calls notifier)
- [ ] Finish button

### Widgets
- [ ] TagChipCloud widget
- [ ] TagAutocompleteInput widget

---

# 7. Local Persistence
- [ ] Ensure images save into app-documents folder
- [ ] Confirm tag trie JSON stored in SharedPreferences

---

# 8. Optional UI Enhancements (phase 1.5)
- [ ] Animations on chip selection
- [ ] Animated autocomplete dropdown
- [ ] Frequency-based chip sizing

---

# 9. Placeholder API Integration
- [ ] Confirm session JSON generation
- [ ] Test FakeAuditApiClient with sample payload

---

# 10. Ready for Iteration 2
- [ ] Add ReviewSessionScreen
- [ ] Add batch upload to server
- [ ] Add authentication (optional)