import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'barcode_scan_screen_mobile_wrapper.dart';

/// Barcode scan screen that automatically selects the correct implementation
/// based on the platform (web vs mobile)
class BarcodeScanScreen extends ConsumerWidget {
  const BarcodeScanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const BarcodeScannerWidget();
  }
}
