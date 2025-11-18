import 'package:flutter/material.dart';
import '../../../domain/models/review_status.dart';
import '../../../utils/ic_norte_theme.dart';

/// Widget that displays a chip showing the review status of an image
class ReviewStatusChip extends StatelessWidget {
  final ReviewStatus status;

  const ReviewStatusChip({
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
      case ReviewStatus.unknown:
        return ('Not reviewed', colors.textSecondary, Icons.radio_button_unchecked);
      case ReviewStatus.approved:
        return ('Approved', ICNColors.statusSuccess, Icons.check_circle);
      case ReviewStatus.rejected:
        return ('Rejected', ICNColors.statusError, Icons.cancel);
    }
  }
}

