import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/models.dart';
import '../../services/auth_service.dart';
import '../../services/ficha_service.dart';
import '../../widgets/common.dart';

// ══════════════════════════════════════════════════════════════════════════════
//  HOME
// ══════════════════════════════════════════════════════════════════════════════

class PacienteHomePage extends StatefulWidget {
  const PacienteHomePage({super.key});
  @override State<PacienteHomePage> createState() => _PacienteHomePageState();
}

class _PacienteHomePageState extends State<PacienteHomePage> {
  AppUser? _user;
  List<UserFicha> _fichas = [];
  bool _loading = true;
  String? _error;

  @override void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final user   = await AuthService.me();
      final fichas = await FichaService.getMisFichas();
      if (!mounted) return;
      setState(() { _user = user; _fichas = fichas; _loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendientes  = _fichas.where((f) => f.isPending).toList();
    final completadas = _fichas.where((f) => f.isCompleted).toList();

    return _PageScaffold(
      title: 'Mis ejercicios',
      subtitle: _user != null ? 'Hola, ${_user!.displayName}' : null,
      loading: _loading, error: _error, onRetry: _load,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (_user != null && _user!.streakDays > 0)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: C.amberBg,
              borderRadius: BorderRadius.circular(R.card),
              border: Border.all(color: C.amberBdr, width: 0.5),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.local_fire_department_rounded, color: C.amber, size: 18),
              const SizedBox(width: 8),
              Text('${_user!.streakDays} días seguidos · ¡Sigue así!',
                style: const TextStyle(fontSize: 13, color: C.amberDrk)),
            ]),
          ),

        if (_fichas.isEmpty && !_loading)
          const Center(child: Padding(
            padding: EdgeInsets.only(top: 60),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.inbox_outlined, size: 56, color: C.txt3),
              SizedBox(height: 12),
              Text('No tienes fichas asignadas aún.',
                style: TextStyle(fontSize: 14, color: C.txt2)),
            ]),
          )),

        if (pendientes.isNotEmpty) ...[
          const SLbl('Pendientes'),
          ...pendientes.map((uf) => _FichaCard(uf: uf)),
        ],
        if (completadas.isNotEmpty) ...[
          const SLbl('Completadas'),
          ...completadas.map((uf) => _FichaCard(uf: uf, done: true)),
        ],
      ]),
    );
  }
}

class _FichaCard extends StatelessWidget {
  final UserFicha uf;
  final bool done;
  const _FichaCard({required this.uf, this.done = false});

  @override
  Widget build(BuildContext context) {
    final ficha = uf.ficha;
    final words = ficha?.words ?? [];
    final score = uf.bestScore != null ? '${(uf.bestScore! * 100).round()}%' : null;

    return WCard(
      onTap: done ? null : () => context.go('/ficha/${uf.id}'),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: done ? C.tealBg : C.blueBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            done ? Icons.check_circle_outline_rounded : Icons.play_circle_outline_rounded,
            color: done ? C.tealDark : C.blue, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(ficha?.name ?? 'Ficha',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          Text('${words.length} palabras${words.isNotEmpty ? ' · ${words.take(3).join(', ')}' : ''}',
            style: const TextStyle(fontSize: 11, color: C.txt2)),
        ])),
        if (done && score != null) Bdg.green(score),
        if (!done) const Icon(Icons.chevron_right, size: 16, color: C.txt2),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  FICHA DETALLE
// ══════════════════════════════════════════════════════════════════════════════

class PacienteFichaPage extends StatefulWidget {
  final String userFichaId;
  const PacienteFichaPage({super.key, required this.userFichaId});
  @override State<PacienteFichaPage> createState() => _PacienteFichaPageState();
}

class _PacienteFichaPageState extends State<PacienteFichaPage> {
  UserFicha? _uf;
  Session?   _session;
  bool _loading = true;
  String? _error;
  int _wordIdx = 0;

