import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import '../../../domain/models/audit_image.dart';
import '../../../domain/models/review_status.dart';
import '../../../utils/ic_norte_theme.dart';
import 'processing_status_chip.dart';
import 'review_status_chip.dart';

/// Card widget for displaying an individual image in the review screen
class ImageReviewCard extends StatelessWidget {
  final AuditImage image;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const ImageReviewCard({
    super.key,
    required this.image,
    this.onApprove,
    this.onReject,
  });

  String _formatDateTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Validates if a string is a valid HTTP/HTTPS URL
  bool _isValidUrl(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  /// Builds the local image widget (fallback)
  Widget _buildLocalImage(BuildContext context) {
    final colors = ICNColors.of(context);
    if (kIsWeb) {
      // On web, Image.file doesn't work with dart:io File
      return Container(
        height: 200,
        color: colors.bgSurfaceAlt,
        child: Icon(Icons.image, size: 48, color: colors.textSecondary),
      );
    } else {
      return Image.file(
        File(image.localPath),
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            color: colors.bgSurfaceAlt,
            child: Icon(Icons.broken_image, size: 48, color: colors.textSecondary),
          );
        },
      );
    }
  }

  /// Builds the image widget, preferring remote processed image if available
  Widget _buildImageWidget(BuildContext context) {
    final colors = ICNColors.of(context);
    // Prefer remote URL if available and valid
    final remoteUrl = image.remoteUrl;
    if (remoteUrl != null && _isValidUrl(remoteUrl)) {
      return Stack(
        children: [
          Image.network(
            remoteUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 200,
                color: colors.bgSurfaceAlt,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              // Fallback to local image if network fails
              return _buildLocalImage(context);
            },
          ),
          // Small indicator badge showing this is the processed image
          Positioned(
            top: ICNSpacing.sm,
            right: ICNSpacing.sm,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: ICNColors.statusSuccess.withOpacity(0.9),
                borderRadius: BorderRadius.circular(ICNRadius.xs),
              ),
              child: Text(
                'Processed',
                style: ICNTypography.badgeText.copyWith(
                  color: ICNColors.textOnBrand,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Fallback to local image
    return _buildLocalImage(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = ICNColors.of(context);
    final isApproved = image.reviewStatus == ReviewStatus.approved;
    final isRejected = image.reviewStatus == ReviewStatus.rejected;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: ICNSpacing.lg, vertical: ICNSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image thumbnail
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(ICNRadius.card)),
            child: _buildImageWidget(context),
          ),

          // Content section
          Padding(
            padding: EdgeInsets.all(ICNSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image index and capture time
                Row(
                  children: [
                    Text(
                      '#${image.index}',
                      style: ICNTypography.titleLarge,
                    ),
                    SizedBox(width: ICNSpacing.sm),
                    Text(
                      'Captured at ${_formatDateTime(image.createdAt)}',
                      style: ICNTypography.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ICNSpacing.sm),

                // Status chips row
                Wrap(
                  spacing: ICNSpacing.sm,
                  runSpacing: ICNSpacing.sm,
                  children: [
                    ProcessingStatusChip(status: image.processingStatus),
                    ReviewStatusChip(status: image.reviewStatus),
                  ],
                ),

                SizedBox(height: ICNSpacing.md),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: isApproved ? null : onApprove,
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Approve'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ICNColors.statusSuccess,
                          side: BorderSide(
                            color: isApproved
                                ? ICNColors.statusSuccess
                                : ICNColors.statusSuccess.withOpacity(0.5),
                          ),
                          backgroundColor: isApproved
                              ? ICNColors.statusSuccess.withOpacity(0.1)
                              : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ICNRadius.button),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: ICNSpacing.sm,
                            vertical: 6,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: ICNSpacing.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: isRejected ? null : onReject,
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('Reject'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ICNColors.statusError,
                          side: BorderSide(
                            color: isRejected
                                ? ICNColors.statusError
                                : ICNColors.statusError.withOpacity(0.5),
                          ),
                          backgroundColor: isRejected
                              ? ICNColors.statusError.withOpacity(0.1)
                              : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ICNRadius.button),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: ICNSpacing.sm,
                            vertical: 6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

