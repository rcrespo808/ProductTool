# Setup Guide for Manual Testing

This guide will help you set up the Product Audit Tool for manual testing.

## Prerequisites

1. **Flutter SDK** installed and configured
   - Check: `flutter doctor`
   - Ensure all required tools are installed

2. **Development Environment**
   - Android Studio / VS Code with Flutter extensions
   - Android SDK (for Android testing)
   - Xcode (for iOS testing, macOS only)

## Initial Setup

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

### 2. Create Flutter Platform Folders (if needed)

If the `android/` and `ios/` folders don't exist, create them:

```bash
flutter create .
```

This will generate the necessary platform-specific folders and files.

### 3. Configure Android Permissions

After running `flutter create .`, edit `android/app/src/main/AndroidManifest.xml`:

Add these permissions inside `<manifest>`:

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

Fix any issues before testing.

## Running the App

### On Android Emulator/Device

1. **Start an emulator** (or connect a physical device):
   ```bash
   flutter emulators --launch <emulator_id>
   ```
   Or connect your Android device via USB and enable USB debugging.

2. **Check connected devices**:
   ```bash
   flutter devices
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

### On iOS Simulator/Device (macOS only)

1. **Start simulator**:
   ```bash
   open -a Simulator
   ```

2. **Run the app**:
   ```bash
   flutter run
   ```

### Troubleshooting

**Issue: "No devices found"**
- Ensure emulator is running or device is connected
- Check USB debugging is enabled on physical devices
- Run `flutter doctor` to diagnose issues

**Issue: Build errors**
- Clean and rebuild: `flutter clean && flutter pub get && flutter run`
- Check Android SDK is properly installed

**Issue: Permission errors**
- Verify permissions are in AndroidManifest.xml / Info.plist
- Grant permissions manually in device settings after first launch

## Testing Checklist

See [MANUAL_TESTING.md](MANUAL_TESTING.md) for detailed test scenarios.  
See [TEST_PLAN.md](TEST_PLAN.md) for testing strategy.

Quick test:
1. Launch app → Should show HomeScreen
2. Tap "Start Audit" → Should open camera for barcode scanning
3. Scan or enter barcode → Should navigate to TagCaptureScreen
4. Add tags and capture photo → Should save photo with tags
5. Finish session → Should return to HomeScreen

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

## Key Features to Test

1. **Barcode Scanning** - Uses mobile_scanner with camera
2. **Photo Capture** - Uses image_picker with camera
3. **Tag System** - Trie-based autocomplete with persistence
4. **File Naming** - Format: `{barcode}{index}{tags}.jpg`
5. **Session Management** - Track multiple photos per session

## Next Steps

After setup:
1. Follow [MANUAL_TESTING.md](MANUAL_TESTING.md) for comprehensive testing
2. Document any bugs or issues found
3. Review [TEST_PLAN.md](TEST_PLAN.md) for automated test scenarios
4. For web testing, see [WEB.md](WEB.md)
5. Plan phase 2 features (review screen, backend upload)

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [mobile_scanner Documentation](https://pub.dev/packages/mobile_scanner)
- [image_picker Documentation](https://pub.dev/packages/image_picker)