  @override void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final fichas  = await FichaService.getMisFichas();
      final uf      = fichas.firstWhere((f) => f.id == widget.userFichaId);
      final session = await FichaService.startSession();
      if (!mounted) return;
      setState(() { _uf = uf; _session = session; _loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ficha = _uf?.ficha;
    final words = ficha?.words ?? [];
    final word  = words.isEmpty ? '...' : words[_wordIdx];

    return _PageScaffold(
      title: word, subtitle: ficha?.name, backRoute: '/inicio',
      loading: _loading, error: _error, onRetry: _load,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(children: [
              Text(word, style: const TextStyle(
                fontSize: 72, fontWeight: FontWeight.w500, color: C.txt, height: 1)),
              const SizedBox(height: 6),
              StepDots(total: words.length, current: _wordIdx),
            ]),
          )),
          if (words.length > 1)
            Row(children: [
              Expanded(child: BtnS(label: '← Anterior',
                onTap: _wordIdx > 0 ? () => setState(() => _wordIdx--) : null)),
              const SizedBox(width: 8),
              Expanded(child: BtnS(label: 'Siguiente →',
                onTap: _wordIdx < words.length - 1 ? () => setState(() => _wordIdx++) : null)),
            ]),
          const SizedBox(height: 16),
          const VideoBox(),
          const SizedBox(height: 12),
          InstrBox(ficha?.instructions ?? ''),
        ])),
        const SizedBox(width: 24),
        Expanded(flex: 2, child: Column(children: [
          const SizedBox(height: 24),
          WCard(child: Column(children: [
            const Icon(Icons.mic_rounded, size: 32, color: C.blue),
            const SizedBox(height: 8),
            const Text('¿Listo para practicar?',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text('Palabra: $word',
              style: const TextStyle(fontSize: 12, color: C.txt2)),
            const SizedBox(height: 16),
            BtnP(
              label: 'Empezar a grabar',
              icon: Icons.mic_rounded,
              onTap: _session == null ? null : () => context.go(
                '/ficha/${widget.userFichaId}/grabar/$_wordIdx',
                extra: {'sessionId': _session!.id, 'ficha': ficha},
              ),
            ),
            const SizedBox(height: 8),
            const BtnS(label: 'Ver el vídeo de nuevo'),
          ])),
        ])),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  GRABAR
// ══════════════════════════════════════════════════════════════════════════════

class PacienteGrabarPage extends StatefulWidget {
  final String userFichaId;
  final int    wordIdx;
  final String sessionId;
  final Ficha  ficha;

  const PacienteGrabarPage({
    super.key, required this.userFichaId, required this.wordIdx,
    required this.sessionId, required this.ficha,
  });
  @override State<PacienteGrabarPage> createState() => _PacienteGrabarPageState();
}

class _PacienteGrabarPageState extends State<PacienteGrabarPage> {
  bool   _isRec   = false;
  bool   _sending = false;
  String? _error;
  Timer? _waveTimer;
  Timer? _autoStop;
  final _rng = Random();
  List<double> _heights = [6,10,18,26,32,22,14,8,5,7,12,20,28,16,10];
  Uint8List? _audioBytes;

  String get _word => widget.ficha.words[widget.wordIdx];

  void _toggle() {
    if (_isRec) { _stopRec(); _enviar(); }
    else { _startRec(); }
  }

  void _startRec() {
    setState(() { _isRec = true; _error = null; });
    _waveTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!_isRec || !mounted) return;
      setState(() {
        _heights = List.generate(15, (_) => (4 + _rng.nextDouble() * 36).clamp(4, 40));
      });
    });
    _autoStop = Timer(const Duration(seconds: 4), () {
      if (_isRec && mounted) { _stopRec(); _enviar(); }
    });
  }

  void _stopRec() {
    _waveTimer?.cancel(); _autoStop?.cancel();
    setState(() {
      _isRec = false;
      _heights = [6,10,18,26,32,22,14,8,5,7,12,20,28,16,10];
      _audioBytes = Uint8List(1024);
    });
  }

  Future<void> _enviar() async {
    if (_audioBytes == null) return;
    setState(() => _sending = true);
    try {
      final attempt = await FichaService.submitAttempt(
        sessionId: widget.sessionId,
        wordAttempted: _word,
        audioBytes: _audioBytes!,
      );
      if (!mounted) return;
      context.go(
        '/ficha/${widget.userFichaId}/resultado/${widget.wordIdx}',
        extra: {'ficha': widget.ficha, 'attempt': attempt},
      );
    } catch (e) {
      if (!mounted) return;
      setState(() { _sending = false; _error = e.toString(); });
    }
  }

  @override void dispose() { _waveTimer?.cancel(); _autoStop?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return _PageScaffold(
      title: 'Grabando: $_word',
      subtitle: widget.ficha.name,
      backRoute: '/ficha/${widget.userFichaId}',
      child: Center(child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        child: WCard(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(_word, style: const TextStyle(
              fontSize: 64, fontWeight: FontWeight.w500, color: C.txt, height: 1)),
          ),
          StepDots(total: widget.ficha.words.length, current: widget.wordIdx),
          const SizedBox(height: 20),
          Waveform(active: _isRec, heights: _heights),
          const SizedBox(height: 20),
          _sending
            ? const Column(children: [
                CircularProgressIndicator(color: C.blue),
                SizedBox(height: 12),
                Text('Analizando...', style: TextStyle(fontSize: 13, color: C.txt2)),
              ])
            : GestureDetector(
                onTap: _toggle,
                child: Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(
                    color: _isRec ? C.teal : C.red,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(
                      color: (_isRec ? C.teal : C.red).withOpacity(0.3),
                      blurRadius: 16, spreadRadius: 2)],
                  ),
                  child: Icon(
                    _isRec ? Icons.stop_rounded : Icons.mic_rounded,
                    color: Colors.white, size: 28),
                ),
              ),
          const SizedBox(height: 14),
          if (!_sending)
            Text(
              _isRec ? 'Grabando… pulsa para parar' : 'Pulsa el micrófono para grabar',
              style: TextStyle(fontSize: 13, color: _isRec ? C.teal : C.txt2),
            ),
          if (_error != null) ...[const SizedBox(height: 12), ErrorBox(_error!)],
          const SizedBox(height: 20),
          if (!_sending)
            BtnS(label: 'Ver el vídeo de nuevo', fullWidth: false,
              onTap: () => context.go('/ficha/${widget.userFichaId}')),
        ])),
      )),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  RESULTADO
