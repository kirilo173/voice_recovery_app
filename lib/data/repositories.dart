// ─────────────────────────────────────────────────────────────────────────────
// repositories.dart
//
// All data access goes through these repositories.
// Right now they return static data.
// To connect to the API: replace the method bodies with http/dio calls.
// The rest of the app (screens/widgets) never needs to change.
// ─────────────────────────────────────────────────────────────────────────────

import 'models.dart';
import 'static_data.dart';

// ── Patient repository ────────────────────────────────────────────────────────
class PatientRepository {
  // TODO: inject ApiClient here when ready
  // final ApiClient _api;

  /// Returns the current logged-in patient profile.
  /// API: GET /users/me
  Future<UserModel> getMyProfile() async {
    await Future.delayed(const Duration(milliseconds: 100)); // simulate network
    return kPatient;
  }

  /// Returns patient stats (sessions, streak, success rate…).
  /// API: GET /users/{id}/stats
  Future<PatientStats> getMyStats() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return kPatientStats;
  }

  /// Returns all módulos with their fichas and statuses for this patient.
  /// API: GET /users/{id}/modulos  →  combines fichas + user_fichas
  Future<List<ModuloUI>> getMyModulos(String userId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return buildModulosForPatient(userId);
  }

  /// Returns assigned sessions for this patient.
  /// API: GET /sessions?user_id={id}
  Future<List<SessionModel>> getMySessions(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return kSessions.where((s) => s.userId == userId).toList();
  }

  /// Submit a new exercise attempt (audio recorded by patient).
  /// API: POST /exercise_attempts  (multipart: audio + exercise_id + session_id)
  Future<ExerciseAttemptModel> submitAttempt({
    required String exerciseId,
    required String audioPath,
    String? sessionId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Static: simulate a Whisper score
    final score = 0.65 + (DateTime.now().millisecond % 30) / 100.0;
    return ExerciseAttemptModel(
      id: 'att_${DateTime.now().millisecondsSinceEpoch}',
      userId: kPatient.id,
      exerciseId: exerciseId,
      sessionId: sessionId,
      audioPath: audioPath,
      whisperScore: score,
      passed: score >= 0.65,
      attemptedAt: DateTime.now(),
    );
  }
}

// ── Logopeda repository ───────────────────────────────────────────────────────
class LogopedaRepository {
  /// Returns the logopeda's profile.
  /// API: GET /users/me
  Future<UserModel> getMyProfile() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return kLogopeda;
  }

  /// Returns all patients assigned to this logopeda.
  /// API: GET /users?logopeda_id={id}&role=patient
  Future<List<PatientProgress>> getMyPatients() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return kPatientProgress;
  }

  /// Returns all módulos (fichas groups) created by this logopeda.
  /// API: GET /fichas?created_by={id}  →  group by level/module
  Future<List<LogopedaModuloData>> getMyModulos() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return kLogopedaModulos;
  }

  /// Returns all fichas for a given módulo.
  /// API: GET /fichas?module_id={id}
  Future<List<FichaModel>> getFichasForModulo(String moduloId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Static: return fichas matching the module
    final ids = {
      'mod_001': ['fic_001','fic_002','fic_003','fic_004','fic_005'],
      'mod_002': ['fic_006','fic_007','fic_008','fic_009','fic_010'],
      'mod_003': ['fic_011','fic_012','fic_013','fic_014','fic_015'],
    };
    final fichaIds = ids[moduloId] ?? [];
    return kFichas.where((f) => fichaIds.contains(f.id)).toList();
  }

  /// Assign fichas to a patient.
  /// API: POST /user_fichas  { user_id, ficha_id, assigned_by }
  Future<void> assignFichaToPatient({
    required String patientId,
    required String fichaId,
    double? customThreshold,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Static: no-op. In production: POST to API.
  }

  /// Create or update a ficha.
  /// API: POST /fichas or PATCH /fichas/{id}
  Future<FichaModel> saveFicha(FichaModel ficha) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ficha; // Static: return as-is
  }

  /// Returns all sessions for a patient (for logopeda review).
  /// API: GET /sessions?user_id={id}
  Future<List<SessionModel>> getSessionsForPatient(String patientId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return kSessions.where((s) => s.userId == patientId).toList();
  }

  /// Add a note to a session.
  /// API: PATCH /sessions/{id}  { logopeda_note }
  Future<void> addNoteToSession(String sessionId, String note) async {
    await Future.delayed(const Duration(milliseconds: 150));
    // Static: no-op.
  }
}