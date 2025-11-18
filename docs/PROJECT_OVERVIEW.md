# Product Audit Tool – Project Overview

## Purpose
A Flutter-based mobile/web tool used to audit supermarket products:
- Scan **barcode** of product
- Capture **multiple photos** per product
- Save photos locally with a deterministic **naming convention**
- Later: send results to backend via flexible API client

No authentication required initially.

---

## Core User Workflow

### Session Lifecycle

1. **Start Session**
   - User opens the app and sees **Home screen** with list of past sessions.
   - User taps **"Start Audit"** button.
   - User **scans a product barcode**.
   - App creates a **new audit session** with status `inProgress`.
   - Navigates to **PhotoCaptureScreen**.

2. **Capture Photos**
   - For each photo needed:
     - User taps **"Capture Photo"** button.
     - User takes a **photo**.
     - Photo is saved locally with sequential 1-based index (`{barcode}__001.jpg`, `{barcode}__002.jpg`, etc.).
   - User can see photo count/list for the current barcode.

3. **Finish Session**
   - User taps **"Finish Audit"** button when done.
   - System:
     - Marks session as `completed`.
     - Records completion timestamp.
     - Persists session locally.
     - Returns to **Home screen**.
   - Session appears in past sessions list.

4. **View Past Sessions**
   - **Home screen** displays list of completed sessions (most recent first).
   - Each session shows: barcode, image count, status, creation/completion time.

### Behavior Notes

- If user starts a new session while one is `inProgress`, the old session is automatically completed and saved before starting the new one.
- Sessions are stored locally only (no upload yet).
- Cannot finish a session with 0 images.

---

## Naming Convention

Format: `{barcode}__{index}.jpg`

- Double underscore (`__`) separates barcode and index
- Barcode is sanitized (invalid filesystem characters removed)
- Index is **1-based** and 3-digit padded (001, 002, …), sequential per session
- First photo in a session is `001`, second is `002`, etc.
- No tag segment in filename

Examples: 
- First photo: `1234567890__001.jpg`
- Second photo: `1234567890__002.jpg`
- Third photo: `1234567890__003.jpg`

---

## Screens

1. **HomeScreen** - Entry point showing:
   - List of past completed sessions (most recent first)
   - Each session shows: barcode, image count, status badge, timestamps
   - "Start Audit" button to begin new session

2. **BarcodeScanScreen** - Scans/enters product barcode, creates session

3. **PhotoCaptureScreen** - Captures photos with:
   - Session info bar (barcode, photo count)
   - Photo list/counter display
   - "Capture Photo" button
   - "Finish Audit" button (completes and saves session)

4. **ReviewSessionScreen** (optional for iteration 2)

## Session Model

Each `AuditSession` includes:
- `String barcode` - Product barcode
- `List<AuditImage> images` - Captured photos
- `AuditSessionStatus status` - `inProgress` or `completed`
- `DateTime createdAt` - When session was started
- `DateTime? completedAt` - When session was finished (null if in progress)

Each `AuditImage` includes:
- `String localPath` - Full path to saved image file (original captured image)
- `String fileName` - Generated filename (`{barcode}__{index}.jpg`)
- `int index` - 1-based index used in filename (1, 2, 3, ...)
- `DateTime createdAt` - When photo was captured
- `String? remoteUrl` - Optional URL of the backend-processed image (CDN path)

### Image Display in QA Review

The QA review screen displays images with the following priority:

1. **Remote Processed Image** (preferred): If `remoteUrl` is present and valid, the app displays `Image.network(remoteUrl)`. This shows the final processed image after backend automation (background removal, edits, etc.). A "Processed" badge indicates this is the backend-processed version.

2. **Local Captured Image** (fallback): If no remote URL is available, the app displays the original local captured image (`Image.file`). This allows reviewers to see the original photo when backend processing hasn't occurred yet or failed.

This workflow enables reviewers to verify if automatic image processing (background removal, edits) was successful or if manual work/additional processing is needed. The remote image represents what actually ended up in the backend system.

---

## Constraints
- Must support both **Android** and **Web** (if camera allowed)
- All services must be **abstracted** for testability
- All backend communication must go through a **mockable API client**

---

## Implementation Status

**Iteration 1 (Complete):**
- ✅ All core features implemented
- ✅ Mobile support (Android/iOS)
- ✅ Web support with platform detection
- ✅ Photo capture and sequential naming
- ✅ Barcode scanning (mobile) / manual entry (web)
- ✅ File naming convention implemented (`{barcode}__{index}.jpg`)
- ✅ Session management working
- ✅ All services abstracted for testability

**Iteration 1.5 Complete:**
- ✅ Session lifecycle (start → capture → finish)
- ✅ Session persistence (local storage)
- ✅ Status tracking (`inProgress`, `completed`)
- ✅ Timestamp tracking (`createdAt`, `completedAt`)
- ✅ 1-based sequential indexing
- ✅ Home screen with past sessions list

**Next Steps (Iteration 2):**
- Session details view (ReviewSessionScreen)
- Backend API integration (real upload)
- UI enhancements and animations
- Additional testing and polish

---

