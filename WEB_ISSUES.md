# Critical Issues for Web Support

Before the app can run on web, these issues must be addressed:

## 🚨 Critical Issues

### 1. `dart:io` Import in `local_storage_impl.dart`

**Problem:** 
- Line 1: `import 'dart:io';`
- `dart:io` is **NOT available on web**
- Will cause compilation error

**Fix Required:**
Use conditional imports:
```dart
import 'local_storage_service.dart';
import '../util/result.dart';

// Conditional import
import 'package:flutter/foundation.dart' show kIsWeb;

if (kIsWeb) {
  // Web implementation using browser download API
} else {
  // Mobile implementation using dart:io
}
```

### 2. `mobile_scanner` Package

**Problem:**
- Does NOT support web platform
- Will fail when trying to use on web

**Fix Required:**
- Add platform detection in `BarcodeScanScreen`
- Show manual text input for web
- Or use a web-compatible barcode scanner library

### 3. `Directory` and `File` Usage

**Problem:**
- Lines using `Directory` and `File` from `dart:io` won't compile on web
- Need platform-specific implementations

**Fix Required:**
- Create web-specific storage implementation
- Use browser download API for web
- Keep mobile implementation for Android/iOS

## Quick Fixes Needed

### Option A: Platform Detection (Recommended)

Modify `local_storage_impl.dart`:

```dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'local_storage_service.dart';
import '../util/result.dart';

// Conditional imports
import 'local_storage_impl_mobile.dart' if (dart.library.html) 'local_storage_impl_web.dart';
```

Then create:
- `local_storage_impl_mobile.dart` (with `dart:io`)
- `local_storage_impl_web.dart` (using browser APIs)

### Option B: Disable Web Temporarily

For now, you can:
1. Remove web folder: `rm -rf web`
2. Focus on mobile platforms
3. Add web support later

## Steps to Run on Web (After Fixes)

1. **Enable web support:**
   ```bash
   flutter config --enable-web
   ```

2. **Create web platform:**
   ```bash
   flutter create . --platforms=web
   ```

3. **Fix the issues above**

4. **Run:**
   ```bash
   flutter run -d chrome
   ```

## Current Status

❌ **Won't compile on web** due to `dart:io` usage
❌ **Barcode scanning won't work** (mobile_scanner limitation)
⚠️ **File storage needs web implementation**

## Recommendation

1. **For immediate web testing:** Fix `dart:io` imports first
2. **For full web support:** Implement platform-specific code for:
   - Storage (web vs mobile)
   - Barcode scanning (manual entry for web)
   - File downloads (browser download API)

See `WEB_SETUP.md` for detailed implementation guide.

