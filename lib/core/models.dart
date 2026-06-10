// ── Enums (igual que en la BD) ────────────────────────────────────────────────

enum UserRole { patient, logopeda }

enum VoiceType { esofagico, electrolaringe }

// ── User (tabla: users) ───────────────────────────────────────────────────────

class AppUser {
  final String id;
  final String email;
  final String? name;
  final String? picture;
  final UserRole role;
  final bool roleSet;
  final VoiceType? voiceType;
  final int currentLevel;
  final int streakDays;
  final String? logopedaId;

  const AppUser({
    required this.id,
    required this.email,
    this.name,
    this.picture,
    required this.role,
    required this.roleSet,
    this.voiceType,
    this.currentLevel = 1,
    this.streakDays = 0,
    this.logopedaId,
  });

  String get displayName => name ?? email.split('@').first;
  String get initials {
    final parts = displayName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (displayName.length >= 2) return displayName.substring(0, 2).toUpperCase();
    return displayName.toUpperCase();
  }

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
    id:           j['id'],
    email:        j['email'],
    name:         j['name'],
    picture:      j['picture'],
    role:         j['role'] == 'logopeda' ? UserRole.logopeda : UserRole.patient,
    roleSet:      j['role_set'] ?? false,
    voiceType:    j['voice_type'] == 'esofagico'
        ? VoiceType.esofagico
        : j['voice_type'] == 'electrolaringe'
        ? VoiceType.electrolaringe
        : null,
    currentLevel: j['current_level'] ?? 1,
    streakDays:   j['streak_days'] ?? 0,
    logopedaId:   j['logopeda_id'],
  );
}

// ── Ficha (tabla: fichas) ─────────────────────────────────────────────────────

class Ficha {
  final String id;
  final String name;
  final int level;
  final String assignmentType; // 'base_nivel' | 'personalizada'
  final VoiceType? voiceTypeFilter;
  final List<String> words;
  final String? instructions;
  final double successThreshold;
  final String? guideVideoId;
  final String? createdBy;

  const Ficha({
    required this.id,
    required this.name,
    required this.level,
    required this.assignmentType,
    this.voiceTypeFilter,
    required this.words,
    this.instructions,
    this.successThreshold = 0.7,
    this.guideVideoId,
    this.createdBy,
  });

  factory Ficha.fromJson(Map<String, dynamic> j) => Ficha(
    id:               j['id'],
    name:             j['name'],
    level:            j['level'] ?? 1,
    assignmentType:   j['assignment_type'] ?? 'personalizada',
    voiceTypeFilter:  j['voice_type_filter'] == 'esofagico'
        ? VoiceType.esofagico
        : j['voice_type_filter'] == 'electrolaringe'
        ? VoiceType.electrolaringe
        : null,
    words:            List<String>.from(j['words'] ?? []),
    instructions:     j['instructions'],
    successThreshold: (j['success_threshold'] ?? 0.7).toDouble(),
    guideVideoId:     j['guide_video_id'],
    createdBy:        j['created_by'],
  );

  Map<String, dynamic> toJson() => {
    'name':               name,
    'level':              level,
    'assignment_type':    assignmentType,
    'voice_type_filter':  voiceTypeFilter?.name,
    'words':              words,
    'instructions':       instructions,
    'success_threshold':  successThreshold,
    'guide_video_id':     guideVideoId,
  };
}

// ── UserFicha (tabla: user_fichas) ────────────────────────────────────────────

class UserFicha {
  final String id;
  final String userId;
  final String fichaId;
  final DateTime? assignedAt;
  final String? assignedBy;
  final DateTime? completedAt;
  final double? bestScore;
  final Ficha? ficha; // join del backend

  const UserFicha({
    required this.id,
    required this.userId,
    required this.fichaId,
    this.assignedAt,
    this.assignedBy,
    this.completedAt,
    this.bestScore,
    this.ficha,
  });

  bool get isCompleted => completedAt != null;
  bool get isPending   => completedAt == null;

  factory UserFicha.fromJson(Map<String, dynamic> j) => UserFicha(
    id:          j['id'],
    userId:      j['user_id'],
    fichaId:     j['ficha_id'],
    assignedAt:  j['assigned_at']  != null ? DateTime.tryParse(j['assigned_at'])  : null,
    assignedBy:  j['assigned_by'],
    completedAt: j['completed_at'] != null ? DateTime.tryParse(j['completed_at']) : null,
    bestScore:   (j['best_score'] as num?)?.toDouble(),
    ficha:       j['ficha'] != null ? Ficha.fromJson(j['ficha']) : null,
  );
}

// ── ExerciseAttempt (tabla: exercise_attempts) ────────────────────────────────

class Attempt {
  final String id;
  final String userId;
  final String? sessionId;
  final double? whisperScore;
  final bool? passed;
  final DateTime? attemptedAt;
  final String? wordAttempted;

  const Attempt({
    required this.id,
    required this.userId,
    this.sessionId,
    this.whisperScore,
    this.passed,
    this.attemptedAt,
    this.wordAttempted,
  });

  int get stars {
    final s = (whisperScore ?? 0) * 100;
    if (s >= 85) return 3;
    if (s >= 70) return 2;
    return 1;
  }

  int get scorePercent => ((whisperScore ?? 0) * 100).round();

  factory Attempt.fromJson(Map<String, dynamic> j) => Attempt(
    id:            j['id'],
    userId:        j['user_id'],
    sessionId:     j['session_id'],
    whisperScore:  (j['whisper_score'] as num?)?.toDouble(),
    passed:        j['passed'],
    attemptedAt:   j['attempted_at'] != null ? DateTime.tryParse(j['attempted_at']) : null,
    wordAttempted: j['word_attempted'],
  );
}

// ── Session (tabla: sessions) ─────────────────────────────────────────────────

class Session {
  final String id;
  final String userId;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int exercisesDone;
  final double? successRate;

  const Session({
    required this.id,
    required this.userId,
    this.startedAt,
    this.endedAt,
    this.exercisesDone = 0,
    this.successRate,
  });

  factory Session.fromJson(Map<String, dynamic> j) => Session(
    id:            j['id'],
    userId:        j['user_id'],
    startedAt:     j['started_at'] != null ? DateTime.tryParse(j['started_at']) : null,
    endedAt:       j['ended_at']   != null ? DateTime.tryParse(j['ended_at'])   : null,
    exercisesDone: j['exercises_done'] ?? 0,
    successRate:   (j['success_rate'] as num?)?.toDouble(),
  );
}

// ── AuthResponse (lo que devuelve el login) ───────────────────────────────────

class AuthResponse {
  final String accessToken;
  final AppUser user;

  const AuthResponse({required this.accessToken, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> j) => AuthResponse(
    accessToken: j['access_token'],
    user:        AppUser.fromJson(j['user']),
  );
}