// ══════════════════════════════════════════════════════════════════════════════

class PacienteResultadoPage extends StatelessWidget {
  final String  userFichaId;
  final int     wordIdx;
  final Ficha   ficha;
  final Attempt attempt;

  const PacienteResultadoPage({
    super.key, required this.userFichaId, required this.wordIdx,
    required this.ficha, required this.attempt,
  });

  Color get _color => attempt.scorePercent >= 70 ? C.teal : C.amber;
  bool  get _hasNext => wordIdx < ficha.words.length - 1;

  String get _feedback {
    final s = attempt.scorePercent;
    if (s >= 85) return '¡Muy bien! Tu pronunciación fue reconocida correctamente.';
    if (s >= 70) return 'Bien hecho. El sistema reconoció tu pronunciación. Sigue practicando.';
    return 'Casi. Mira el vídeo de nuevo e inténtalo otra vez con más calma.';
  }

  @override
  Widget build(BuildContext context) {
    return _PageScaffold(
      title: 'Resultado',
      subtitle: attempt.wordAttempted ?? '',
      backRoute: '/inicio',
      child: Center(child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        child: WCard(child: Column(children: [
          Text('${attempt.scorePercent}%', style: TextStyle(
            fontSize: 64, fontWeight: FontWeight.w700, color: _color, height: 1)),
          const SizedBox(height: 4),
          Text('Whisper escuchó: "${attempt.wordAttempted ?? ''}"',
            style: const TextStyle(fontSize: 13, color: C.txt2)),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (attempt.whisperScore ?? 0).clamp(0.0, 1.0),
              backgroundColor: C.bg,
              valueColor: AlwaysStoppedAnimation(_color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: C.tealBg, borderRadius: BorderRadius.circular(10),
              border: Border.all(color: C.tealBdr, width: 0.5),
            ),
            child: Text(_feedback,
              style: const TextStyle(fontSize: 13, color: C.tealDeep, height: 1.5)),
          ),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Icon(Icons.star_rounded, size: 28,
                color: i < attempt.stars ? C.amber : C.border),
            ))),
          const SizedBox(height: 4),
          Text(
            attempt.stars == 3 ? '¡Excelente! 3 estrellas'
              : attempt.stars == 2 ? 'Bien · 2 estrellas'
              : 'Sigue practicando · 1 estrella',
            style: const TextStyle(fontSize: 12, color: C.txt2)),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: BtnP(
              label: _hasNext ? 'Siguiente: ${ficha.words[wordIdx + 1]}' : 'Volver',
              color: C.teal,
              onTap: () => context.go('/inicio'),
            )),
            const SizedBox(width: 8),
            Expanded(child: BtnS(
              label: 'Repetir',
              onTap: () => context.go('/ficha/$userFichaId'),
            )),
          ]),
        ])),
      )),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  PROGRESO
