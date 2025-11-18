# Test Plan – Product Audit Tool

This document defines all required test suites for agents.

---

# 1. File Naming Tests
- [ ] Index padded to 3 digits (001, 002, ...)
- [ ] Barcode sanitized correctly (invalid filesystem chars removed)
- [ ] Format correct: `{barcode}__{index}.jpg`
- [ ] Sequential indexing per barcode
- [ ] Full example end-to-end

---

# 2. AuditSessionNotifier Tests
Mock:
- FakeCameraService → returns fixed byte array
- FakeLocalStorage → records saved files
- FakeSessionRepository → in-memory
- FakeAuditApiClient → in-memory

Tests:
- [ ] startSession creates session with `inProgress` status and `createdAt`
- [ ] Starting new session while one is in progress auto-completes old one
- [ ] capturePhoto saves file with 1-based index naming (`001`, `002`, ...)
- [ ] capturePhoto creates AuditImage with index and createdAt
- [ ] File name format: `{barcode}__{index}.jpg` (1-based)
- [ ] Sequential indexing (001, 002, 003, ...)
- [ ] Image added to state list
- [ ] finishSession marks session as `completed`, sets `completedAt`, persists
- [ ] finishSession returns error if session has 0 images
- [ ] clearSession resets state (does not persist)

---

# 3. Service Abstraction Tests
### CameraService
- [ ] null return handled gracefully

### LocalStorageService
- [ ] Valid file path returned
- [ ] Error handling for failed writes

### AuditApiClient
- [ ] Fake implementation receives correct JSON

---

# 4. SessionRepository Tests
Mock:
- SharedPreferences (mock or in-memory)

Tests:
- [ ] saveSession saves completed sessions only
- [ ] saveSession updates existing session if same barcode + createdAt
- [ ] getAllSessions returns all sessions (most recent first)
- [ ] getCompletedSessions filters by completed status
- [ ] Sessions persisted correctly (JSON serialization)
- [ ] Load sessions after app restart (persistence)

---

# 5. Domain Models Tests
### AuditSessionStatus
- [ ] Enum values (`inProgress`, `completed`)
- [ ] JSON serialization round-trip

### AuditSession
- [ ] Status, createdAt, completedAt fields
- [ ] JSON serialization/deserialization
- [ ] copyWith updates all fields
- [ ] Equality (props include all fields)

### AuditImage
- [ ] Index and createdAt fields
- [ ] JSON serialization/deserialization
- [ ] Equality (props include all fields)

---

# 6. UI Tests (optional early stage)
- [ ] PhotoCaptureScreen displays session info
- [ ] Photo list updates when images added
- [ ] Capture button works correctly
- [ ] "Finish Audit" button calls finishSession()
- [ ] "Finish Audit" validates at least one photo
- [ ] HomeScreen displays list of past sessions (most recent first)
- [ ] HomeScreen shows empty state when no sessions
- [ ] HomeScreen refresh loads updated sessions

---

# 7. Integration Test (phase 1)
Simulate:
1. Scan barcode → creates session with `inProgress` status
2. Capture first photo → `{barcode}__001.jpg` (1-based index)
3. Capture second photo → `{barcode}__002.jpg`
4. Finish session → status `completed`, `completedAt` set
5. Verify session persisted in repository
6. Return to Home → verify session appears in list
7. Start new session → verify old one completed, new one `inProgress`

---

# 8. Phase 2 Tests (future)
- [ ] Backend upload success/failure
- [ ] Retry logic
- [ ] Progress indicators for upload

---

## Manual Testing Scenarios

### Setup & Initial Launch
- [ ] App launches successfully
- [ ] HomeScreen displays correctly with "Start Audit" button

### Barcode Scanning Flow
- [ ] Navigate to Barcode Scan Screen
- [ ] Barcode scanning works (valid barcodes, multiple products, cancel/back navigation)

### Photo Capture Flow
- [ ] PhotoCaptureScreen displays correctly
- [ ] Capture photo works (sequential naming: `{barcode}__001.jpg`, `{barcode}__002.jpg`, etc.)
- [ ] Multiple photos in session (verify count increments, sequential naming)

### Session Management
- [ ] Finish session (requires at least 1 photo)
- [ ] Session persistence (state maintained on back navigation)

### Error Handling
- [ ] Camera permission denied
- [ ] Storage permission issues
- [ ] Photo capture cancelled

### File System Verification
- [ ] Photos saved correctly in `app_documents/audit_images/`
- [ ] Files can be opened/viewed

### Known Limitations
- iOS: Not fully tested (may need additional permissions setup)
- Web: Supported with manual barcode entry
- Backend Upload: Fake implementation (no actual server upload)
- Review Screen: Not implemented yet (phase 2 feature)

### Common Issues & Solutions
- Camera permission: Check AndroidManifest.xml, grant manually in device settings
- Photos not saving: Check storage permissions, verify path_provider
- Barcode not detecting: Ensure good lighting, try different formats
- App crashes: Check Flutter version, run `flutter doctor`

### Test Data
- Sample Barcodes: EAN-13 `5901234123457`, UPC-A `012345678905`