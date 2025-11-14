# Quick Test Guide - Web Launch

## Prerequisites Check

First, verify Flutter is installed:
```bash
flutter --version
```

If Flutter is not found:
1. Make sure Flutter is installed
2. Add Flutter to your PATH
3. Restart your terminal/IDE

## Testing Steps

### 1. Setup (One-time)

```bash
# Enable web support
flutter config --enable-web

# Create web platform files (if needed)
flutter create . --platforms=web

# Install dependencies
flutter pub get
```

### 2. Launch App

**Option A: Chrome (Recommended)**
```bash
flutter run -d chrome
```

**Option B: Web Server**
```bash
flutter run -d web-server --web-port 8080
```
Then open: http://localhost:8080

### 3. Test Flow

1. **HomeScreen**
   - ✅ App should load
   - ✅ "Start Audit" button visible
   - ✅ Click "Start Audit"

2. **Barcode Entry (Web)**
   - ✅ Should see manual entry form (not camera)
   - ✅ Message: "Web platform does not support camera barcode scanning"
   - ✅ Enter test barcode: `1234567890123`
   - ✅ Click "Continue"

3. **Tag Capture Screen**
   - ✅ Barcode displayed in header
   - ✅ Photo count shows "0"
   - ✅ Tag input field visible
   - ✅ Try typing a tag (e.g., "front")
   - ✅ Add tag, select tags from chip cloud
   - ✅ Click "Capture Photo"

4. **Photo Capture (Web)**
   - ✅ Browser file picker opens
   - ✅ Select an image file
   - ✅ Photo should download with correct name format
   - ✅ Photo count increments
   - ✅ Success message appears

5. **Session Management**
   - ✅ Capture 2-3 photos with different tags
   - ✅ Photo count updates correctly
   - ✅ Click "Finish"
   - ✅ Returns to HomeScreen

## Expected Behavior on Web

✅ **Works:**
- Manual barcode entry
- Tag system (autocomplete, suggestions)
- Tag persistence (SharedPreferences)
- Photo file picker
- Photo downloads with correct naming
- UI navigation
- All screens display correctly

⚠️ **Limitations:**
- No camera barcode scanning (uses manual entry)
- Photos download instead of saving to app directory
- File picker instead of camera capture

## Troubleshooting

**If app doesn't launch:**
```bash
flutter clean
flutter pub get
flutter run -d chrome
```

**If you see import errors:**
- Check that conditional imports are working
- Verify `local_storage_impl.dart` uses conditional imports
- Verify `barcode_scan_screen_mobile_wrapper.dart` exists

**If barcode screen doesn't work:**
- Should show manual entry on web
- If you see camera scanner, conditional imports may not be working

**If photo download doesn't work:**
- Check browser console for errors
- Verify `dart:html` is available (web platform only)
- Check browser download settings

## Quick Verification

Run this to check everything is ready:
```bash
flutter analyze
flutter doctor
```

Both should pass without critical errors.

## Test Results Template

```
Date: ___________
Browser: Chrome / Firefox / Edge / Other: _______

✅ Working:
- HomeScreen loads
- Manual barcode entry works
- Tags system works
- Photo picker works
- Photos download correctly

❌ Issues Found:
1. 
2. 

📝 Notes:
```

