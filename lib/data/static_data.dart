// ─────────────────────────────────────────────────────────────────────────────
// static_data.dart
//
// All fake / seed data lives here.
// To connect to the real API, delete this file and replace the repositories
// (patient_repository.dart / logopeda_repository.dart) with HTTP calls.
// Nothing else in the app needs to change.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'models.dart';
import '../theme/app_theme.dart';

// ── USERS ─────────────────────────────────────────────────────────────────────

const kPatient = UserModel(
  id: 'usr_001',
  email: 'adrian.molina@email.com',
  name: 'Adrián Molina',
  role: UserRole.patient,
  voiceType: VoiceType.esofagico,
  currentLevel: 1,
  streakDays: 3,
  isActive: true,
  logopedaId: 'usr_logopeda_001',
);

const kLogopeda = UserModel(
  id: 'usr_logopeda_001',
  email: 'garcia@clinica.com',
  name: 'Dra. García',
  role: UserRole.logopeda,
  streakDays: 0,
  isActive: true,
);

// Patients list for logopeda panel
const kPatients = <UserModel>[
  UserModel(
    id: 'usr_001',
    email: 'adrian.molina@email.com',
    name: 'Adrián Molina',
    role: UserRole.patient,
    voiceType: VoiceType.esofagico,
    currentLevel: 1,
    streakDays: 3,
    isActive: true,
    logopedaId: 'usr_logopeda_001',
  ),
  UserModel(
    id: 'usr_002',
    email: 'carmen.ruiz@email.com',
    name: 'Carmen Ruiz',
    role: UserRole.patient,
    voiceType: VoiceType.electrolaringe,
    currentLevel: 1,
    streakDays: 0,
    isActive: true,
    logopedaId: 'usr_logopeda_001',
  ),
];

// ── VIDEOS ────────────────────────────────────────────────────────────────────

const kVideos = <VideoModel>[
  VideoModel(
    id: 'vid_001',
    title: 'Apertura mandibular — guía',
    contentType: VideoContentType.demoEjercicio,
    level: 1,
    storagePath: 'videos/praxias/apertura_mandibular.mp4',
    durationS: 45,
    uploadedBy: 'usr_logopeda_001',
  ),
  VideoModel(
    id: 'vid_002',
    title: 'Vocales aisladas — guía esofágica',
    contentType: VideoContentType.demoEjercicio,
    level: 1,
    storagePath: 'videos/vocales/vocales_aisladas.mp4',
    durationS: 60,
    uploadedBy: 'usr_logopeda_001',
  ),
  VideoModel(
    id: 'vid_003',
    title: 'Soplo bucal suave',
    contentType: VideoContentType.demoEjercicio,
    level: 1,
    storagePath: 'videos/soplos/soplo_suave.mp4',
    durationS: 38,
    uploadedBy: 'usr_logopeda_001',
  ),
];

// ── FICHAS ────────────────────────────────────────────────────────────────────

