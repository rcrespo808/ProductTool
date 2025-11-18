# Product Audit Tool

A Flutter-based mobile/web application for auditing supermarket products by scanning barcodes and capturing multiple photos per product.

## Overview

This tool enables field auditors to:
- Scan product barcodes
- Capture multiple photos per product
- Save photos locally with sequential naming (`{barcode}__{index}.jpg`)
- Export audit sessions for backend processing

## Documentation

- **[docs/PROJECT_OVERVIEW.md](docs/PROJECT_OVERVIEW.md)** - Project purpose, workflow, constraints, and implementation status
- **[docs/TECH_STRUCTURE.md](docs/TECH_STRUCTURE.md)** - Architecture, folder structure, and abstractions
- **[docs/QUICK_START.md](docs/QUICK_START.md)** - Quick start guide with Flutter installation and setup
- **[docs/WEB.md](docs/WEB.md)** - Web platform support and testing
- **[docs/TEST_PLAN.md](docs/TEST_PLAN.md)** - Testing strategy, requirements, and manual testing scenarios
- **[docs/UI_UX_GUIDELINES.md](docs/UI_UX_GUIDELINES.md)** - Design system, color palette, shadow/elevation, and UI component patterns

## Quick Start

### Prerequisites
- Flutter SDK (latest stable)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Setup
1. **Install Flutter** (if needed): See [docs/QUICK_START.md](docs/QUICK_START.md) for installation instructions
2. **Install dependencies**: `flutter pub get`
3. **Create platform folders** (if needed): `flutter create .`
4. **Configure permissions**: See [docs/QUICK_START.md](docs/QUICK_START.md) for Android/iOS permissions
5. **Run the app**: `flutter run` (mobile) or `flutter run -d chrome` (web)

For detailed setup instructions, see [docs/QUICK_START.md](docs/QUICK_START.md).  
For web setup, see [docs/WEB.md](docs/WEB.md).

### Testing
- **Test Plan**: See [docs/TEST_PLAN.md](docs/TEST_PLAN.md) for testing strategy and manual testing scenarios

### Key Features
- **Barcode Scanning**: Real-time barcode detection using camera
- **Photo Capture**: Multiple photos per product audit
- **Sequential Naming**: Photos saved as `{barcode}__{index}.jpg`
- **Local Storage**: Persistent photo storage
- **Session Management**: Track audit sessions with multiple images

## Project Structure

See [docs/TECH_STRUCTURE.md](docs/TECH_STRUCTURE.md) for detailed architecture.

## Implementation Status

✅ **Iteration 1 Complete** - All core features implemented:
- Mobile support (Android/iOS) with barcode scanning
- Web support with manual barcode entry
- Photo capture with sequential naming
- Session management

See [docs/PROJECT_OVERVIEW.md](docs/PROJECT_OVERVIEW.md) for detailed implementation status.

## Platform Support

- **Mobile (Android/iOS)**: Full feature support with camera-based barcode scanning
- **Web**: Manual barcode entry, file picker for photos

See [docs/WEB.md](docs/WEB.md) for web platform details and limitations.

## License

[Add license information here]

