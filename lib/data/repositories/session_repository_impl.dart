import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/audit_session.dart';
import '../../domain/models/audit_session_status.dart';
import '../../utils/result.dart';
import 'session_repository.dart';

/// Implementation of SessionRepository using SharedPreferences
class SessionRepositoryImpl implements SessionRepository {
  static const String _storageKey = 'audit_sessions';

  @override
  Future<Result<void>> saveSession(AuditSession session) async {
    // Only save completed sessions
    if (session.status != AuditSessionStatus.completed) {
      return const Success(null);
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load existing sessions
      final existingSessionsResult = await getAllSessions();
      if (existingSessionsResult.isFailure) {
        // If we can't load existing, start fresh
        final sessionsJson = jsonEncode([session.toJson()]);
        await prefs.setString(_storageKey, sessionsJson);
        return const Success(null);
      }

      final existingSessions = existingSessionsResult.valueOrNull ?? [];
      
      // Check if this session already exists (same barcode + createdAt)
      final exists = existingSessions.any(
        (s) => s.barcode == session.barcode && 
               s.createdAt.isAtSameMomentAs(session.createdAt),
      );

      if (exists) {
        // Update existing session by replacing it
        final updatedSessions = existingSessions.map((s) {
          if (s.barcode == session.barcode && 
              s.createdAt.isAtSameMomentAs(session.createdAt)) {
            return session;
          }
          return s;
        }).toList();
        
        final sessionsJson = jsonEncode(
          updatedSessions.map((s) => s.toJson()).toList(),
        );
        await prefs.setString(_storageKey, sessionsJson);
        return const Success(null);
      }

      // Add new session
      final allSessions = [session, ...existingSessions];
      
      // Sort by createdAt descending (most recent first)
      allSessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      final sessionsJson = jsonEncode(
        allSessions.map((s) => s.toJson()).toList(),
      );
      
      await prefs.setString(_storageKey, sessionsJson);
      return const Success(null);
    } catch (e) {
      return Failure(
        'Failed to save session: ${e.toString()}',
        e,
      );
    }
  }

  @override
  Future<Result<List<AuditSession>>> getAllSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return const Success([]);
      }

      final jsonList = jsonDecode(jsonString) as List;
      final sessions = jsonList
          .map((json) => AuditSession.fromJson(json as Map<String, dynamic>))
          .toList();

      // Ensure sorted by createdAt descending (most recent first)
      sessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Success(sessions);
    } catch (e) {
      return Failure(
        'Failed to load sessions: ${e.toString()}',
        e,
      );
    }
  }

  @override
  Future<Result<List<AuditSession>>> getCompletedSessions() async {
    final allSessionsResult = await getAllSessions();
    if (allSessionsResult.isFailure) {
      return Failure(
        allSessionsResult.errorMessage ?? 'Failed to load sessions',
      );
    }

    final allSessions = allSessionsResult.valueOrNull ?? [];
    final completedSessions = allSessions
        .where((s) => s.status == AuditSessionStatus.completed)
        .toList();

    return Success(completedSessions);
  }

  @override
  Future<Result<void>> deleteSession(String barcode, DateTime createdAt) async {
    try {
      final allSessionsResult = await getAllSessions();
      if (allSessionsResult.isFailure) {
        return Failure(
          allSessionsResult.errorMessage ?? 'Failed to load sessions',
        );
      }

      final allSessions = allSessionsResult.valueOrNull ?? [];
      final filteredSessions = allSessions.where(
        (s) => !(s.barcode == barcode && 
                 s.createdAt.isAtSameMomentAs(createdAt)),
      ).toList();

      final prefs = await SharedPreferences.getInstance();
      final sessionsJson = jsonEncode(
        filteredSessions.map((s) => s.toJson()).toList(),
      );
      await prefs.setString(_storageKey, sessionsJson);

      return const Success(null);
    } catch (e) {
      return Failure(
        'Failed to delete session: ${e.toString()}',
        e,
      );
    }
  }
}