const kFichas = <FichaModel>[
  // PRAXIAS
  FichaModel(id: 'fic_001', name: 'Apertura mandibular', level: 1, voiceTypeFilter: VoiceType.esofagico, words: [], instructions: 'Abre la boca lentamente hasta el máximo sin forzar. Mantén 3 segundos y cierra.', successThreshold: 0.70, guideVideoId: 'vid_001'),
  FichaModel(id: 'fic_002', name: 'Movimientos de lengua', level: 1, voiceTypeFilter: VoiceType.esofagico, words: [], instructions: 'Saca la lengua y llévala arriba, abajo, izquierda y derecha. 5 repeticiones cada lado.', successThreshold: 0.70),
  FichaModel(id: 'fic_003', name: 'Labios — protrusión y sonrisa', level: 1, voiceTypeFilter: VoiceType.esofagico, words: [], instructions: 'Frunce los labios hacia adelante y luego estíralos en sonrisa. Alterna 10 veces.', successThreshold: 0.65),
  FichaModel(id: 'fic_004', name: 'Mejillas — inflado', level: 1, voiceTypeFilter: VoiceType.esofagico, words: [], instructions: '', successThreshold: 0.65),
  FichaModel(id: 'fic_005', name: 'Velo del paladar', level: 1, voiceTypeFilter: VoiceType.esofagico, words: [], instructions: '', successThreshold: 0.65),

  // SOPLOS
  FichaModel(id: 'fic_006', name: 'Soplo bucal suave', level: 1, voiceTypeFilter: VoiceType.esofagico, words: [], instructions: 'Inspira por la nariz y expulsa el aire lentamente por la boca en un flujo continuo y suave.', successThreshold: 0.70, guideVideoId: 'vid_003'),
  FichaModel(id: 'fic_007', name: 'Soplo bucal fuerte', level: 1, voiceTypeFilter: VoiceType.esofagico, words: [], instructions: 'Inspira profundo y expulsa el aire por la boca con más fuerza.', successThreshold: 0.70),
  FichaModel(id: 'fic_008', name: 'Soplo dirigido', level: 1, voiceTypeFilter: VoiceType.esofagico, words: [], instructions: 'Dirige el soplo hacia un punto concreto. Mantén la dirección constante.', successThreshold: 0.65),
  FichaModel(id: 'fic_009', name: 'Soplo fragmentado', level: 1, words: [], instructions: '', successThreshold: 0.65),
  FichaModel(id: 'fic_010', name: 'Independencia completa', level: 1, words: [], instructions: '', successThreshold: 0.65),

  // VOCALES
  FichaModel(id: 'fic_011', name: 'Vocales aisladas', level: 1, voiceTypeFilter: VoiceType.esofagico, words: ['A','E','I','O','U'], instructions: 'Introduce el aire en el esófago y emite cada vocal de forma breve y clara.', successThreshold: 0.65, guideVideoId: 'vid_002'),
  FichaModel(id: 'fic_012', name: 'Diptongos con A', level: 1, words: ['ae','ai','ao','au'], instructions: '', successThreshold: 0.65),
  FichaModel(id: 'fic_013', name: 'Diptongos con E', level: 1, words: ['ea','ei','eo','eu'], instructions: '', successThreshold: 0.65),
  FichaModel(id: 'fic_014', name: 'Diptongos con I', level: 1, words: ['ia','ie','io','iu'], instructions: '', successThreshold: 0.65),
  FichaModel(id: 'fic_015', name: 'Diptongos con O y U', level: 1, words: ['oa','oe','ua','ue'], instructions: '', successThreshold: 0.65),

  // SÍLABAS
  FichaModel(id: 'fic_016', name: 'Oclusivas /p/ /t/ /k/', level: 1, words: ['PA','PE','PI','PO','PU','TA','TE','TI','CA','CO'], instructions: 'Pronuncia cada sílaba con un golpe de aire suave desde el esófago.', successThreshold: 0.65),
  FichaModel(id: 'fic_017', name: 'Oclusivas /b/ /d/ /g/', level: 1, words: ['BA','BE','DA','DE','GA','GUE'], instructions: '', successThreshold: 0.65),
  FichaModel(id: 'fic_018', name: 'Nasales /m/ /n/', level: 1, words: ['MA','ME','NA','NE'], instructions: '', successThreshold: 0.65),
  FichaModel(id: 'fic_019', name: 'Monosílabos — palabras', level: 1, words: ['Pan','Pez','Sol','Luz','Mar'], instructions: '', successThreshold: 0.65),
  FichaModel(id: 'fic_020', name: 'Sílabas trabadas', level: 1, words: ['PRA','PRE','BRA','BRE','TRA','TRE'], instructions: '', successThreshold: 0.65),
];

// ── USER_FICHAS (assignments) ─────────────────────────────────────────────────

final kUserFichas = <UserFichaModel>[
  UserFichaModel(id: 'uf_001', userId: 'usr_001', fichaId: 'fic_001', assignedAt: DateTime(2024, 3, 1), assignedBy: 'usr_logopeda_001', completedAt: DateTime(2024, 3, 2), bestScore: 0.82),
  UserFichaModel(id: 'uf_002', userId: 'usr_001', fichaId: 'fic_002', assignedAt: DateTime(2024, 3, 1), assignedBy: 'usr_logopeda_001', completedAt: DateTime(2024, 3, 3), bestScore: 0.78),
  UserFichaModel(id: 'uf_003', userId: 'usr_001', fichaId: 'fic_003', assignedAt: DateTime(2024, 3, 4), assignedBy: 'usr_logopeda_001'),
  UserFichaModel(id: 'uf_004', userId: 'usr_001', fichaId: 'fic_006', assignedAt: DateTime(2024, 3, 1), assignedBy: 'usr_logopeda_001', completedAt: DateTime(2024, 3, 2), bestScore: 0.90),
  UserFichaModel(id: 'uf_005', userId: 'usr_001', fichaId: 'fic_007', assignedAt: DateTime(2024, 3, 1), assignedBy: 'usr_logopeda_001', completedAt: DateTime(2024, 3, 3), bestScore: 0.75),
  UserFichaModel(id: 'uf_006', userId: 'usr_001', fichaId: 'fic_008', assignedAt: DateTime(2024, 3, 5), assignedBy: 'usr_logopeda_001'),
  UserFichaModel(id: 'uf_007', userId: 'usr_001', fichaId: 'fic_011', assignedAt: DateTime(2024, 3, 6), assignedBy: 'usr_logopeda_001'),
  UserFichaModel(id: 'uf_008', userId: 'usr_001', fichaId: 'fic_016', assignedAt: DateTime(2024, 3, 6), assignedBy: 'usr_logopeda_001'),
];

