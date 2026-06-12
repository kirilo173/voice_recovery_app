import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../core/api.dart';
import '../core/models.dart';

class FichaService {
  static Future<List<UserFicha>> getMisFichas() async {
    final res = await Api.dio.get('/fichas/mis-fichas');
    return (res.data as List).map((j) => UserFicha.fromJson(j)).toList();
  }
  static Future<Ficha> getFicha(String id) async {
    final res = await Api.dio.get('/fichas/$id');
    return Ficha.fromJson(res.data);
  }
  static Future<Session> startSession() async {
    final res = await Api.dio.post('/sessions/start');
    return Session.fromJson(res.data);
  }
  static Future<Session> endSession(String sessionId) async {
    final res = await Api.dio.post('/sessions/$sessionId/end');
    return Session.fromJson(res.data);
  }
  static Future<Attempt> submitAttempt({
    required String sessionId,
    required String wordAttempted,
    required Uint8List audioBytes,
  }) async {
    final formData = FormData.fromMap({
      'session_id':     sessionId,
      'word_attempted': wordAttempted,
      'audio': MultipartFile.fromBytes(audioBytes,
        filename: 'attempt.wav', contentType: DioMediaType('audio', 'wav')),
    });
    final res = await Api.dio.post('/attempts/', data: formData);
    return Attempt.fromJson(res.data);
  }
  static Future<List<Attempt>> getMisIntentos() async {
    final res = await Api.dio.get('/attempts/');
    return (res.data as List).map((j) => Attempt.fromJson(j)).toList();
  }
  static Future<UserFicha> completarFicha(String userFichaId) async {
    final res = await Api.dio.post('/fichas/completar/$userFichaId');
    return UserFicha.fromJson(res.data);
  }
}
