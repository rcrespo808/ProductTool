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
- **[IMPLEMENTATION_CHECKLIST.md](IMPLEMENTATION_CHECKLIST.md)** - Step-by-step implementation guide
- **[TEST_PLAN.md](TEST_PLAN.md)** - Testing strategy and requirements

## Quick Start

### Prerequisites
- Flutter SDK (latest stable)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Setup
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter create .` if `android/` and `ios/` folders don't exist
4. Add camera and storage permissions (see [SETUP_GUIDE.md](SETUP_GUIDE.md))
5. Run `flutter run` to launch the app

For detailed setup instructions, see [SETUP_GUIDE.md](SETUP_GUIDE.md) or [QUICK_START.md](QUICK_START.md)

### Manual Testing
See [MANUAL_TESTING.md](MANUAL_TESTING.md) for comprehensive testing guide.

### Key Features
- **Barcode Scanning**: Real-time barcode detection using camera
- **Photo Capture**: Multiple photos per product audit
- **Tag Trie System**: Smart tag autocomplete with usage frequency
- **Local Storage**: Persistent photo and tag storage
- **Session Management**: Track audit sessions with multiple images

## Project Structure

See [TECH_STRUCTURE.md](TECH_STRUCTURE.md) for detailed architecture.

## Development Workflow

Refer to `.cursor/commands/code.md` for the development workflow, which includes:
1. **DRY-RUN**: Review docs, audit code, propose plan
2. **APPLY**: Implement changes following the documented architecture

## License

[Add license information here]

