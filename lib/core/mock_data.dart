import '../core/models.dart';

// ══════════════════════════════════════════════════════════════════════════════
//  DATOS MOCK — se usan mientras no hay backend conectado
//  Cuando conectes la API, elimina este archivo y usa los servicios reales
// ══════════════════════════════════════════════════════════════════════════════

class MockData {
  // ── Usuario logopeda ──────────────────────────────────────────────────────
  static final AppUser logopeda = AppUser(
    id: 'l1', email: 'logopeda@test.com', name: 'Dra. García',
    role: UserRole.logopeda, roleSet: true,
  );

  // ── Usuario paciente ──────────────────────────────────────────────────────
  static final AppUser paciente = AppUser(
    id: 'p1', email: 'paciente@test.com', name: 'Adrián Molina',
    role: UserRole.patient, roleSet: true,
    voiceType: VoiceType.esofagico, currentLevel: 1, streakDays: 3,
  );

  // ── Fichas ────────────────────────────────────────────────────────────────
  static final List<Ficha> fichas = [
    const Ficha(
      id: 'f1', name: 'Vocales aisladas', level: 1,
      assignmentType: 'base_nivel',
      words: ['A', 'E', 'I', 'O', 'U'],
      instructions: 'Introduce el aire en el esófago y emite cada vocal de forma breve y clara.',
      successThreshold: 0.65,
    ),
    const Ficha(
      id: 'f2', name: 'Oclusivas /p/ /t/', level: 1,
      assignmentType: 'base_nivel',
      words: ['PA', 'PE', 'PI', 'TA', 'TE', 'TI'],
      instructions: 'Pronuncia cada sílaba con un golpe de aire suave desde el esófago.',
      successThreshold: 0.65,
    ),
    const Ficha(
      id: 'f3', name: 'Monosílabos', level: 1,
      assignmentType: 'personalizada',
      words: ['pan', 'sol', 'mar', 'luz', 'pez'],
      instructions: 'Di cada palabra con calma, suelta el aire antes de pronunciar.',
      successThreshold: 0.70,
    ),
  ];

  // ── Fichas asignadas al paciente ──────────────────────────────────────────
  static final List<UserFicha> userFichas = [
    UserFicha(
      id: 'uf1', userId: 'p1', fichaId: 'f1',
      assignedAt: DateTime.now().subtract(const Duration(days: 5)),
      ficha: fichas[0],
    ),
    UserFicha(
      id: 'uf2', userId: 'p1', fichaId: 'f2',
      assignedAt: DateTime.now().subtract(const Duration(days: 3)),
      completedAt: DateTime.now().subtract(const Duration(days: 1)),
      bestScore: 0.84,
      ficha: fichas[1],
    ),
    UserFicha(
      id: 'uf3', userId: 'p1', fichaId: 'f3',
      assignedAt: DateTime.now().subtract(const Duration(days: 1)),
      ficha: fichas[2],
    ),
  ];

  // ── Intentos del paciente ─────────────────────────────────────────────────
  static final List<Attempt> intentos = [
    Attempt(id: 'a1', userId: 'p1', whisperScore: 0.91, passed: true,
      wordAttempted: 'PA', attemptedAt: DateTime.now().subtract(const Duration(hours: 2))),
    Attempt(id: 'a2', userId: 'p1', whisperScore: 0.84, passed: true,
      wordAttempted: 'PE', attemptedAt: DateTime.now().subtract(const Duration(hours: 2))),
    Attempt(id: 'a3', userId: 'p1', whisperScore: 0.62, passed: false,
      wordAttempted: 'PI', attemptedAt: DateTime.now().subtract(const Duration(days: 1))),
    Attempt(id: 'a4', userId: 'p1', whisperScore: 0.78, passed: true,
      wordAttempted: 'pan', attemptedAt: DateTime.now().subtract(const Duration(days: 2))),
    Attempt(id: 'a5', userId: 'p1', whisperScore: 0.55, passed: false,
      wordAttempted: 'sol', attemptedAt: DateTime.now().subtract(const Duration(days: 2))),
  ];

  // ── Pacientes del logopeda ────────────────────────────────────────────────
  static final List<AppUser> pacientes = [
    paciente,
    AppUser(
      id: 'p2', email: 'carmen@test.com', name: 'Carmen Ruiz',
      role: UserRole.patient, roleSet: true,
      voiceType: VoiceType.electrolaringe, currentLevel: 1, streakDays: 0,
    ),
  ];

  // ── Stats logopeda ────────────────────────────────────────────────────────
  static final Map<String, dynamic> stats = {
    'pacientes':  2,
    'sesiones':   12,
    'tasa_exito': 0.73,
  };
}
