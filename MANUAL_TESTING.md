# Manual Testing Guide

This document provides a step-by-step guide for manually testing the Product Audit Tool.

## Prerequisites

1. **Flutter Setup**
   - Flutter SDK installed and configured
   - Android Studio / VS Code with Flutter extensions
   - Android emulator or physical Android device
   - (Optional) iOS simulator or physical iOS device

2. **Dependencies**
   ```bash
   flutter pub get
   ```

3. **Permissions**
   - Camera permission (for photo capture and barcode scanning)
   - Storage permission (for saving images)
   - Note: These will be requested at runtime on Android 6.0+

## Test Checklist

### Setup & Initial Launch

- [ ] **App launches successfully**
  - Run: `flutter run`
  - App should show HomeScreen with welcome message
  - No crashes or errors in console

- [ ] **HomeScreen displays correctly**
  - Welcome message visible
  - "Start Audit" button visible and clickable
  - App icon/logo displays correctly

### Barcode Scanning Flow

- [ ] **Navigate to Barcode Scan Screen**
  - Tap "Start Audit" button
  - Should navigate to BarcodeScanScreen
  - Camera view should appear
  - Instructions overlay visible

- [ ] **Barcode scanning works**
  - Point camera at a product barcode (EAN-13, UPC-A, etc.)
  - App should detect barcode automatically
  - Should navigate to TagCaptureScreen after detection
  - Barcode should be displayed in session info

**Test Cases:**
  - Valid barcode detection
  - Multiple barcodes (try 2-3 different products)
  - Cancel/back navigation (should work)

### Photo Capture & Tagging Flow

- [ ] **TagCaptureScreen displays correctly**
  - Barcode displayed in header
  - Photo count shows "0" initially
  - Tag autocomplete input visible
  - Tag chip cloud visible (may be empty initially)
  - "Capture Photo" button visible

- [ ] **Tag autocomplete works**
  - Type a tag name (e.g., "front")
  - Should show suggestions if any exist
  - Can select from suggestions
  - Can type new tag and press Enter
  - Tag should be added to selected tags list
  - Input field should clear after adding tag

- [ ] **Tag chip cloud works**
  - Suggested tags appear as chips
  - Can tap chips to select/deselect
  - Selected tags show in different color
  - Tag frequency affects chip size (more usage = larger)

- [ ] **Capture photo works**
  - Select one or more tags
  - Tap "Capture Photo" button
  - Camera should open (grant permission if first time)
  - Take a photo
  - Photo should save automatically
  - Photo count should increment
  - Selected tags should clear
  - Success message should appear

**Test Cases:**
  - Capture photo with 1 tag
  - Capture photo with multiple tags
  - Capture photo with no tags (should save as "no-tags")
  - Capture multiple photos in same session (3-5 photos)
  - Verify file naming: `{barcode}{index}{tags}.jpg`

### Session Management

- [ ] **Multiple photos in session**
  - Start new session
  - Capture 3+ photos with different tags
  - Verify photo count increments correctly
  - Verify each photo is saved with correct naming

- [ ] **Finish session**
  - After capturing at least 1 photo
  - Tap "Finish" button
  - Should show dialog with photo count
  - Should return to HomeScreen
  - Session should be cleared

- [ ] **Session persistence**
  - Start session, capture photos
  - Press back button (should ask to confirm or allow)
  - Session state should be maintained (if not explicitly cleared)

### Tag Trie System

- [ ] **Tag suggestions improve over time**
  - First session: Add new tags (e.g., "front", "back", "label")
  - Second session: Start typing "fr" → should suggest "front"
  - Tags appear in chip cloud ordered by frequency
  - Frequently used tags appear larger

- [ ] **Tag persistence**
  - Close app completely
  - Reopen app
  - Previously used tags should still be available
  - Tag usage counts should persist

### Error Handling

- [ ] **Camera permission denied**
  - Deny camera permission when requested
  - Should show appropriate error message
  - App should handle gracefully

- [ ] **Storage permission issues**
  - Test on device with limited storage
  - Should show error message if save fails

- [ ] **Empty barcode handling**
  - (If possible) Test with invalid/empty barcode
  - Should handle gracefully

- [ ] **Photo capture cancelled**
  - Cancel camera without taking photo
  - Should return to TagCaptureScreen
  - Should not crash

### File System

- [ ] **Photos are saved correctly**
  - Navigate to device storage
  - Check app documents folder: `app_documents/audit_images/`
  - Verify files exist with correct naming:
    - Format: `{barcode}{index}{tag1}-{tag2}.jpg`
    - Example: `123456789001001front-back.jpg`
  - Verify files can be opened/viewed

### UI/UX

- [ ] **Navigation flow**
  - Home → Scan → Capture → (Finish) → Home
  - Back button works correctly
  - No navigation errors

- [ ] **Loading states**
  - Photo capture shows loading indicator
  - UI is responsive during operations

- [ ] **Error messages**
  - Clear, user-friendly error messages
  - Errors don't crash the app

- [ ] **Visual feedback**
  - Selected tags are clearly highlighted
  - Photo count updates immediately
  - Success/error messages appear

## Known Limitations

1. **iOS**: Not fully tested (may need additional permissions setup)
2. **Web**: Not supported (camera and file system requirements)
3. **Backend Upload**: Fake implementation (no actual server upload)
4. **Review Screen**: Not implemented yet (phase 2 feature)

## Testing on Physical Device

### Android

1. Enable Developer Options and USB Debugging
2. Connect device via USB
3. Run: `flutter run -d <device-id>`
4. Grant permissions when prompted

### iOS (if available)

1. Open project in Xcode
2. Configure signing and certificates
3. Update Info.plist with camera/storage permissions
4. Run on device/simulator

## Common Issues & Solutions

### Issue: Camera permission not granted
**Solution**: Check `AndroidManifest.xml` permissions. Grant permission manually in device settings.

### Issue: Photos not saving
**Solution**: Check storage permissions. Verify `path_provider` is working correctly.

### Issue: Barcode not detecting
**Solution**: Ensure good lighting and steady camera. Try different barcode formats.

### Issue: App crashes on launch
**Solution**: Check Flutter version compatibility. Run `flutter doctor` to diagnose.

## Test Data

### Sample Barcodes for Testing
- EAN-13: `5901234123457` (standard product barcode)
- UPC-A: `012345678905` (US product barcode)
- Use any product barcode from real products

### Sample Tags
- `front`, `back`, `side`, `top`, `bottom`
- `label`, `nutrition`, `ingredients`
- `damaged`, `expired`, `missing`
- Create your own tags as needed

## Next Steps After Testing

1. Document any bugs or issues found
2. Test edge cases (empty inputs, very long tags, special characters)
3. Performance testing (many photos, many tags)
4. Begin implementing tests from TEST_PLAN.md
5. Plan for phase 2 features (review screen, backend upload)

