# Pre-Testing Checklist

## Before Starting Manual Testing

Use this checklist to ensure everything is ready for testing.

### Setup Requirements

- [ ] **Flutter SDK installed and configured**
  - Run: `flutter doctor`
  - All required tools should be checked

- [ ] **Dependencies installed**
  - Run: `flutter pub get`
  - Should complete without errors

- [ ] **Platform folders created**
  - Run: `flutter create .` (if `android/` or `ios/` don't exist)
  - Should generate `android/` and `ios/` folders

- [ ] **Android permissions configured**
  - Edit `android/app/src/main/AndroidManifest.xml`
  - Add camera and storage permissions (see [SETUP_GUIDE.md](SETUP_GUIDE.md))

- [ ] **Code analysis passes**
  - Run: `flutter analyze`
  - Should show no errors (warnings are OK)

- [ ] **Build succeeds**
  - Run: `flutter build apk --debug` (or `flutter build ios`)
  - Should complete without errors

### Device/Emulator Ready

- [ ] **Android emulator running OR physical device connected**
  - Check: `flutter devices`
  - Should list at least one device

- [ ] **USB debugging enabled** (for physical devices)
  - Android: Settings → Developer Options → USB Debugging
  - Device should be authorized

- [ ] **Camera accessible** (on emulator/physical device)
  - Camera app should work
  - Camera permission should be grantable

### Documentation Ready

- [ ] **Read [QUICK_START.md](QUICK_START.md)** - Quick setup guide
- [ ] **Read [SETUP_GUIDE.md](SETUP_GUIDE.md)** - Detailed setup instructions
- [ ] **Read [MANUAL_TESTING.md](MANUAL_TESTING.md)** - Test scenarios
- [ ] **Understand project structure** - See [TECH_STRUCTURE.md](TECH_STRUCTURE.md)

### Test Data Prepared

- [ ] **Sample barcodes ready** (or products with barcodes)
  - EAN-13: `5901234123457` (example)
  - UPC-A: `012345678905` (example)
  - Real product barcodes work best

- [ ] **Test tags planned**
  - Common tags: `front`, `back`, `side`, `top`, `bottom`
  - Product tags: `label`, `nutrition`, `ingredients`
  - Status tags: `damaged`, `expired`, `missing`

### Known Issues to Watch For

- [ ] **Camera permission denied** → Check AndroidManifest.xml
- [ ] **Photos not saving** → Check storage permissions
- [ ] **Barcode not detecting** → Ensure good lighting, steady camera
- [ ] **App crashes on launch** → Check Flutter version, run `flutter doctor`
- [ ] **Build errors** → Run `flutter clean && flutter pub get`

## Quick Verification

Run these commands to verify everything is ready:

```bash
# Check Flutter setup
flutter doctor

# Check dependencies
flutter pub get

# Verify code quality
flutter analyze

# Check available devices
flutter devices

# Test build (Android)
flutter build apk --debug
```

## Ready to Test?

Once all items above are checked:

1. Run: `flutter run`
2. Follow: [MANUAL_TESTING.md](MANUAL_TESTING.md)
3. Document any bugs or issues found
4. Test edge cases (empty inputs, special characters, etc.)

## Support

- See [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed setup help
- See [QUICK_START.md](QUICK_START.md) for quick reference
- Check Flutter documentation if issues persist

