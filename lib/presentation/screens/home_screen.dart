import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../utils/result.dart';
import '../../utils/ic_norte_theme.dart';
import '../../domain/models/audit_session.dart';
import '../../domain/models/audit_session_status.dart';
import '../../domain/models/processing_status.dart';
import '../../domain/models/audit_review_summary.dart';
import 'barcode_scan_screen.dart';
import 'audit_review_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

enum SessionFilter {
  all,
  needsReview,
  withErrors,
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<AuditSession> _sessions = [];
  List<AuditSession> _filteredSessions = [];
  bool _isLoading = true;
  String? _error;
  SessionFilter _currentFilter = SessionFilter.all;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final sessionRepo = ref.read(sessionRepositoryProvider);
    final result = await sessionRepo.getCompletedSessions();

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result.isSuccess) {
          _sessions = result.valueOrNull ?? [];
          _applyFilter();
        } else {
          _error = result.errorMessage ?? 'Failed to load sessions';
        }
      });
    }
  }

  void _applyFilter() {
    setState(() {
      switch (_currentFilter) {
        case SessionFilter.all:
          _filteredSessions = _sessions;
          break;
        case SessionFilter.needsReview:
          _filteredSessions = _sessions.where((s) {
            final summary = s.reviewSummary;
            return summary == AuditReviewSummary.unknown ||
                summary == AuditReviewSummary.partiallyApproved;
          }).toList();
          break;
        case SessionFilter.withErrors:
          _filteredSessions = _sessions.where((s) {
            return s.images.any(
              (img) => img.processingStatus == ProcessingStatus.processedError,
            );
          }).toList();
          break;
      }
      // Sort: needs review first, then by completion date (most recent first)
      _filteredSessions.sort((a, b) {
        final aNeedsReview = a.reviewSummary == AuditReviewSummary.unknown ||
            a.reviewSummary == AuditReviewSummary.partiallyApproved;
        final bNeedsReview = b.reviewSummary == AuditReviewSummary.unknown ||
            b.reviewSummary == AuditReviewSummary.partiallyApproved;

        if (aNeedsReview && !bNeedsReview) return -1;
        if (!aNeedsReview && bNeedsReview) return 1;

        final aDate = a.completedAt ?? a.createdAt;
        final bDate = b.completedAt ?? b.createdAt;
        return bDate.compareTo(aDate);
      });
    });
  }

  Widget _buildProcessingChip(AuditSession session) {
    final hasErrors = session.images
        .any((img) => img.processingStatus == ProcessingStatus.processedError);
    final allProcessed = session.images.every(
      (img) => img.processingStatus == ProcessingStatus.processedOk,
    );

    String label;
    Color color;
    IconData icon;

    if (hasErrors) {
      label = 'Errors';
      color = ICNColors.statusError;
      icon = Icons.error;
    } else if (allProcessed) {
      label = 'Processed';
      color = ICNColors.statusSuccess;
      icon = Icons.check_circle;
    } else {
      label = 'Pending';
      color = ICNColors.statusWarning;
      icon = Icons.hourglass_empty;
    }

    return Chip(
      avatar: Icon(icon, size: 12, color: color),
      label: Text(
        label,
        style: ICNTypography.labelSmall.copyWith(color: color),
      ),
      backgroundColor: color.withOpacity(0.1),
      padding: EdgeInsets.symmetric(horizontal: ICNSpacing.xs, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ICNRadius.chip),
      ),
    );
  }

  Widget _buildReviewChip(AuditSession session, BuildContext context) {
    final colors = ICNColors.of(context);
    final summary = session.reviewSummary;

    String label;
    Color color;
    IconData icon;

    switch (summary) {
      case AuditReviewSummary.fullyApproved:
        label = 'Approved';
        color = ICNColors.statusSuccess;
        icon = Icons.check_circle;
        break;
      case AuditReviewSummary.partiallyApproved:
        label = 'Partial';
        color = ICNColors.statusWarning;
        icon = Icons.check_circle_outline;
        break;
      case AuditReviewSummary.fullyRejected:
        label = 'Rejected';
        color = ICNColors.statusError;
        icon = Icons.cancel;
        break;
      case AuditReviewSummary.unknown:
        label = 'Unreviewed';
        color = colors.textSecondary;
        icon = Icons.radio_button_unchecked;
        break;
    }

    return Chip(
      avatar: Icon(icon, size: 12, color: color),
      label: Text(
        label,
        style: ICNTypography.labelSmall.copyWith(color: color),
      ),
      backgroundColor: color.withOpacity(0.1),
      padding: EdgeInsets.symmetric(horizontal: ICNSpacing.xs, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ICNRadius.chip),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = ICNColors.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ICNColors.brandForest,
        title: const Text('Product Audit Tool'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error!,
                        style: ICNTypography.bodyMedium.copyWith(
                          color: ICNColors.statusError,
                        ),
                      ),
                      SizedBox(height: ICNSpacing.lg),
                      ElevatedButton(
                        onPressed: _loadSessions,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Filter bar
                    if (_sessions.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ICNSpacing.sm,
                          vertical: ICNSpacing.sm,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildFilterChip('All', SessionFilter.all),
                            SizedBox(width: ICNSpacing.sm),
                            _buildFilterChip('Needs Review', SessionFilter.needsReview),
                            SizedBox(width: ICNSpacing.sm),
                            _buildFilterChip('With Errors', SessionFilter.withErrors),
                          ],
                        ),
                      ),

                    // Past sessions list
                    Expanded(
                      child: _filteredSessions.isEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.all(ICNSpacing.xxl),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.history,
                                      size: 64,
                                      color: colors.textSecondary,
                                    ),
                                    SizedBox(height: ICNSpacing.lg),
                                    Text(
                                      'No past sessions',
                                      style: ICNTypography.headlineLarge.copyWith(
                                        color: colors.textPrimary.withOpacity(0.7),
                                      ),
                                    ),
                                    SizedBox(height: ICNSpacing.sm),
                                    Text(
                                      'Start your first audit session',
                                      style: ICNTypography.bodyMedium.copyWith(
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadSessions,
                              child: ListView.builder(
                                padding: EdgeInsets.all(ICNSpacing.sm),
                                itemCount: _filteredSessions.length,
                                itemBuilder: (context, index) {
                                  final session = _filteredSessions[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: ICNSpacing.sm,
                                      vertical: ICNSpacing.xs,
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: session.status ==
                                                AuditSessionStatus.completed
                                            ? ICNColors.statusSuccess
                                            : ICNColors.statusWarning,
                                        child: Icon(
                                          session.status ==
                                                  AuditSessionStatus.completed
                                              ? Icons.check
                                              : Icons.hourglass_empty,
                                          color: ICNColors.textOnBrand,
                                        ),
                                      ),
                                      title: Text(
                                        'Barcode: ${session.barcode}',
                                        style: ICNTypography.titleLarge,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: ICNSpacing.xs),
                                          Text(
                                            '${session.imageCount} photo(s)',
                                            style: ICNTypography.bodyMedium,
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            'Created: ${_formatDateTime(session.createdAt)}',
                                            style: ICNTypography.labelLarge.copyWith(
                                              color: colors.textSecondary,
                                            ),
                                          ),
                                          if (session.completedAt != null)
                                            Text(
                                              'Completed: ${_formatDateTime(session.completedAt!)}',
                                              style: ICNTypography.labelLarge.copyWith(
                                                color: colors.textSecondary,
                                              ),
                                            ),
                                        ],
                                      ),
                                      trailing: SizedBox(
                                        width: 100,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerRight,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              _buildProcessingChip(session),
                                              SizedBox(height: 1),
                                              _buildReviewChip(session, context),
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => AuditReviewScreen(
                                              barcode: session.barcode,
                                              createdAt: session.createdAt,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),

                    // Start Audit button
                    Padding(
                      padding: EdgeInsets.all(ICNSpacing.lg),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const BarcodeScanScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.qr_code_scanner),
                          label: const Text('Start Audit'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: ICNSpacing.lg),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ICNRadius.button),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadSessions,
        tooltip: 'Refresh sessions',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  Widget _buildFilterChip(String label, SessionFilter filter) {
    final isSelected = _currentFilter == filter;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _currentFilter = filter;
            _applyFilter();
          });
        }
      },
    );
  }
}
