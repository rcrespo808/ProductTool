# Product Audit Tool – Project Overview

## Purpose
A Flutter-based mobile/web tool used to audit supermarket products:
- Scan **barcode** of product
- Capture **multiple photos**
- Assign **ordered tags** to each photo
- Save photos locally with a deterministic **naming convention**
- Store and suggest tags using a **Trie**
- Later: send results to backend via flexible API client

No authentication required initially.

---

## Core User Workflow
1. User opens the app.
2. User **scans a product barcode**.
3. App creates a **new audit session**.
4. For each product side/photo:
   - User takes a **photo**.
   - User selects tags from a **tag cloud (trie)** or enters new tags.
   - Photo is saved locally and tagged.
5. After all photos, user **reviews session** and can export/upload (later).

---

## Naming Convention
Format:

{barcode}{index}{tag1}-{tag2}-{tag3}.jpg

- Index is 3-digit padded (001, 002…)
- Tags are sanitized (lowercase, hyphens)
- If no tags → `no-tags`

---

## Tag System
- Stored in a **Trie**
- Persistent (local)
- Used for:
  - autocomplete
  - chip cloud
  - ordering by usage frequency

---

## Screens
1. **HomeScreen**
2. **BarcodeScanScreen**
3. **TagCaptureScreen**
4. **ReviewSessionScreen** (optional for iteration 2)

---

## Constraints
- Must support both **Android** and **Web** (if camera allowed)
- All services must be **abstracted** for testability
- All backend communication must go through a **mockable API client**

---

