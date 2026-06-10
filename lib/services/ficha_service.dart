import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../core/api.dart';
import '../core/models.dart';

class FichaService {
  // ── Fichas asignadas al paciente ──────────────────────────────────────────
  // GET /fichas/mis-fichas  →  [ UserFicha ]
  static Future<List<UserFicha>> getMisFichas() async {
    final res = await Api.dio.get('/fichas/mis-fichas');
    return (res.data as List).map((j) => UserFicha.fromJson(j)).toList();
  }

  // ── Detalle de una ficha ──────────────────────────────────────────────────
  // GET /fichas/{id}  →  Ficha
  static Future<Ficha> getFicha(String id) async {
    final res = await Api.dio.get('/fichas/$id');
    return Ficha.fromJson(res.data);
  }

  // ── Iniciar sesión de práctica ────────────────────────────────────────────
  // POST /sessions/start  →  Session
  static Future<Session> startSession() async {
    final res = await Api.dio.post('/sessions/start');
    return Session.fromJson(res.data);
  }

  // ── Finalizar sesión ──────────────────────────────────────────────────────
  // POST /sessions/{id}/end  →  Session
  static Future<Session> endSession(String sessionId) async {
    final res = await Api.dio.post('/sessions/$sessionId/end');
    return Session.fromJson(res.data);
  }

  // ── Enviar intento de pronunciación ──────────────────────────────────────
  // POST /attempts/  →  Attempt
  static Future<Attempt> submitAttempt({
    required String sessionId,
    required String wordAttempted,
    required Uint8List audioBytes,
  }) async {
    final formData = FormData.fromMap({
      'session_id':     sessionId,
      'word_attempted': wordAttempted,
      'audio': MultipartFile.fromBytes(
        audioBytes,
        filename:    'attempt.wav',
        contentType: DioMediaType('audio', 'wav'),
      ),
    });
    final res = await Api.dio.post('/attempts/', data: formData);
    return Attempt.fromJson(res.data);
  }

  // ── Historial de intentos del usuario ────────────────────────────────────
  // GET /attempts/  →  [ Attempt ]
  static Future<List<Attempt>> getMisIntentos() async {
    final res = await Api.dio.get('/attempts/');
    return (res.data as List).map((j) => Attempt.fromJson(j)).toList();
  }

  // ── Marcar ficha como completada ─────────────────────────────────────────
  // POST /fichas/completar/{user_ficha_id}  →  UserFicha
  static Future<UserFicha> completarFicha(String userFichaId) async {
    final res = await Api.dio.post('/fichas/completar/$userFichaId');
    return UserFicha.fromJson(res.data);
  }
}