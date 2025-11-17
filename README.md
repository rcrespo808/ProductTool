# Product Audit Tool

A Flutter-based mobile/web application for auditing supermarket products by scanning barcodes, capturing photos, and tagging them with a smart tag trie system.

## Overview

This tool enables field auditors to:
- Scan product barcodes
- Capture multiple photos per product
- Tag photos with an intelligent autocomplete system
- Save photos locally with a deterministic naming convention
- Export audit sessions for backend processing

## Documentation

- **[PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md)** - Project purpose, workflow, and constraints
- **[TECH_STRUCTURE.md](TECH_STRUCTURE.md)** - Architecture, folder structure, and abstractions
- **[IMPLEMENTATION_CHECKLIST.md](IMPLEMENTATION_CHECKLIST.md)** - Implementation status and checklist
- **[QUICK_START.md](QUICK_START.md)** - Quick start guide with Flutter installation and setup
- **[WEB.md](WEB.md)** - Web platform support and testing
- **[MANUAL_TESTING.md](MANUAL_TESTING.md)** - Manual testing guide
- **[TEST_PLAN.md](TEST_PLAN.md)** - Testing strategy and requirements

## Quick Start

### Prerequisites
- Flutter SDK (latest stable)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Setup
1. **Install Flutter** (if needed): See [QUICK_START.md](QUICK_START.md) for installation instructions
2. **Install dependencies**: `flutter pub get`
3. **Create platform folders** (if needed): `flutter create .`
4. **Configure permissions**: See [QUICK_START.md](QUICK_START.md) for Android/iOS permissions
5. **Run the app**: `flutter run` (mobile) or `flutter run -d chrome` (web)

For detailed setup instructions, see [QUICK_START.md](QUICK_START.md).  
For web setup, see [WEB.md](WEB.md).

### Testing
- **Manual Testing**: See [MANUAL_TESTING.md](MANUAL_TESTING.md) for comprehensive test scenarios
- **Test Plan**: See [TEST_PLAN.md](TEST_PLAN.md) for testing strategy

### Key Features
- **Barcode Scanning**: Real-time barcode detection using camera
- **Photo Capture**: Multiple photos per product audit
- **Tag Trie System**: Smart tag autocomplete with usage frequency
- **Local Storage**: Persistent photo and tag storage
- **Session Management**: Track audit sessions with multiple images

## Project Structure

See [TECH_STRUCTURE.md](TECH_STRUCTURE.md) for detailed architecture.

## Implementation Status

✅ **Iteration 1 Complete** - All core features implemented:
- Mobile support (Android/iOS) with barcode scanning
- Web support with manual barcode entry
- Tag trie system with persistence
- Photo capture and tagging
- Session management

See [IMPLEMENTATION_CHECKLIST.md](IMPLEMENTATION_CHECKLIST.md) for detailed status.

## Platform Support

- **Mobile (Android/iOS)**: Full feature support with camera-based barcode scanning
- **Web**: Manual barcode entry, file picker for photos, tag system works fully

See [WEB.md](WEB.md) for web platform details and limitations.

## License

[Add license information here]