// ── SESSIONS ──────────────────────────────────────────────────────────────────

final kSessions = <SessionModel>[
  SessionModel(id: 'ses_001', userId: 'usr_001', startedAt: DateTime(2024, 3, 1, 10, 0), endedAt: DateTime(2024, 3, 1, 10, 25), exercisesDone: 3, successRate: 0.82),
  SessionModel(id: 'ses_002', userId: 'usr_001', startedAt: DateTime(2024, 3, 2, 11, 0), endedAt: DateTime(2024, 3, 2, 11, 30), exercisesDone: 4, successRate: 0.75),
  SessionModel(id: 'ses_003', userId: 'usr_001', startedAt: DateTime(2024, 3, 3, 10, 0), endedAt: DateTime(2024, 3, 3, 10, 20), exercisesDone: 2, successRate: 0.90),
];

// ── PATIENT STATS (derived — in production compute from sessions/attempts) ────

class PatientStats {
  final int totalSessions;
  final int streakDays;
  final double successRate;   // 0.0–1.0
  final int exercisesDone;
  final List<double> weeklyActivity; // 7 values Mon–Sun, 0.0–1.0

  const PatientStats({
    required this.totalSessions,
    required this.streakDays,
    required this.successRate,
    required this.exercisesDone,
    required this.weeklyActivity,
  });
}

const kPatientStats = PatientStats(
  totalSessions: 12,
  streakDays: 3,
  successRate: 0.78,
  exercisesDone: 8,
  weeklyActivity: [0.6, 0.5, 0.3, 0.8, 0.65, 0.0, 0.0],
);

// ── MODULOS UI (grouped for display) ─────────────────────────────────────────
// In production: build from fichas + user_fichas returned by the API.

