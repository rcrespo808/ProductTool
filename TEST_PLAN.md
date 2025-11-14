# Test Plan – Product Audit Tool

This document defines all required test suites for agents.

---

# 1. Tag Trie Tests
- [ ] insert() adds tags correctly
- [ ] suggest() returns prefix matches
- [ ] ordering by usageCount
- [ ] JSON serialization round-trip
- [ ] Unicode/accents sanitization tests
- [ ] Duplicate insert increments usageCount

---

# 2. File Naming Tests
- [ ] Index padded to 3 digits
- [ ] Tags sanitized correctly
- [ ] Hyphen-joined tag string correct
- [ ] No tags → "no-tags" file tag
- [ ] Full example end-to-end

---

# 3. AuditSessionNotifier Tests
Mock:
- FakeCameraService → returns fixed byte array
- FakeLocalStorage → records saved files
- FakeTagRepo → in-memory

Tests:
- [ ] startSession sets barcode
- [ ] captureTaggedPhoto saves file
- [ ] file name correct
- [ ] tags passed to tag repo
- [ ] image added to state list
- [ ] clearSession resets state

---

# 4. TagSuggestionsNotifier Tests
- [ ] updateQuery returns correct suggestions
- [ ] empty prefix returns most common tags
- [ ] ordering by usageCount

---

# 5. Service Abstraction Tests
### CameraService
- [ ] null return handled gracefully

### LocalStorageService
- [ ] Valid file path returned
- [ ] Error handling for failed writes

### AuditApiClient
- [ ] Fake implementation receives correct JSON

---

# 6. UI Tests (optional early stage)
- [ ] TagChipCloud renders chips
- [ ] Selecting chip updates selected state
- [ ] Autocomplete dropdown shows suggestions
- [ ] Photo thumbnail updates when session image added

---

# 7. Integration Test (phase 1)
Simulate:
1. Scan barcode
2. Capture two photos
3. Add tags
4. Save images
5. Validate session state structure

---

# 8. Phase 2 Tests (future)
- [ ] Backend upload success/failure
- [ ] Retry logic
- [ ] Progress indicators for upload
