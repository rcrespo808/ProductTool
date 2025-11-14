# How to Launch App on Web

## Quick Start

1. **Enable web support** (if not already enabled):
   ```bash
   flutter config --enable-web
   ```

2. **Create web platform files** (if `web/` folder doesn't exist):
   ```bash
   flutter create . --platforms=web
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run on Chrome**:
   ```bash
   flutter run -d chrome
   ```

   Or specify the port:
   ```bash
   flutter run -d web-server --web-port 8080
   ```

## Alternative Launch Methods

### Option 1: Chrome Browser (Recommended)
```bash
flutter run -d chrome
```

### Option 2: Web Server Mode
```bash
flutter run -d web-server --web-port 8080
```
Then open: `http://localhost:8080`

### Option 3: Build and Serve
```bash
# Build for web
flutter build web

# Serve the build (choose one method)
cd build/web

# Python 3
python -m http.server 8000

# Python 2
python -m SimpleHTTPServer 8000

# Node.js (if you have http-server installed)
npx http-server -p 8000
```

Then open: `http://localhost:8000`

## Important Notes

⚠️ **Web Limitations:**
- Barcode scanning (`mobile_scanner`) does NOT work on web
- You'll see errors when trying to scan barcodes
- Consider adding manual barcode entry for web (see WEB_SETUP.md)

✅ **What Works on Web:**
- Basic UI and navigation
- Tag system (autocomplete, suggestions)
- SharedPreferences (tag persistence)
- File picker (limited camera support)

## Troubleshooting

**Issue: "Web support is not enabled"**
```bash
flutter config --enable-web
flutter doctor
```

**Issue: "No web devices found"**
- Make sure Chrome is installed
- Or use `-d web-server` for server mode

**Issue: Camera not working**
- Requires HTTPS in production
- Localhost works for development
- Browser may block camera access (check permissions)

**Issue: Barcode scanner fails**
- Expected behavior - `mobile_scanner` doesn't support web
- Need to implement web-specific barcode scanning
- See WEB_SETUP.md for alternatives

## Development vs Production

**Development:**
- HTTP (localhost) works fine
- Hot reload available
- Debug console shows errors

**Production:**
- Requires HTTPS for camera access
- Need to build and deploy
- Consider using Firebase Hosting, Vercel, or similar

## Next Steps

1. Launch app: `flutter run -d chrome`
2. Test basic UI functionality
3. Note barcode scanning limitations
4. Consider implementing web-specific barcode entry
5. See WEB_SETUP.md for detailed web configuration

