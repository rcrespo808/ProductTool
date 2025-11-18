import '../../domain/models/audit_session.dart';
import '../../utils/result.dart';

/// Repository for managing completed audit sessions (local persistence only)
abstract class SessionRepository {
  /// Saves a completed session to local storage
  /// Only saves sessions with status `completed`
  Future<Result<void>> saveSession(AuditSession session);

  /// Retrieves all saved sessions (most recent first)
  Future<Result<List<AuditSession>>> getAllSessions();

  /// Retrieves only completed sessions (most recent first)
  Future<Result<List<AuditSession>>> getCompletedSessions();

  /// Deletes a session by barcode and createdAt timestamp
  /// Optional: for future use
  Future<Result<void>> deleteSession(String barcode, DateTime createdAt);
}

