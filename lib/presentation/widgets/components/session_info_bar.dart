import 'package:flutter/material.dart';
import 'info_chip.dart';

/// Widget that displays session information (barcode and photo count)
/// in a horizontal bar with info chips
class SessionInfoBar extends StatelessWidget {
  final String? barcode;
  final int imageCount;

  const SessionInfoBar({
    super.key,
    required this.barcode,
    required this.imageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InfoChip(
            icon: Icons.qr_code,
            label: 'Barcode',
            value: barcode ?? 'Unknown',
          ),
          InfoChip(
            icon: Icons.photo_library,
            label: 'Photos',
            value: '$imageCount',
          ),
        ],
      ),
    );
  }
}

