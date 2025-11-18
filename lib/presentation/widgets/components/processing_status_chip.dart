import 'package:flutter/material.dart';
import '../../../domain/models/processing_status.dart';
import '../../../utils/ic_norte_theme.dart';

/// Widget that displays a chip showing the processing status of an image
class ProcessingStatusChip extends StatelessWidget {
  final ProcessingStatus status;

  const ProcessingStatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ICNColors.of(context);
    final (label, color, icon) = _getStatusInfo(colors);

    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        label,
        style: ICNTypography.labelLarge.copyWith(color: color),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
      padding: EdgeInsets.symmetric(horizontal: ICNSpacing.xs, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ICNRadius.chip),
      ),
    );
  }

  (String, Color, IconData) _getStatusInfo(dynamic colors) {
    switch (status) {
      case ProcessingStatus.unknown:
        return ('Unknown', colors.textSecondary, Icons.help_outline);
      case ProcessingStatus.pending:
        return ('Pending', ICNColors.statusWarning, Icons.hourglass_empty);
      case ProcessingStatus.processedOk:
        return ('Processed', ICNColors.statusSuccess, Icons.check_circle);
      case ProcessingStatus.processedError:
        return ('Error', ICNColors.statusError, Icons.error);
    }
  }
}

