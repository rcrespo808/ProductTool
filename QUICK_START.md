# Quick Start Guide

Get the Product Audit Tool running quickly! This guide covers everything from Flutter installation to running the app.

## Prerequisites

1. **Flutter SDK** installed (`flutter doctor` should pass)
2. **Development Environment**
   - Android Studio / VS Code with Flutter extensions
   - Android emulator running OR physical Android device connected
   - (Optional) Xcode for iOS testing (macOS only)

## Installing Flutter (Windows)

If Flutter is not yet installed on Windows:

### Finding Flutter Installation

**Option 1: Check Common Locations**
- `C:\flutter\`
- `C:\src\flutter\`
- `%USERPROFILE%\flutter\`
- `%LOCALAPPDATA%\flutter\`

**Option 2: Search for Flutter**
Open PowerShell and run:
```powershell
# Search in user directory
Get-ChildItem -Path $env:USERPROFILE -Filter "flutter" -Recurse -Directory -ErrorAction SilentlyContinue | Select-Object FullName

# Search in C:\ (limited depth for speed)
Get-ChildItem -Path "C:\" -Filter "flutter" -Recurse -Directory -ErrorAction SilentlyContinue -Depth 2 | Select-Object FullName
```

### Installing Flutter (If Not Found)

1. **Download Flutter SDK:**
   - Visit: https://flutter.dev/docs/get-started/install/windows
   - Download the latest stable release ZIP file

2. **Extract Flutter:**
   ```powershell
   # Example: Extract to C:\src\-
   Expand-Archive -Path flutter_windows_*.zip -DestinationPath C:\src\
   ```

3. **Add to PATH:**

   **Option A: Using PowerShell (Current Session)**
   ```powershell
   # Temporarily (for current session)
   $env:Path += ";C:\src\flutter\bin"
   
   # Verify it works
   flutter --version
   ```

   **Option B: Permanent Setup (Recommended)**
   
   Using PowerShell (as Administrator):
   ```powershell
   # Permanently (replace C:\src\flutter with your actual Flutter path)
   [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\src\flutter\bin", "User")
   ```
   
   Or use GUI:
   1. Press `Win + X` → System
   2. Click "Advanced system settings"
   3. Click "Environment Variables"
   4. Under "User variables", select "Path" → Edit
   5. Click "New" → Add `C:\src\flutter\bin` (replace with your path)
   6. Click OK on all dialogs
   7. **Restart your terminal/PowerShell**

4. **Verify Installation:**
   ```powershell
   flutter --version
   flutter doctor
   ```

### Setting Up for Web (Windows)

Once Flutter is installed:

```powershell
# Enable web support
flutter config --enable-web

# Verify web is enabled
flutter doctor -v

# Run the app
flutter run -d chrome
```

### Alternative: Use Flutter Full Path

If Flutter is installed but not in PATH, you can use the full path:

```powershell
# Example: If Flutter is in C:\src\flutter\
C:\src\flutter\bin\flutter.exe run -d chrome

# Or create an alias for current session
function flutter { & "C:\src\flutter\bin\flutter.exe" $args }
flutter run -d chrome
```

---

## Quick Setup (5 Minutes)

### 1. Install Dependencies

```bash
flutter pub get
```

This will install all required packages:
- flutter_riverpod (state management)
- image_picker (camera/photo capture)
- mobile_scanner (barcode scanning)
- shared_preferences (tag persistence)
- path_provider (file storage)

### 2. Create Platform Folders (if needed)

If `android/` and `ios/` folders don't exist:

```bash
flutter create .
```

This will generate the necessary platform-specific folders and files.

### 3. Configure Android Permissions

Edit `android/app/src/main/AndroidManifest.xml` and add inside `<manifest>`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="32" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```

For Android 13+ (API 33+), add:
```xml
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```

Also ensure the `<application>` tag has:
```xml
<application
    android:label="Product Audit Tool"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">
```

### 4. Configure iOS Permissions (macOS only)

Edit `ios/Runner/Info.plist` and add:

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to capture product photos and scan barcodes</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to save product photos</string>
```

### 5. Verify Code Quality

Run static analysis:
```bash
flutter analyze
```

Fix any issues before running.

### 6. Run the App

**On Android Emulator/Device:**
```bash
# Start an emulator (or connect a physical device)
flutter emulators --launch <emulator_id>

# Check connected devices
flutter devices

# Run the app
flutter run
```

**On iOS Simulator/Device (macOS only):**
```bash
# Start simulator
open -a Simulator

# Run the app
flutter run
```

**On Web:**
```bash
flutter run -d chrome
```

---

## First Test

1. **Launch**: App shows HomeScreen with "Start Audit" button
2. **Scan**: Tap "Start Audit" → Camera opens for barcode scanning
3. **Capture**: Point camera at any product barcode (or use test barcode: `1234567890123`)
4. **Tag**: Navigate to TagCaptureScreen → Add tags (e.g., "front", "back")
5. **Save**: Tap "Capture Photo" → Photo saves with tags
6. **Finish**: Tap "Finish" → Return to HomeScreen

## Expected Behavior

- ✅ App launches without errors
- ✅ Camera opens for barcode scanning
- ✅ Barcode detection works (try product barcodes)
- ✅ Photo capture works
- ✅ Tags can be added and selected
- ✅ Photos save with correct naming: `{barcode}_001_{tags}.jpg`
- ✅ Tag suggestions improve over time

---

## Detailed Troubleshooting

### Flutter Installation Issues

**"Flutter not recognized"**
- Make sure you added Flutter to PATH
- **Restart your terminal/PowerShell** after adding to PATH
- Verify the path is correct: `C:\src\flutter\bin\flutter.exe` should exist

**"Web support not enabled"**
```powershell
flutter config --enable-web
```

**"Chrome not found"**
- Install Google Chrome browser
- Or use: `flutter run -d web-server --web-port 8080`

**"Doctor shows issues"**
```powershell
flutter doctor
```

Common fixes:
- Install Android Studio (for Android development)
- Install Chrome (for web development)
- Accept Android licenses: `flutter doctor --android-licenses`

### App Issues

**Camera not opening?**
- Check AndroidManifest.xml has camera permission
- Grant permission manually in device settings
- For iOS, verify Info.plist has NSCameraUsageDescription

**Photos not saving?**
- Check storage permissions
- Verify `path_provider` is working
- Grant permission manually in device settings

**App crashes?**
- Run `flutter clean && flutter pub get`
- Check `flutter doctor` for issues

**"No devices found"**
- Ensure emulator is running or device is connected
- Check USB debugging is enabled on physical devices
- Run `flutter doctor` to diagnose issues

**Build errors**
- Clean and rebuild: `flutter clean && flutter pub get && flutter run`
- Check Android SDK is properly installed

**Permission errors**
- Verify permissions are in AndroidManifest.xml / Info.plist
- Grant permissions manually in device settings after first launch

---

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── core/                        # Services & utilities
│   ├── camera/                  # Camera service
│   ├── barcode/                 # Barcode scanner
│   ├── storage/                 # File storage
│   ├── api/                     # API client (fake)
│   └── providers.dart           # Riverpod providers
├── domain/                      # Business logic
│   ├── models/                  # AuditSession, AuditImage
│   └── tags/                    # Tag Trie system
├── application/                 # State management
│   ├── audit/                   # Audit session notifier
│   └── tags/                    # Tag suggestions notifier
└── presentation/                # UI layer
    ├── screens/                 # Home, Scan, Capture
    └── widgets/                 # TagCloud, Autocomplete
```

## Key Features

1. **Barcode Scanning** - Uses mobile_scanner with camera
2. **Photo Capture** - Uses image_picker with camera
3. **Tag System** - Trie-based autocomplete with persistence
4. **File Naming** - Format: `{barcode}_{index}_{tags}.jpg`
5. **Session Management** - Track multiple photos per session

---

## Next Steps

- See [MANUAL_TESTING.md](MANUAL_TESTING.md) for comprehensive testing
- See [TEST_PLAN.md](TEST_PLAN.md) for testing strategy
- For web setup and testing, see [WEB.md](WEB.md)
- Review [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md) for project details
- Check [TECH_STRUCTURE.md](TECH_STRUCTURE.md) for architecture

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [mobile_scanner Documentation](https://pub.dev/packages/mobile_scanner)
- [image_picker Documentation](https://pub.dev/packages/image_picker)
