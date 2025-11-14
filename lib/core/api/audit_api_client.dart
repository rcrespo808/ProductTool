import '../../domain/models/audit_session.dart';
import '../util/result.dart';

/// Abstract interface for audit API client
abstract class AuditApiClient {
  /// Uploads an audit session to the backend
  Future<Result<void>> uploadSession(AuditSession session);
}

/// Fake implementation that does nothing (for development/testing)
class FakeAuditApiClient implements AuditApiClient {
  @override
  Future<Result<void>> uploadSession(AuditSession session) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));
    
    // In a real implementation, this would:
    // 1. Serialize session to JSON
    // 2. Send HTTP POST request
    // 3. Handle response/errors
    
    // For now, just log and return success
    print('FakeAuditApiClient: Would upload session for barcode ${session.barcode} with ${session.imageCount} images');
    
    return const Success(null);
  }
}

