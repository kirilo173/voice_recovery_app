import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';
import '../../../core/models.dart';
import '../../../services/ficha_service.dart';
import '../../../widgets/common.dart';

class GrabarScreen extends StatefulWidget {
  final String userFichaId;
  final int    wordIdx;
  final String sessionId;
  final Ficha  ficha;

  const GrabarScreen({
    super.key,
    required this.userFichaId,
    required this.wordIdx,
    required this.sessionId,
    required this.ficha,
  });

  @override
  State<GrabarScreen> createState() => _GrabarScreenState();
}

class _GrabarScreenState extends State<GrabarScreen> {
  bool   _isRec   = false;
  bool   _sending = false;
  Timer? _waveTimer;
  Timer? _autoStop;
  String? _error;
  final _rng = Random();
  List<double> _heights = [6, 12, 20, 28, 32, 24, 16, 8, 5];

  // En web, el audio se captura con MediaRecorder (JS).
  // Por ahora enviamos bytes simulados hasta tener el recorder web integrado.
  // TODO: integrar web_audio_recorder o similar para captura real.
  Uint8List? _audioBytes;

  String get _word => widget.ficha.words[widget.wordIdx];

  void _toggle() {
    if (_isRec) {
      _stopRec();
      _enviar();
    } else {
      _startRec();
    }
  }

  void _startRec() {
    setState(() { _isRec = true; _error = null; });
    _waveTimer = Timer.periodic(const Duration(milliseconds: 120), (_) {
      if (!_isRec || !mounted) return;
      setState(() {
        _heights = List.generate(9, (_) => (4 + _rng.nextDouble() * 32).clamp(4, 36));
      });
    });
    // Auto-stop a los 4 segundos
    _autoStop = Timer(const Duration(seconds: 4), () {
      if (_isRec && mounted) { _stopRec(); _enviar(); }
    });
  }

  void _stopRec() {
    _waveTimer?.cancel();
    _autoStop?.cancel();
    setState(() {
      _isRec = false;
      _heights = [6, 12, 20, 28, 32, 24, 16, 8, 5];
      // TODO: recoger _audioBytes del recorder real
      // Por ahora simulamos un WAV vacío de 1KB
      _audioBytes = Uint8List(1024);
    });
  }

  Future<void> _enviar() async {
    if (_audioBytes == null) return;
    setState(() => _sending = true);
    try {
      final attempt = await FichaService.submitAttempt(
        sessionId:    widget.sessionId,
        wordAttempted: _word,
        audioBytes:   _audioBytes!,
      );
      if (!mounted) return;
      context.go(
        '/ficha/${widget.userFichaId}/resultado/${widget.wordIdx}',
        extra: {'ficha': widget.ficha, 'attempt': attempt},
      );
    } catch (e) {
      if (!mounted) return;
      setState(() { _sending = false; _error = 'Error al enviar: ${e.toString()}'; });
    }
  }

  @override
  void dispose() {
    _waveTimer?.cancel();
    _autoStop?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(child: Column(children: [
        AppNav(
          backLabel: 'ver vídeo',
          onBack: () => context.go('/ficha/${widget.userFichaId}'),
          title: _word,
        ),

        Expanded(child: ListView(padding: const EdgeInsets.only(bottom: 16), children: [
          // Palabra grande
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Column(children: [
              Text(_word, style: const TextStyle(
                  fontSize: 64, fontWeight: FontWeight.w500, color: C.txt, height: 1)),
              const SizedBox(height: 3),
              Text(widget.ficha.name,
                  style: const TextStyle(fontSize: 12, color: C.txt2)),
            ]),
          ),

          StepDots(total: widget.ficha.words.length, current: widget.wordIdx),

          // Zona grabación
          Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: C.border, width: 0.5),
              borderRadius: BorderRadius.circular(R.card),
            ),
            child: Column(children: [
              Waveform(active: _isRec, heights: _heights),
              const SizedBox(height: 14),
              _sending
                  ? const CircularProgressIndicator(color: C.blue)
                  : GestureDetector(
                onTap: _toggle,
                child: Container(
                  width: 58, height: 58,
                  decoration: BoxDecoration(
                    color: _isRec ? C.teal : C.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isRec ? Icons.stop_rounded : Icons.mic_rounded,
                    color: Colors.white, size: 22,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                _sending ? 'Analizando...'
                    : _isRec ? 'Grabando… pulsa para parar'
                    : 'Pulsa para grabar',
                style: TextStyle(fontSize: 12,
                    color: _isRec ? C.teal : C.txt2),
              ),
            ]),
          ),

          if (_error != null) ErrorBox(_error!),
        ])),

        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: BtnS(
            label: 'Ver el vídeo de nuevo',
            onTap: () => context.go('/ficha/${widget.userFichaId}'),
          ),
        ),
      ])),
    );
  }
}