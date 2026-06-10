import '../core/api.dart';
import '../core/models.dart';
import 'auth_service.dart';
import 'demo_service.dart';

class LogopedaService {
  // ── Mis pacientes ─────────────────────────────────────────────────────────
  static Future<List<AppUser>> getMisPacientes() async {
    if (isDemoSession) return demoPacientes; // DEMO
    final res = await Api.dio.get('/logopeda/pacientes');
    return (res.data as List).map((j) => AppUser.fromJson(j)).toList();
  }

  // ── Fichas creadas por el logopeda ────────────────────────────────────────
  static Future<List<Ficha>> getMisFichas() async {
    if (isDemoSession) return demoFichas; // DEMO
    final res = await Api.dio.get('/logopeda/fichas');
    return (res.data as List).map((j) => Ficha.fromJson(j)).toList();
  }

  // ── Crear una nueva ficha ─────────────────────────────────────────────────
  static Future<Ficha> crearFicha(Ficha ficha) async {
    if (isDemoSession) { // DEMO: simula creación
      final nueva = Ficha(
        id:              'demo-ficha-new-${DateTime.now().millisecondsSinceEpoch}',
        name:            ficha.name,
        level:           ficha.level,
        assignmentType:  ficha.assignmentType,
        voiceTypeFilter: ficha.voiceTypeFilter,
        words:           ficha.words,
        instructions:    ficha.instructions,
        successThreshold: ficha.successThreshold,
        guideVideoId:    ficha.guideVideoId,
        createdBy:       'demo-logopeda-001',
      );
      demoFichas.add(nueva);
      return nueva;
    }
    final res = await Api.dio.post('/fichas/', data: ficha.toJson());
    return Ficha.fromJson(res.data);
  }

  // ── Asignar ficha a un paciente ───────────────────────────────────────────
  static Future<UserFicha> asignarFicha({
    required String userId,
    required String fichaId,
    double? umbral,
  }) async {
    if (isDemoSession) { // DEMO: simula asignación
      final ficha = demoFichas.firstWhere((f) => f.id == fichaId,
          orElse: () => demoFichas.first);
      final uf = UserFicha(
        id:         'demo-uf-new-${DateTime.now().millisecondsSinceEpoch}',
        userId:     userId,
        fichaId:    fichaId,
        assignedAt: DateTime.now(),
        assignedBy: 'demo-logopeda-001',
        ficha:      ficha,
      );
      (demoFichasPorPaciente[userId] ??= []).add(uf);
      return uf;
    }
    final res = await Api.dio.post('/fichas/asignar', data: {
      'user_id':           userId,
      'ficha_id':          fichaId,
      if (umbral != null) 'success_threshold': umbral,
    });
    return UserFicha.fromJson(res.data);
  }

  // ── Fichas asignadas a un paciente concreto ───────────────────────────────
  static Future<List<UserFicha>> getFichasDePaciente(String pacienteId) async {
    if (isDemoSession) { // DEMO
      return demoFichasPorPaciente[pacienteId] ?? [];
    }
    final res = await Api.dio.get('/logopeda/pacientes/$pacienteId/fichas');
    return (res.data as List).map((j) => UserFicha.fromJson(j)).toList();
  }

  // ── Intentos de un paciente ───────────────────────────────────────────────
  static Future<List<Attempt>> getIntentosDePaciente(String pacienteId) async {
    if (isDemoSession) { // DEMO
      return demoIntentosPorPaciente[pacienteId] ?? [];
    }
    final res = await Api.dio.get('/logopeda/pacientes/$pacienteId/intentos');
    return (res.data as List).map((j) => Attempt.fromJson(j)).toList();
  }

  // ── Generar código de vinculación ─────────────────────────────────────────
  static Future<String> generarCodigo() async {
    if (isDemoSession) return 'RTV-DEMO'; // DEMO
    final res = await Api.dio.post('/logopeda/codigo');
    return res.data['codigo'];
  }

  // ── Estadísticas del logopeda ─────────────────────────────────────────────
  static Future<Map<String, dynamic>> getStats() async {
    if (isDemoSession) return demoStats; // DEMO
    final res = await Api.dio.get('/logopeda/stats');
    return res.data;
  }
}
