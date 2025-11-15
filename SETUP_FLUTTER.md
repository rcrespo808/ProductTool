# Flutter Setup Guide for Windows

## Finding Flutter Installation

### Option 1: Check Common Locations

Flutter might be installed in:
- `C:\flutter\`
- `C:\src\flutter\`
- `%USERPROFILE%\flutter\`
- `%LOCALAPPDATA%\flutter\`

### Option 2: Search for Flutter

Open PowerShell and run:
```powershell
# Search in user directory
Get-ChildItem -Path $env:USERPROFILE -Filter "flutter" -Recurse -Directory -ErrorAction SilentlyContinue | Select-Object FullName

# Search in C:\ (limited depth for speed)
Get-ChildItem -Path "C:\" -Filter "flutter" -Recurse -Directory -ErrorAction SilentlyContinue -Depth 2 | Select-Object FullName
```

## Installing Flutter (If Not Found)

### Quick Install

1. **Download Flutter SDK:**
   - Visit: https://flutter.dev/docs/get-started/install/windows
   - Download the latest stable release ZIP file

2. **Extract Flutter:**
   ```powershell
   # Example: Extract to C:\src\
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

## Setting Up for Web

Once Flutter is installed:

```powershell
# Enable web support
flutter config --enable-web

# Verify web is enabled
flutter doctor -v

# Run the app
flutter run -d chrome
```

## Alternative: Use Flutter Full Path

If Flutter is installed but not in PATH, you can use the full path:

```powershell
# Example: If Flutter is in C:\src\flutter\
C:\src\flutter\bin\flutter.exe run -d chrome

# Or create an alias for current session
function flutter { & "C:\src\flutter\bin\flutter.exe" $args }
flutter run -d chrome
```

## Quick Setup Script

Create a file `setup_flutter.ps1`:

```powershell
# Check if Flutter is in PATH
$flutterPath = Get-Command flutter -ErrorAction SilentlyContinue

if ($flutterPath) {
    Write-Host "Flutter found at: $($flutterPath.Source)" -ForegroundColor Green
    flutter --version
    flutter config --enable-web
} else {
    Write-Host "Flutter not found in PATH" -ForegroundColor Yellow
    
    # Common paths to check
    $commonPaths = @(
        "C:\flutter\bin\flutter.exe",
        "C:\src\flutter\bin\flutter.exe",
        "$env:USERPROFILE\flutter\bin\flutter.exe",
        "$env:LOCALAPPDATA\flutter\bin\flutter.exe"
    )
    
    foreach ($path in $commonPaths) {
        if (Test-Path $path) {
            Write-Host "Found Flutter at: $path" -ForegroundColor Green
            Write-Host "To use it, run:" -ForegroundColor Yellow
            Write-Host "& '$path' run -d chrome" -ForegroundColor Cyan
            
            # Add to PATH for current session
            $binPath = Split-Path $path
            $env:Path += ";$binPath"
            Write-Host "Added to PATH for this session" -ForegroundColor Green
            break
        }
    }
    
    if (-not (Test-Path $path)) {
        Write-Host "Flutter not found. Please install Flutter first." -ForegroundColor Red
        Write-Host "Visit: https://flutter.dev/docs/get-started/install/windows" -ForegroundColor Cyan
    }
}
```

Run it:
```powershell
.\setup_flutter.ps1
```

## After Setup

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