// ══════════════════════════════════════════════════════════════════════════════

class PacienteProgresoPage extends StatefulWidget {
  const PacienteProgresoPage({super.key});
  @override State<PacienteProgresoPage> createState() => _PacienteProgresoPageState();
}

class _PacienteProgresoPageState extends State<PacienteProgresoPage> {
  List<Attempt> _intentos = [];
  bool _loading = true;
  String? _error;

  @override void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final intentos = await FichaService.getMisIntentos();
      if (!mounted) return;
      setState(() { _intentos = intentos; _loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  double get _tasa {
    if (_intentos.isEmpty) return 0;
    return _intentos.where((a) => a.passed == true).length / _intentos.length;
  }

  @override
  Widget build(BuildContext context) {
    return _PageScaffold(
      title: 'Mi progreso',
      loading: _loading, error: _error, onRetry: _load,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: StatBox(value: '${_intentos.length}', label: 'intentos totales')),
          const SizedBox(width: 12),
          Expanded(child: StatBox(
            value: '${(_tasa * 100).round()}%',
            label: 'tasa de éxito', valueColor: C.teal)),
          const SizedBox(width: 12),
          Expanded(child: StatBox(
            value: '${_intentos.where((a) => a.passed == true).length}',
            label: 'superados')),
        ]),
        const SizedBox(height: 24),
        const SLbl('Historial de intentos'),
        if (_intentos.isEmpty)
          const Center(child: Padding(
            padding: EdgeInsets.only(top: 40),
            child: Text('Aún no has practicado ningún ejercicio.',
              style: TextStyle(fontSize: 13, color: C.txt2)),
          ))
        else
          ..._intentos.map((a) {
            final color = a.scorePercent >= 70 ? C.teal : C.amber;
            final date  = a.attemptedAt != null
              ? '${a.attemptedAt!.day}/${a.attemptedAt!.month}' : '';
            return WCard(child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(a.wordAttempted ?? '—',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                Text(date, style: const TextStyle(fontSize: 11, color: C.txt2)),
              ])),
              Row(children: List.generate(3, (i) => Icon(
                Icons.star_rounded, size: 14,
                color: i < a.stars ? C.amber : C.border))),
              const SizedBox(width: 12),
              Text('${a.scorePercent}%', style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: color)),
              const SizedBox(width: 8),
              a.passed == true ? Bdg.green('✓') : Bdg.amber('×'),
            ]));
          }),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  PERFIL
// ══════════════════════════════════════════════════════════════════════════════