List<ModuloUI> buildModulosForPatient(String userId) {
  // Helper to resolve ficha status from user_fichas
  FichaStatus statusFor(String fichaId, bool previousDone) {
    final assignment = kUserFichas.where((uf) => uf.userId == userId && uf.fichaId == fichaId).firstOrNull;
    if (assignment == null) return FichaStatus.locked;
    if (assignment.isCompleted) return FichaStatus.done;
    return previousDone ? FichaStatus.active : FichaStatus.locked;
  }

  FichaUI buildFichaUI(FichaModel f, bool previousDone) {
    final assignment = kUserFichas.where((uf) => uf.userId == userId && uf.fichaId == f.id).firstOrNull;
    final video = f.guideVideoId != null ? kVideos.where((v) => v.id == f.guideVideoId).firstOrNull : null;
    final st = assignment == null
        ? FichaStatus.locked
        : assignment.isCompleted
        ? FichaStatus.done
        : FichaStatus.active;
    return FichaUI(ficha: f, status: st, assignment: assignment, guideVideo: video);
  }

  List<FichaUI> buildFichas(List<FichaModel> fichas) {
    final result = <FichaUI>[];
    bool prevDone = true;
    for (final f in fichas) {
      final ui = buildFichaUI(f, prevDone);
      result.add(ui);
      prevDone = ui.status == FichaStatus.done;
    }
    return result;
  }

  final praxiasFichas = buildFichas(kFichas.where((f) => ['fic_001','fic_002','fic_003','fic_004','fic_005'].contains(f.id)).toList());
  final soplos = buildFichas(kFichas.where((f) => ['fic_006','fic_007','fic_008','fic_009','fic_010'].contains(f.id)).toList());
  final vocales = buildFichas(kFichas.where((f) => ['fic_011','fic_012','fic_013','fic_014','fic_015'].contains(f.id)).toList());
  final silabas = buildFichas(kFichas.where((f) => ['fic_016','fic_017','fic_018','fic_019','fic_020'].contains(f.id)).toList());

  return [
    ModuloUI(id: 'mod_001', title: 'Praxias orofaciales', subtitle: 'Labios, lengua y mandíbula', iconName: 'mouth', bgColor: AppColors.blue50, iconColor: AppColors.blue600, totalFichas: 15, doneFichas: 6, fichas: praxiasFichas),
    ModuloUI(id: 'mod_002', title: 'Independencia de soplos', subtitle: 'Control y dirección del soplo', iconName: 'wind', bgColor: AppColors.teal50, iconColor: AppColors.teal600, totalFichas: 8, doneFichas: 2, fichas: soplos),
    ModuloUI(id: 'mod_003', title: 'Vocales y diptongos', subtitle: 'A E I O U y combinaciones', iconName: 'letter-a', bgColor: AppColors.purple50, iconColor: AppColors.purple600, totalFichas: 25, doneFichas: 0, fichas: vocales),
    ModuloUI(id: 'mod_004', title: 'Sílabas y monosílabos', subtitle: 'PA PE PI · PAN PEZ SOL…', iconName: 'alphabet-latin', bgColor: AppColors.coral50, iconColor: AppColors.coral600, totalFichas: 40, doneFichas: 0, fichas: silabas),
    ModuloUI(id: 'mod_005', title: 'Palabras bisílabas', subtitle: 'Mesa · Silla · Pera…', iconName: 'book', bgColor: AppColors.gray50, iconColor: AppColors.gray400, totalFichas: 30, doneFichas: 0, fichas: [], locked: true),
  ];
}

// ── LOGOPEDA MODULES (all modules she manages) ────────────────────────────────

class LogopedaModuloData {
  final String id;
  final String title;
  final int fichaCount;
  final int patientCount;
  final Color bgColor;
  final Color iconColor;
  final String iconName;

  const LogopedaModuloData({
    required this.id,
    required this.title,
    required this.fichaCount,
    required this.patientCount,
    required this.bgColor,
    required this.iconColor,
    required this.iconName,
  });
}

const kLogopedaModulos = <LogopedaModuloData>[
  LogopedaModuloData(id: 'mod_001', title: 'Praxias orofaciales', fichaCount: 15, patientCount: 2, bgColor: AppColors.blue50, iconColor: AppColors.blue600, iconName: 'mouth'),
  LogopedaModuloData(id: 'mod_002', title: 'Independencia de soplos', fichaCount: 8, patientCount: 3, bgColor: AppColors.teal50, iconColor: AppColors.teal600, iconName: 'wind'),
  LogopedaModuloData(id: 'mod_003', title: 'Vocales y diptongos', fichaCount: 25, patientCount: 1, bgColor: AppColors.purple50, iconColor: AppColors.purple600, iconName: 'letter-a'),
];

// ── PATIENT PROGRESS (for logopeda panel) ─────────────────────────────────────

class PatientProgress {
  final UserModel patient;
  final double overallProgress;  // 0.0–1.0
  final double successRate;
  final int sessionCount;
  final String status;  // 'activo' | 'pendiente' | 'inactivo'

  const PatientProgress({
    required this.patient,
    required this.overallProgress,
    required this.successRate,
    required this.sessionCount,
    required this.status,
  });
}

const kPatientProgress = <PatientProgress>[
  PatientProgress(patient: UserModel(id: 'usr_001', email: 'adrian.molina@email.com', name: 'Adrián Molina', role: UserRole.patient, voiceType: VoiceType.esofagico, currentLevel: 1, streakDays: 3, isActive: true, logopedaId: 'usr_logopeda_001'), overallProgress: 0.35, successRate: 0.78, sessionCount: 12, status: 'activo'),
  PatientProgress(patient: UserModel(id: 'usr_002', email: 'carmen.ruiz@email.com', name: 'Carmen Ruiz', role: UserRole.patient, voiceType: VoiceType.electrolaringe, currentLevel: 1, streakDays: 0, isActive: true, logopedaId: 'usr_logopeda_001'), overallProgress: 0.12, successRate: 0.55, sessionCount: 4, status: 'pendiente'),
];