// ══════════════════════════════════════════════════════════════════════════════
//  DEMO MODE — usuario estático sin base de datos
//  Credenciales: demo@logopeda.com / demo1234
//  Elimina este archivo y las referencias en auth_service.dart y
//  logopeda_service.dart cuando tengas la BD real.
// ══════════════════════════════════════════════════════════════════════════════

import '../core/models.dart';

// ── Credenciales demo ─────────────────────────────────────────────────────────
const String demoEmail    = 'demo@logopeda.com';
const String demoPassword = 'demo1234';

// ── Usuario logopeda estático ─────────────────────────────────────────────────
final AppUser demoLogopeda = AppUser(
  id:      'demo-logopeda-001',
  email:   demoEmail,
  name:    'Dra. Carmen López',
  role:    UserRole.logopeda,
  roleSet: true,
);

// ── Pacientes de ejemplo ──────────────────────────────────────────────────────
final List<AppUser> demoPacientes = [
  AppUser(
    id:           'demo-pac-001',
    email:        'juan.garcia@ejemplo.com',
    name:         'Juan García',
    role:         UserRole.patient,
    roleSet:      true,
    voiceType:    VoiceType.esofagico,
    currentLevel: 3,
    streakDays:   5,
    logopedaId:   'demo-logopeda-001',
  ),
  AppUser(
    id:           'demo-pac-002',
    email:        'maria.perez@ejemplo.com',
    name:         'María Pérez',
    role:         UserRole.patient,
    roleSet:      true,
    voiceType:    VoiceType.electrolaringe,
    currentLevel: 2,
    streakDays:   12,
    logopedaId:   'demo-logopeda-001',
  ),
  AppUser(
    id:           'demo-pac-003',
    email:        'antonio.ruiz@ejemplo.com',
    name:         'Antonio Ruiz',
    role:         UserRole.patient,
    roleSet:      true,
    voiceType:    VoiceType.esofagico,
    currentLevel: 1,
    streakDays:   0,
    logopedaId:   'demo-logopeda-001',
  ),
];

// ── Fichas de ejemplo ─────────────────────────────────────────────────────────
final List<Ficha> demoFichas = [
  Ficha(
    id:             'demo-ficha-001',
    name:           'Vocales básicas',
    level:          1,
    assignmentType: 'base_nivel',
    voiceTypeFilter: VoiceType.esofagico,
    words:          ['a', 'e', 'i', 'o', 'u'],
    instructions:   'Pronuncia cada vocal de forma clara y sostenida durante 2 segundos.',
    successThreshold: 0.65,
    createdBy:      'demo-logopeda-001',
  ),
  Ficha(
    id:             'demo-ficha-002',
    name:           'Palabras cortas - nivel 1',
    level:          1,
    assignmentType: 'personalizada',
    words:          ['pan', 'sol', 'mar', 'luz', 'paz'],
    instructions:   'Pronuncia cada palabra lentamente, separando las sílabas.',
    successThreshold: 0.70,
    createdBy:      'demo-logopeda-001',
  ),
  Ficha(
    id:             'demo-ficha-003',
    name:           'Frases cortas',
    level:          2,
    assignmentType: 'personalizada',
    words:          ['hola', 'gracias', 'buenos días', 'hasta luego', 'por favor'],
    instructions:   'Practica las expresiones cotidianas con ritmo natural.',
    successThreshold: 0.75,
    createdBy:      'demo-logopeda-001',
  ),
];

// ── Stats de ejemplo ──────────────────────────────────────────────────────────
final Map<String, dynamic> demoStats = {
  'pacientes':  demoPacientes.length,
  'sesiones':   27,
  'tasa_exito': 0.73,
};

// ── Fichas asignadas por paciente ─────────────────────────────────────────────
final Map<String, List<UserFicha>> demoFichasPorPaciente = {
  'demo-pac-001': [
    UserFicha(
      id:          'demo-uf-001',
      userId:      'demo-pac-001',
      fichaId:     'demo-ficha-001',
      assignedAt:  DateTime.now().subtract(const Duration(days: 10)),
      assignedBy:  'demo-logopeda-001',
      completedAt: DateTime.now().subtract(const Duration(days: 8)),
      bestScore:   0.81,
      ficha:       demoFichas[0],
    ),
    UserFicha(
      id:        'demo-uf-002',
      userId:    'demo-pac-001',
      fichaId:   'demo-ficha-002',
      assignedAt: DateTime.now().subtract(const Duration(days: 5)),
      assignedBy: 'demo-logopeda-001',
      ficha:     demoFichas[1],
    ),
  ],
  'demo-pac-002': [
    UserFicha(
      id:          'demo-uf-003',
      userId:      'demo-pac-002',
      fichaId:     'demo-ficha-002',
      assignedAt:  DateTime.now().subtract(const Duration(days: 14)),
      assignedBy:  'demo-logopeda-001',
      completedAt: DateTime.now().subtract(const Duration(days: 12)),
      bestScore:   0.69,
      ficha:       demoFichas[1],
    ),
    UserFicha(
      id:        'demo-uf-004',
      userId:    'demo-pac-002',
      fichaId:   'demo-ficha-003',
      assignedAt: DateTime.now().subtract(const Duration(days: 3)),
      assignedBy: 'demo-logopeda-001',
      ficha:     demoFichas[2],
    ),
  ],
  'demo-pac-003': [
    UserFicha(
      id:        'demo-uf-005',
      userId:    'demo-pac-003',
      fichaId:   'demo-ficha-001',
      assignedAt: DateTime.now().subtract(const Duration(days: 2)),
      assignedBy: 'demo-logopeda-001',
      ficha:     demoFichas[0],
    ),
  ],
};

// ── Intentos de ejemplo ───────────────────────────────────────────────────────
final Map<String, List<Attempt>> demoIntentosPorPaciente = {
  'demo-pac-001': [
    Attempt(
      id: 'demo-att-001', userId: 'demo-pac-001',
      whisperScore: 0.85, passed: true,
      wordAttempted: 'a',
      attemptedAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
    Attempt(
      id: 'demo-att-002', userId: 'demo-pac-001',
      whisperScore: 0.78, passed: true,
      wordAttempted: 'pan',
      attemptedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ],
  'demo-pac-002': [
    Attempt(
      id: 'demo-att-003', userId: 'demo-pac-002',
      whisperScore: 0.62, passed: false,
      wordAttempted: 'sol',
      attemptedAt: DateTime.now().subtract(const Duration(days: 11)),
    ),
    Attempt(
      id: 'demo-att-004', userId: 'demo-pac-002',
      whisperScore: 0.71, passed: true,
      wordAttempted: 'hola',
      attemptedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ],
  'demo-pac-003': [],
};
