/// Platform-specific implementation of LocalStorageService
/// This file uses conditional imports to select the correct implementation:
/// - Mobile (Android/iOS): Uses dart:io and path_provider
/// - Web: Uses dart:html browser download API
library;

// Conditional imports: web gets web implementation, others get mobile
export 'local_storage_impl_stub.dart'
    if (dart.library.io) 'local_storage_impl_mobile.dart'
    if (dart.library.html) 'local_storage_impl_web.dart';

