# Quick Start Guide

Get the Product Audit Tool running in 5 minutes!

## Prerequisites

- Flutter SDK installed (`flutter doctor` should pass)
- Android Studio or VS Code with Flutter extensions
- Android emulator running OR physical Android device connected

## Setup Steps

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Create Platform Folders (if needed)

If `android/` and `ios/` folders don't exist:

```bash
flutter create .
```

### 3. Add Android Permissions

Edit `android/app/src/main/AndroidManifest.xml` and add inside `<manifest>`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="32" />
```

### 4. Run the App

```bash
flutter run
```

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
- ✅ Photos save with correct naming: `{barcode}001{tags}.jpg`
- ✅ Tag suggestions improve over time

## Troubleshooting

**Camera not opening?**
- Check AndroidManifest.xml has camera permission
- Grant permission manually in device settings

**Photos not saving?**
- Check storage permissions
- Verify `path_provider` is working

**App crashes?**
- Run `flutter clean && flutter pub get`
- Check `flutter doctor` for issues

## Next Steps

- See [MANUAL_TESTING.md](MANUAL_TESTING.md) for comprehensive testing
- See [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed setup instructions

