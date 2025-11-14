# Web Platform Setup & Limitations

This document explains how to run the Product Audit Tool on web and the known limitations.

## ⚠️ Important Limitations

The app uses several features that have **limited or no support on web**:

1. **Barcode Scanning** (`mobile_scanner`):
   - ❌ `mobile_scanner` package does NOT support web
   - ✅ Alternative: Manual barcode entry needed
   - 📝 Workaround: Add a text input for manual barcode entry

2. **Camera Access** (`image_picker`):
   - ⚠️ Limited web support
   - ✅ Works but requires HTTPS in most browsers
   - 📝 May need to use file picker instead of camera on web

3. **File System** (`path_provider`):
   - ⚠️ Web uses browser storage (IndexedDB) instead of file system
   - ✅ Photos can be saved but as downloads, not persistent storage
   - 📝 Files saved as browser downloads

4. **SharedPreferences**:
   - ✅ Works on web (uses browser localStorage)

## Setup for Web

### 1. Enable Web Support

```bash
flutter config --enable-web
```

### 2. Create Web Folder (if needed)

```bash
flutter create . --platforms=web
```

This will create a `web/` folder with necessary files.

### 3. Add Web Permissions

Edit `web/index.html` and ensure camera permissions are requested:

```html
<!DOCTYPE html>
<html>
<head>
  <base href="$FLUTTER_BASE_HREF">
  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <meta name="description" content="Product Audit Tool">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="Product Audit">
  <link rel="apple-touch-icon" href="icons/Icon-192.png">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <link rel="icon" type="image/png" href="favicon.png"/>
  <title>Product Audit Tool</title>
  <style>
    body {
      margin: 0;
      padding: 0;
      overflow: hidden;
    }
  </style>
</head>
<body>
  <script>
    // Request camera permission on page load
    navigator.mediaDevices.getUserMedia({ video: true })
      .then(() => console.log('Camera access granted'))
      .catch(() => console.warn('Camera access denied or not available'));
  </script>
  <script src="main.dart.js" type="application/javascript"></script>
</body>
</html>
```

### 4. Run on Web

**Development (with hot reload):**
```bash
flutter run -d chrome
```

**Or specify web explicitly:**
```bash
flutter run -d web-server --web-port 8080
```

**Build for web:**
```bash
flutter build web
```

Serve the build:
```bash
cd build/web
python -m http.server 8000
# Or use any static file server
```

## Known Issues on Web

### Barcode Scanning

`mobile_scanner` will fail on web. You'll need to:

1. **Modify BarcodeScanScreen** to detect web platform and show a text input instead
2. **Or create a web-specific barcode scanner** using `html` package and `js` interop
3. **Or use a manual entry fallback** for web

Example web detection:
```dart
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

if (kIsWeb) {
  // Show text input for manual barcode entry
} else {
  // Use mobile_scanner
}
```

### File Storage

Web file storage works differently:
- Files are saved as downloads, not persistent app storage
- Cannot access file system directly
- Consider using IndexedDB or browser storage for metadata

### HTTPS Requirement

For camera access, the app **must run on HTTPS** in production:
- Development: `http://localhost` works
- Production: Requires HTTPS certificate

## Recommended Approach

For web support, consider:

1. **Add Platform Detection**:
   - Detect web platform in screens
   - Show web-specific UI (manual barcode entry)

2. **Web-Specific Barcode Scanner**:
   - Use `html` package for camera access
   - Or use `quagga2` or `jsQR` via JS interop

3. **Web File Storage**:
   - Use browser download API
   - Store metadata in localStorage/IndexedDB

4. **Conditional Imports**:
   ```dart
   // Use conditional imports for platform-specific code
   import 'package:flutter/foundation.dart' show kIsWeb;
   
   if (kIsWeb) {
     // Web-specific implementation
   } else {
     // Mobile implementation
   }
   ```

## Quick Test on Web

1. Run: `flutter run -d chrome`
2. Open browser console (F12) to see any errors
3. Test:
   - HomeScreen should load ✅
   - Navigation should work ✅
   - Barcode scanning will fail ❌ (needs web implementation)
   - Photo capture may work ⚠️ (depends on browser permissions)

## Alternative: Web-Compatible Version

To make the app fully web-compatible, you would need to:

1. Replace `mobile_scanner` with a web-compatible barcode scanner
2. Modify file storage to use browser download API
3. Handle camera permissions for web browsers
4. Test on multiple browsers (Chrome, Firefox, Safari)

This would require significant code changes and is beyond the current implementation scope.

## Next Steps

1. Test basic UI on web: `flutter run -d chrome`
2. Add platform detection for barcode scanner
3. Implement web fallback (manual barcode entry)
4. Consider web-specific packages for full feature parity

