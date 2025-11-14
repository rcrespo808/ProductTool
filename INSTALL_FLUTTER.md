# Install Flutter on Windows - Quick Guide

## Step 1: Download Flutter

1. Visit: https://flutter.dev/docs/get-started/install/windows
2. Click "Download Flutter SDK"
3. Download the ZIP file (latest stable version)

## Step 2: Extract Flutter

1. **Choose a location** without spaces or special characters:
   - ✅ Good: `C:\src\flutter`
   - ❌ Bad: `C:\Program Files\flutter` (has spaces)
   - ❌ Bad: `C:\Users\Your Name\flutter` (has spaces)

2. **Extract the ZIP** to your chosen location

## Step 3: Add Flutter to PATH

### Option A: Using PowerShell (Current Session)
```powershell
# Replace C:\src\flutter with your actual Flutter path
$env:Path += ";C:\src\flutter\bin"

# Verify it works
flutter --version
```

### Option B: Permanent Setup (Recommended)

**Using PowerShell (as Administrator):**
```powershell
# Replace C:\src\flutter with your actual Flutter path
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\src\flutter\bin", "User")
```

**Or use GUI:**
1. Press `Win + X` → System
2. Click "Advanced system settings"
3. Click "Environment Variables"
4. Under "User variables", select "Path" → Edit
5. Click "New" → Add `C:\src\flutter\bin` (replace with your path)
6. Click OK on all dialogs
7. **Restart your terminal/PowerShell**

## Step 4: Verify Installation

Open a **new** PowerShell window and run:
```powershell
flutter --version
flutter doctor
```

You should see Flutter version and a diagnostic report.

## Step 5: Enable Web Support

```powershell
flutter config --enable-web
```

Verify web is enabled:
```powershell
flutter doctor
```

Look for "Chrome" or "Web" in the output.

## Step 6: Run the App

Navigate to your project directory:
```powershell
cd F:\dev\icn
```

Install dependencies:
```powershell
flutter pub get
```

Create web platform:
```powershell
flutter create . --platforms=web
```

Run the app:
```powershell
flutter run -d chrome
```

## Troubleshooting

### "Flutter not recognized"
- Make sure you added Flutter to PATH
- **Restart your terminal/PowerShell** after adding to PATH
- Verify the path is correct: `C:\src\flutter\bin\flutter.exe` should exist

### "Web support not enabled"
```powershell
flutter config --enable-web
```

### "Chrome not found"
- Install Google Chrome browser
- Or use: `flutter run -d web-server --web-port 8080`

### "Doctor shows issues"
Run `flutter doctor` and follow the recommendations:
```powershell
flutter doctor
```

Common fixes:
- Install Android Studio (for Android development)
- Install Chrome (for web development)
- Accept Android licenses: `flutter doctor --android-licenses`

## Quick Setup Script

I've created `setup_flutter.ps1` in the project root. Run it:

```powershell
# Allow script execution (if needed)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Run the setup script
.\setup_flutter.ps1
```

The script will:
- ✅ Check if Flutter is already installed
- ✅ Search common locations
- ✅ Guide you to install if not found
- ✅ Help add Flutter to PATH

## After Installation

Once Flutter is working:

1. **Install dependencies:**
   ```powershell
   flutter pub get
   ```

2. **Create web platform:**
   ```powershell
   flutter create . --platforms=web
   ```

3. **Run the app:**
   ```powershell
   flutter run -d chrome
   ```

## Need Help?

- Flutter Installation: https://flutter.dev/docs/get-started/install/windows
- Flutter Troubleshooting: https://flutter.dev/docs/get-started/install/windows#troubleshooting
- Run `flutter doctor` for diagnostics

