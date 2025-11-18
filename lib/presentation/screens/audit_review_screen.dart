import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/processing_status.dart';
import '../../domain/models/review_status.dart';
import '../../providers/providers.dart';
import '../../utils/ic_norte_theme.dart';
import '../widgets/components/image_review_card.dart';

/// Screen for reviewing audit session images
class AuditReviewScreen extends ConsumerStatefulWidget {
  final String barcode;
  final DateTime createdAt;

  const AuditReviewScreen({
    super.key,
    required this.barcode,
    required this.createdAt,
  });

  @override
  ConsumerState<AuditReviewScreen> createState() => _AuditReviewScreenState();
}

class _AuditReviewScreenState extends ConsumerState<AuditReviewScreen> {
  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final colors = ICNColors.of(context);
    final reviewState = ref.watch(
      auditReviewProvider((barcode: widget.barcode, createdAt: widget.createdAt)),
    );
    final reviewNotifier = ref.read(
      auditReviewProvider((barcode: widget.barcode, createdAt: widget.createdAt)).notifier,
    );

    final session = reviewState.session;

    if (reviewState.isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ICNColors.brandForest,
          title: const Text('Loading...'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (session == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ICNColors.brandForest,
          title: const Text('Review Session'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: ICNColors.statusError),
              SizedBox(height: ICNSpacing.lg),
              Text(
                reviewState.error ?? 'Session not found',
                style: ICNTypography.titleLarge,
              ),
              SizedBox(height: ICNSpacing.lg),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    // Calculate summary statistics
    final processedOkCount = session.images
        .where((img) => img.processingStatus == ProcessingStatus.processedOk)
        .length;
    final processedErrorCount = session.images
        .where((img) => img.processingStatus == ProcessingStatus.processedError)
        .length;
    final pendingCount = session.images
        .where((img) => img.processingStatus == ProcessingStatus.pending ||
            img.processingStatus == ProcessingStatus.unknown)
        .length;

    final approvedCount =
        session.images.where((img) => img.reviewStatus == ReviewStatus.approved).length;
    final rejectedCount =
        session.images.where((img) => img.reviewStatus == ReviewStatus.rejected).length;
    final unreviewedCount =
        session.images.where((img) => img.reviewStatus == ReviewStatus.unknown).length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ICNColors.brandForest,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('EAN ${session.barcode}'),
            Text(
              '${session.imageCount} images · Completed ${_formatDateTime(session.completedAt ?? session.createdAt)}',
              style: ICNTypography.labelLarge,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Summary strip
          Container(
            padding: EdgeInsets.all(ICNSpacing.lg),
            color: colors.bgSurfaceAlt,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Backend: ', style: ICNTypography.titleMedium),
                    if (processedOkCount > 0)
                      Text('✅ $processedOkCount',
                          style: ICNTypography.bodyMedium.copyWith(
                            color: ICNColors.statusSuccess,
                          )),
                    if (processedErrorCount > 0) ...[
                      const Text(' · '),
                      Text('⚠ $processedErrorCount',
                          style: ICNTypography.bodyMedium.copyWith(
                            color: ICNColors.statusError,
                          )),
                    ],
                    if (pendingCount > 0) ...[
                      const Text(' · '),
                      Text('⏳ $pendingCount',
                          style: ICNTypography.bodyMedium.copyWith(
                            color: ICNColors.statusWarning,
                          )),
                    ],
                  ],
                ),
                SizedBox(height: ICNSpacing.xs),
                Row(
                  children: [
                    Text('Review: ', style: ICNTypography.titleMedium),
                    if (approvedCount > 0)
                      Text('🟢 $approvedCount',
                          style: ICNTypography.bodyMedium.copyWith(
                            color: ICNColors.statusSuccess,
                          )),
                    if (rejectedCount > 0) ...[
                      const Text(' · '),
                      Text('🔴 $rejectedCount',
                          style: ICNTypography.bodyMedium.copyWith(
                            color: ICNColors.statusError,
                          )),
                    ],
                    if (unreviewedCount > 0) ...[
                      const Text(' · '),
                      Text('⚪ $unreviewedCount',
                          style: ICNTypography.bodyMedium.copyWith(
                            color: colors.textSecondary,
                          )),
                    ],
                  ],
                ),
                if (reviewState.isCheckingBackend) ...[
                  SizedBox(height: ICNSpacing.sm),
                  const LinearProgressIndicator(),
                ],
              ],
            ),
          ),

          // Images list
          Expanded(
            child: session.images.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: colors.textSecondary,
                        ),
                        SizedBox(height: ICNSpacing.lg),
                        Text(
                          'No images in this session',
                          style: ICNTypography.titleLarge.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => reviewNotifier.checkBackendStatus(),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: ICNSpacing.sm),
                      itemCount: session.images.length,
                      itemBuilder: (context, index) {
                        final image = session.images[index];
                        return ImageReviewCard(
                          image: image,
                          onApprove: () => reviewNotifier.approveImage(image.index),
                          onReject: () => reviewNotifier.rejectImage(image.index),
                        );
                      },
                    ),
                  ),
          ),

          // Bottom toolbar
          if (session.images.isNotEmpty)
            Container(
              padding: EdgeInsets.all(ICNSpacing.lg),
              decoration: BoxDecoration(
                color: colors.bgSurface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: reviewState.isCheckingBackend
                        ? null
                        : () => reviewNotifier.approveAllProcessed(),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Approve all OK images'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: ICNSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ICNRadius.button),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