class PacientePerfilPage extends StatefulWidget {
  const PacientePerfilPage({super.key});
  @override State<PacientePerfilPage> createState() => _PacientePerfilPageState();
}

class _PacientePerfilPageState extends State<PacientePerfilPage> {
  AppUser? _user;
  bool _loading = true;
  String? _error;
  final _codeCtrl = TextEditingController();

  @override void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final user = await AuthService.me();
      if (!mounted) return;
      setState(() { _user = user; _loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _vincular() async {
    final code = _codeCtrl.text.trim();
    if (code.isEmpty) return;
    try {
      await AuthService.linkWithCode(code);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Vinculado correctamente!'),
          backgroundColor: C.teal));
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: C.red));
    }
  }

  @override void dispose() { _codeCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final voiceLabel = _user?.voiceType == VoiceType.esofagico ? 'Esofágica'
      : _user?.voiceType == VoiceType.electrolaringe ? 'Electrolaringe' : 'No definido';

    return _PageScaffold(
      title: 'Mi perfil',
      loading: _loading, error: _error, onRetry: _load,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 2, child: WCard(child: Column(children: [
          CircleAvatar(radius: 32, backgroundColor: C.blueBg,
            child: Text(_user?.initials ?? '??',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: C.blue))),
          const SizedBox(height: 12),
          Text(_user?.displayName ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(_user?.email ?? '',
            style: const TextStyle(fontSize: 12, color: C.txt2)),
          const SizedBox(height: 16),
          const Divider(),
          _Row('Tipo de voz', voiceLabel),
          _Row('Nivel', 'Nivel ${_user?.currentLevel ?? 1}'),
          _Row('Racha', '${_user?.streakDays ?? 0} días'),
          _Row('Rol', _user?.role == UserRole.logopeda ? 'Logopeda' : 'Paciente'),
        ]))),
        const SizedBox(width: 16),
        Expanded(child: WCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Conectar con logopeda',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          const Text('Introduce el código que te facilite tu logopeda',
            style: TextStyle(fontSize: 12, color: C.txt2)),
          const SizedBox(height: 12),
          TextField(
            controller: _codeCtrl,
            decoration: const InputDecoration(hintText: 'RTV-XXXX'),
            textCapitalization: TextCapitalization.characters,
          ),
          const SizedBox(height: 8),
          BtnP(label: 'Vincular', icon: Icons.link_rounded, onTap: _vincular),
        ]))),
      ]),
    );
  }
}

class _Row extends StatelessWidget {
  final String l, v;
  const _Row(this.l, this.v);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(l, style: const TextStyle(fontSize: 13, color: C.txt2)),
      Text(v, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
    ]),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
//  _PageScaffold
// ══════════════════════════════════════════════════════════════════════════════

class _PageScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? child;
  final bool loading;
  final String? error;
  final VoidCallback? onRetry;
  final String? backRoute;

  const _PageScaffold({
    required this.title, this.subtitle, this.child,
    this.loading = false, this.error, this.onRetry, this.backRoute,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: C.bg,
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: const BoxDecoration(
            color: C.surface,
            border: Border(bottom: BorderSide(color: C.border, width: 0.5))),
          child: Row(children: [
            if (backRoute != null) ...[
              GestureDetector(
                onTap: () => context.go(backRoute!),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: C.blue)),
              const SizedBox(width: 10),
            ],
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: C.txt)),
              if (subtitle != null)
                Text(subtitle!, style: const TextStyle(fontSize: 12, color: C.txt2)),
            ])),
          ]),
        ),
        Expanded(child: loading
          ? const Center(child: CircularProgressIndicator(color: C.blue))
          : error != null
              ? Center(child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    ErrorBox(error!),
                    if (onRetry != null) ...[
                      const SizedBox(height: 12),
                      BtnP(label: 'Reintentar', onTap: onRetry,
                        icon: Icons.refresh_rounded, fullWidth: false),
                    ],
                  ])))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: child ?? const SizedBox())),
      ]),
    );
  }
}
