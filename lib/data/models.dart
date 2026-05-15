// ─────────────────────────────────────────────────────────────────────────────
// models.dart
//
// All models mirror the PostgreSQL schema exactly.
// Fields are nullable where the DB allows NULL.
// When you connect to the real API, these classes stay the same —
// just swap the static lists in static_data.dart for API calls.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:ui';

enum UserRole { patient, logopeda }

enum VoiceType { esofagico, electrolaringe }

enum AssignmentType { baseNivel, personalizada }

enum VideoContentType { general, demoEjercicio, claseNivel, pacienteModelo }

enum VideoVisibility { todos, soloNivel, esofagico, electrolaringe }

// ── users ────────────────────────────────────────────────────────────────────
class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? picture;
  final UserRole role;
  final VoiceType? voiceType;
  final int? currentLevel;
  final int streakDays;
  final bool isActive;
  final String? logopedaId;   // FK → users(id)

  const UserModel({
    required this.id,
    required this.email,
    this.name,
    this.picture,
    required this.role,
    this.voiceType,
    this.currentLevel,
    this.streakDays = 0,
    this.isActive = true,
    this.logopedaId,
  });

  String get initials {
    if (name == null || name!.isEmpty) return '?';
    final parts = name!.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  String get voiceTypeLabel {
    switch (voiceType) {
      case VoiceType.esofagico:    return 'Voz esofágica';
      case VoiceType.electrolaringe: return 'Electrolaringe';
      default: return '';
    }
  }
}

// ── videos ───────────────────────────────────────────────────────────────────
class VideoModel {
  final String id;
  final String title;
  final VideoContentType contentType;
  final int? level;
  final VideoVisibility? visibility;
  final String storagePath;
  final int? durationS;
  final String? description;
  final String? uploadedBy;   // FK → users(id)

  const VideoModel({
    required this.id,
    required this.title,
    required this.contentType,
    this.level,
    this.visibility,
    required this.storagePath,
    this.durationS,
    this.description,
    this.uploadedBy,
  });
}

// ── fichas ───────────────────────────────────────────────────────────────────
// "words" in the DB is a JSON array — here typed as List<String>
class FichaModel {
  final String id;
  final String name;
  final int level;
  final AssignmentType? assignmentType;
  final VoiceType? voiceTypeFilter;
  final List<String> words;       // DB: json
  final String? instructions;
  final double successThreshold;  // 0.0–1.0
  final String? guideVideoId;     // FK → videos(id)
  final String? createdBy;        // FK → users(id)

  const FichaModel({
    required this.id,
    required this.name,
    required this.level,
    this.assignmentType,
    this.voiceTypeFilter,
    this.words = const [],
    this.instructions,
    this.successThreshold = 0.65,
    this.guideVideoId,
    this.createdBy,
  });
}

// ── user_fichas (assignment) ──────────────────────────────────────────────────
class UserFichaModel {
  final String id;
  final String userId;            // FK → users(id)
  final String fichaId;           // FK → fichas(id)
  final DateTime? assignedAt;
  final String? assignedBy;       // FK → users(id)
  final DateTime? completedAt;
  final double? bestScore;

  const UserFichaModel({
    required this.id,
    required this.userId,
    required this.fichaId,
    this.assignedAt,
    this.assignedBy,
    this.completedAt,
    this.bestScore,
  });

  bool get isCompleted => completedAt != null;
}

// ── exercises ─────────────────────────────────────────────────────────────────
class ExerciseModel {
  final String id;
  final String word;
  final int level;
  final VoiceType? voiceType;
  final double successThreshold;
  final String? guideVideoId;     // FK → videos(id)
  final String? createdBy;        // FK → users(id)

  const ExerciseModel({
    required this.id,
    required this.word,
    required this.level,
    this.voiceType,
    this.successThreshold = 0.65,
    this.guideVideoId,
    this.createdBy,
  });
}

// ── exercise_attempts ─────────────────────────────────────────────────────────
class ExerciseAttemptModel {
  final String id;
  final String userId;            // FK → users(id)
  final String exerciseId;        // FK → exercises(id)
  final String? sessionId;        // FK → sessions(id)
  final String audioPath;
  final double? whisperScore;     // 0.0–1.0 from Whisper API
  final bool? passed;
  final DateTime? attemptedAt;

  const ExerciseAttemptModel({
    required this.id,
    required this.userId,
    required this.exerciseId,
    this.sessionId,
    required this.audioPath,
    this.whisperScore,
    this.passed,
    this.attemptedAt,
  });
}

// ── sessions ──────────────────────────────────────────────────────────────────
class SessionModel {
  final String id;
  final String userId;            // FK → users(id)
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int? exercisesDone;
  final double? successRate;      // 0.0–1.0
  final String? logopedaNote;

  const SessionModel({
    required this.id,
    required this.userId,
    this.startedAt,
    this.endedAt,
    this.exercisesDone,
    this.successRate,
    this.logopedaNote,
  });
}

// ── user_voices ───────────────────────────────────────────────────────────────
class UserVoiceModel {
  final String id;
  final String? userId;           // FK → users(id)
  final String audioPath;
  final DateTime? clonedAt;
  final int? durationMs;
  final double? qualityScore;
  final bool isActive;

  const UserVoiceModel({
    required this.id,
    this.userId,
    required this.audioPath,
    this.clonedAt,
    this.durationMs,
    this.qualityScore,
    this.isActive = false,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// UI-only composite: a Módulo groups fichas for display.
// This is NOT a DB table — it is a UI concept you create in the repository
// layer by grouping fichas by level/type. When you connect to the API,
// build this from the fichas endpoint response.
// ─────────────────────────────────────────────────────────────────────────────
class ModuloUI {
  final String id;
  final String title;
  final String subtitle;
  final String iconName;      // Tabler / Material icon name
  final Color bgColor;
  final Color iconColor;
  final int totalFichas;
  final int doneFichas;
  final List<FichaUI> fichas;
  final bool locked;

  const ModuloUI({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconName,
    required this.bgColor,
    required this.iconColor,
    required this.totalFichas,
    required this.doneFichas,
    required this.fichas,
    this.locked = false,
  });

  double get progress => totalFichas == 0 ? 0 : doneFichas / totalFichas;
}

enum FichaStatus { done, active, locked }

class FichaUI {
  final FichaModel ficha;
  final FichaStatus status;
  final UserFichaModel? assignment;   // null if not yet assigned
  final VideoModel? guideVideo;

  const FichaUI({
    required this.ficha,
    required this.status,
    this.assignment,
    this.guideVideo,
  });
}