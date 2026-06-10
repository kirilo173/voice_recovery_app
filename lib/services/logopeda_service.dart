import '../core/api.dart';
import '../core/models.dart';

class LogopedaService {
  // ── Mis pacientes ─────────────────────────────────────────────────────────
  // GET /logopeda/pacientes  →  [ AppUser ]
  static Future<List<AppUser>> getMisPacientes() async {
    final res = await Api.dio.get('/logopeda/pacientes');
    return (res.data as List).map((j) => AppUser.fromJson(j)).toList();
  }

  // ── Fichas creadas por el logopeda ────────────────────────────────────────
  // GET /logopeda/fichas  →  [ Ficha ]
  static Future<List<Ficha>> getMisFichas() async {
    final res = await Api.dio.get('/logopeda/fichas');
    return (res.data as List).map((j) => Ficha.fromJson(j)).toList();
  }

  // ── Crear una nueva ficha ─────────────────────────────────────────────────
  // POST /fichas/  →  Ficha
  static Future<Ficha> crearFicha(Ficha ficha) async {
    final res = await Api.dio.post('/fichas/', data: ficha.toJson());
    return Ficha.fromJson(res.data);
  }

  // ── Asignar ficha a un paciente ───────────────────────────────────────────
  // POST /fichas/asignar  →  UserFicha
  static Future<UserFicha> asignarFicha({
    required String userId,
    required String fichaId,
    double? umbral,
  }) async {
    final res = await Api.dio.post('/fichas/asignar', data: {
      'user_id':           userId,
      'ficha_id':          fichaId,
      if (umbral != null) 'success_threshold': umbral,
    });
    return UserFicha.fromJson(res.data);
  }

  // ── Fichas asignadas a un paciente concreto ───────────────────────────────
  // GET /logopeda/pacientes/{id}/fichas  →  [ UserFicha ]
  static Future<List<UserFicha>> getFichasDePaciente(String pacienteId) async {
    final res = await Api.dio.get('/logopeda/pacientes/$pacienteId/fichas');
    return (res.data as List).map((j) => UserFicha.fromJson(j)).toList();
  }

  // ── Intentos de un paciente ───────────────────────────────────────────────
  // GET /logopeda/pacientes/{id}/intentos  →  [ Attempt ]
  static Future<List<Attempt>> getIntentosDePaciente(String pacienteId) async {
    final res = await Api.dio.get('/logopeda/pacientes/$pacienteId/intentos');
    return (res.data as List).map((j) => Attempt.fromJson(j)).toList();
  }

  // ── Generar código de vinculación ─────────────────────────────────────────
  // POST /logopeda/codigo  →  { codigo }
  static Future<String> generarCodigo() async {
    final res = await Api.dio.post('/logopeda/codigo');
    return res.data['codigo'];
  }

  // ── Estadísticas del logopeda ─────────────────────────────────────────────
  // GET /logopeda/stats  →  { pacientes, sesiones, tasa_exito }
  static Future<Map<String, dynamic>> getStats() async {
    final res = await Api.dio.get('/logopeda/stats');
    return res.data;
  }
}