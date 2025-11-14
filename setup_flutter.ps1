# Flutter Setup Helper Script for Windows
# This script helps find or guide you to install Flutter

Write-Host "=== Flutter Setup Helper ===" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is already in PATH
$flutterInPath = Get-Command flutter -ErrorAction SilentlyContinue

if ($flutterInPath) {
    Write-Host "✅ Flutter found in PATH at: $($flutterInPath.Source)" -ForegroundColor Green
    Write-Host ""
    Write-Host "Version:" -ForegroundColor Yellow
    flutter --version
    Write-Host ""
    
    # Check if web is enabled
    $webConfig = flutter config | Select-String "enable-web"
    if ($webConfig -match "true") {
        Write-Host "✅ Web support is enabled" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Web support not enabled. Enabling now..." -ForegroundColor Yellow
        flutter config --enable-web
    }
    
    Write-Host ""
    Write-Host "You can now run:" -ForegroundColor Cyan
    Write-Host "  flutter pub get" -ForegroundColor White
    Write-Host "  flutter create . --platforms=web" -ForegroundColor White
    Write-Host "  flutter run -d chrome" -ForegroundColor White
    exit 0
}

Write-Host "❌ Flutter not found in PATH" -ForegroundColor Red
Write-Host ""
Write-Host "Searching common installation locations..." -ForegroundColor Yellow

# Common paths to check
$commonPaths = @(
    "C:\flutter\bin\flutter.exe",
    "C:\src\flutter\bin\flutter.exe",
    "$env:USERPROFILE\flutter\bin\flutter.exe",
    "$env:LOCALAPPDATA\flutter\bin\flutter.exe",
    "$env:PROGRAMFILES\flutter\bin\flutter.exe",
    "$env:PROGRAMFILES(X86)\flutter\bin\flutter.exe"
)

$foundFlutter = $null

foreach ($path in $commonPaths) {
    if (Test-Path $path) {
        $foundFlutter = $path
        Write-Host "✅ Found Flutter at: $path" -ForegroundColor Green
        break
    }
}

if ($foundFlutter) {
    Write-Host ""
    Write-Host "To use Flutter for this session, run:" -ForegroundColor Cyan
    Write-Host "  `$env:Path += `";$((Split-Path $foundFlutter))`"" -ForegroundColor White
    Write-Host ""
    Write-Host "Or use the full path:" -ForegroundColor Cyan
    Write-Host "  & `"$foundFlutter`" --version" -ForegroundColor White
    Write-Host ""
    Write-Host "To add Flutter to PATH permanently:" -ForegroundColor Cyan
    Write-Host "  [Environment]::SetEnvironmentVariable(`"Path`", `$env:Path + `";$((Split-Path $foundFlutter))`", `"User`")" -ForegroundColor White
    Write-Host ""
    
    # Offer to add to PATH for current session
    $addToPath = Read-Host "Add Flutter to PATH for this session? (Y/N)"
    if ($addToPath -eq 'Y' -or $addToPath -eq 'y') {
        $binPath = Split-Path $foundFlutter
        $env:Path += ";$binPath"
        Write-Host "✅ Added to PATH for this session" -ForegroundColor Green
        Write-Host ""
        flutter --version
        Write-Host ""
        
        # Enable web support
        flutter config --enable-web
        Write-Host ""
        Write-Host "You can now run:" -ForegroundColor Cyan
        Write-Host "  flutter pub get" -ForegroundColor White
        Write-Host "  flutter create . --platforms=web" -ForegroundColor White
        Write-Host "  flutter run -d chrome" -ForegroundColor White
    }
} else {
    Write-Host "❌ Flutter not found in common locations" -ForegroundColor Red
    Write-Host ""
    Write-Host "=== Flutter Installation Guide ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Download Flutter SDK:" -ForegroundColor Yellow
    Write-Host "   https://flutter.dev/docs/get-started/install/windows" -ForegroundColor White
    Write-Host ""
    Write-Host "2. Extract Flutter:" -ForegroundColor Yellow
    Write-Host "   - Download the ZIP file" -ForegroundColor White
    Write-Host "   - Extract to C:\src\flutter (or another location)" -ForegroundColor White
    Write-Host "   - DO NOT extract to a path with spaces or special characters" -ForegroundColor White
    Write-Host ""
    Write-Host "3. Add Flutter to PATH:" -ForegroundColor Yellow
    Write-Host "   - Find the `bin` folder inside the Flutter directory" -ForegroundColor White
    Write-Host "   - Add it to your system PATH environment variable" -ForegroundColor White
    Write-Host ""
    Write-Host "4. Verify installation:" -ForegroundColor Yellow
    Write-Host "   - Open a new PowerShell window" -ForegroundColor White
    Write-Host "   - Run: flutter doctor" -ForegroundColor White
    Write-Host ""
    Write-Host "5. Enable web support:" -ForegroundColor Yellow
    Write-Host "   - Run: flutter config --enable-web" -ForegroundColor White
    Write-Host ""
    
    # Offer to open browser
    $openBrowser = Read-Host "Open Flutter installation page in browser? (Y/N)"
    if ($openBrowser -eq 'Y' -or $openBrowser -eq 'y') {
        Start-Process "https://flutter.dev/docs/get-started/install/windows"
    }
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

