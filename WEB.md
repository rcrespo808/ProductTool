# Web Platform Support

This document covers running the Product Audit Tool on web, including setup, limitations, and testing.

## Quick Start

### Enable Web Support

```powershell
flutter config --enable-web
```

### Create Web Platform Files (if needed)

```powershell
flutter create . --platforms=web
```

### Install Dependencies

```powershell
flutter pub get
```

### Run on Chrome

```powershell
flutter run -d chrome
```

Or use web server mode:

```powershell
flutter run -d web-server --web-port 8080
# Then open http://localhost:8080
```

### Build for Production

```powershell
flutter build web
cd build/web
python -m http.server 8000
# Or use any static file server
```

## Web-Specific Features

### ✅ What Works

- **Manual Barcode Entry**: Web automatically shows a text input form instead of camera scanning
- **Tag System**: Autocomplete, suggestions, and chip cloud all work
- **Tag Persistence**: SharedPreferences works via browser localStorage
- **Photo Capture**: Uses browser file picker (instead of camera)
- **File Downloads**: Photos download with correct naming convention
- **Navigation**: All screens and navigation work correctly

### ⚠️ Platform Differences

| Feature | Mobile | Web |
|---------|--------|-----|
| Barcode Scanning | Camera-based (`mobile_scanner`) | Manual text entry |
| Photo Capture | Camera | File picker |
| File Storage | App documents folder | Browser downloads |
| Camera Access | Native permissions | Browser permissions (HTTPS required in production) |

## Implementation Details

### Platform Detection

The app uses Flutter's `kIsWeb` for platform detection:

```dart
import 'package:flutter/foundation.dart' show kIsWeb;

if (kIsWeb) {
  // Web-specific implementation
} else {
  // Mobile implementation
}
```

### Conditional Imports

Platform-specific implementations use conditional imports:

```dart
// Storage implementation
import 'local_storage_impl_mobile.dart' 
    if (dart.library.html) 'local_storage_impl_web.dart';

// Barcode scanner
import 'barcode_scan_screen_mobile.dart' 
    if (dart.library.html) 'barcode_scan_screen_web.dart';
```

### File Storage on Web

Web uses browser download API instead of file system:

- Photos are downloaded (not saved to app directory)
- File naming convention still applies: `{barcode}{index}{tags}.jpg`
- Example: `123456789001001front-back.jpg`

## Testing on Web

### Basic Functionality Test

1. ✅ **HomeScreen** loads correctly
2. ✅ **Start Audit** button works
3. ✅ **Barcode Entry** form appears (web-specific)
4. ✅ **Tag System** works (autocomplete, suggestions)
5. ✅ **Photo Capture** opens file picker
6. ✅ **File Download** works with correct naming
7. ✅ **Navigation** between screens works

### Test Flow

1. Launch app: `flutter run -d chrome`
2. Click "Start Audit"
3. Enter test barcode: `1234567890123`
4. Click "Continue"
5. Add tags (e.g., "front", "back")
6. Click "Capture Photo"
7. Select image file from browser dialog
8. Verify file downloads with correct name
9. Capture multiple photos and verify count increments
10. Click "Finish" and verify return to HomeScreen

## Known Limitations

### Barcode Scanning

- `mobile_scanner` package does **not** support web
- Solution: Manual barcode entry form (implemented)
- Future: Could use web-based barcode scanning library (e.g., QuaggaJS, jsQR)

### File Storage

- Web cannot access local file system directly
- Solution: Browser download API (implemented)
- Photos download instead of saving to persistent storage
- Future: Could use IndexedDB for metadata storage

### Camera Access

- Browser camera access requires user permission
- HTTPS required in production (localhost works for development)
- Camera permissions are browser-specific

### SharedPreferences

- Works on web via browser localStorage
- Data persists across browser sessions
- Can be cleared by clearing browser data

## Troubleshooting

### Issue: "Web support is not enabled"

```powershell
flutter config --enable-web
flutter doctor
```

### Issue: "No devices found"

- Ensure Chrome is installed
- Or use: `flutter run -d web-server --web-port 8080`

### Issue: "Compilation errors"

- Check for import errors (should use conditional imports)
- Run: `flutter clean && flutter pub get`
- Verify platform-specific files exist

### Issue: "File picker not working"

- Normal behavior - web uses browser file picker
- Photos will download instead of saving to app directory
- Check browser console for errors

### Issue: "Camera access denied"

- Normal on web - camera is only used for mobile
- Web uses file picker instead
- If implementing web camera later, ensure HTTPS

## Development vs Production

### Development

- HTTP (localhost) works fine
- Hot reload available
- Debug console shows errors
- File picker and downloads work normally

### Production

- Requires HTTPS for camera access (if implemented)
- Need to build and deploy
- Consider using Firebase Hosting, Vercel, or similar
- Test on multiple browsers (Chrome, Firefox, Safari, Edge)

## Browser Compatibility

Tested and working on:
- ✅ Chrome/Edge (Chromium-based)
- ✅ Firefox
- ⚠️ Safari (may have some limitations)

## Next Steps

1. Test on multiple browsers
2. Consider web-based barcode scanning library
3. Implement IndexedDB for metadata storage
4. Add HTTPS support for production deployment

