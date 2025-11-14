# Testing the App on Web

## Quick Test Commands

### Step 1: Verify Flutter Setup
```bash
flutter doctor
flutter --version
```

### Step 2: Enable Web Support (if not already enabled)
```bash
flutter config --enable-web
```

### Step 3: Create Web Platform Files (if needed)
```bash
flutter create . --platforms=web
```

### Step 4: Install Dependencies
```bash
flutter pub get
```

### Step 5: Run on Chrome
```bash
flutter run -d chrome
```

Or use web-server mode:
```bash
flutter run -d web-server --web-port 8080
```

### Step 6: Build for Web (Alternative)
```bash
flutter build web
cd build/web
python -m http.server 8000
# Then open http://localhost:8000
```

## What to Test

### ✅ Basic Functionality
- [ ] App launches without errors
- [ ] HomeScreen displays correctly
- [ ] "Start Audit" button works
- [ ] Navigation works

### ✅ Barcode Entry (Web-specific)
- [ ] Barcode scan screen shows manual entry form
- [ ] Can enter barcode manually
- [ ] Can submit barcode and navigate to TagCaptureScreen

### ✅ Tag System
- [ ] Tag autocomplete works
- [ ] Can add new tags
- [ ] Tag chip cloud displays
- [ ] Tag suggestions work
- [ ] Tags persist (SharedPreferences works)

### ✅ Photo Capture (Web)
- [ ] "Capture Photo" button works
- [ ] File picker opens (browser file dialog)
- [ ] Can select image file
- [ ] Photo saves/downloads with correct naming

### ⚠️ Known Limitations
- [ ] Barcode scanning is manual entry (not camera-based)
- [ ] Photos download instead of saving to persistent storage
- [ ] Camera access may require HTTPS in some browsers

## Expected File Naming

Photos should download with format:
```
{barcode}{index}{tag1}-{tag2}.jpg
```

Example:
```
123456789001001front-back.jpg
```

## Troubleshooting

**Error: "Web support is not enabled"**
```bash
flutter config --enable-web
flutter doctor
```

**Error: "No devices found"**
- Make sure Chrome is installed
- Or use: `flutter run -d web-server --web-port 8080`

**Error: Compilation errors**
- Check for import errors
- Verify conditional imports are working
- Run: `flutter clean && flutter pub get`

**Error: Camera/file picker not working**
- Normal on web - uses browser file picker instead
- Photos will download instead of saving to app directory

## Test Results

Document any issues found:

1. **Issues Found:**
   - 

2. **Features Working:**
   - 

3. **Bugs to Fix:**
   - 

