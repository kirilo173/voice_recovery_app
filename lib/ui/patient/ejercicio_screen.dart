// ─────────────────────────────────────────────────────────────────────────────
// patient/ejercicio_screen.dart
// Covers: Ejercicio (intro) → Grabar → Resultado
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:voice_rec_app/ui/shared_widgets.dart';
import '../../../data/models.dart';
import '../../../theme/app_theme.dart';
import 'package:voice_rec_app/ui/shared_widgets.dart';

class EjercicioScreen extends StatefulWidget {
  final FichaUI fichaUI;
  final ModuloUI modulo;

  const EjercicioScreen({super.key, required this.fichaUI, required this.modulo});

  @override
  State<EjercicioScreen> createState() => _EjercicioScreenState();
}

class _EjercicioScreenState extends State<EjercicioScreen> {
  int _currentItem = 0;
  _SubScreen _sub = _SubScreen.intro;

  // Recording state
  bool _isRecording = false;
  Timer? _waveTimer;
  final List<double> _waveBars = List.filled(9, 0.3);
  final _rng = Random();

  // Result state
  double _score = 0;

  List<String> get _items {
    final words = widget.fichaUI.ficha.words;
    return words.isEmpty ? [widget.fichaUI.ficha.name] : words;
  }

  String get _currentWord => _items[_currentItem];

  @override
  void dispose() {
    _waveTimer?.cancel();
    super.dispose();
  }

  void _goGrabar() => setState(() => _sub = _SubScreen.grabar);

  void _toggleRecording() {
    if (_isRecording) {
      _stopAndSimulate();
    } else {
      setState(() {
        _isRecording = true;
        _sub = _SubScreen.grabar;
      });
      _animateWave();
      // Auto-stop after 3s for demo
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _isRecording) _stopAndSimulate();
      });
    }
  }

  void _animateWave() {
    _waveTimer = Timer.periodic(const Duration(milliseconds: 120), (_) {
      if (!_isRecording) return;
      setState(() {
        for (int i = 0; i < _waveBars.length; i++) {
          _waveBars[i] = 0.1 + _rng.nextDouble() * 0.9;
        }
      });
    });
  }

  void _stopAndSimulate() {
    _waveTimer?.cancel();
    final scores = [0.87, 0.91, 0.78, 0.65, 0.82, 0.95, 0.72, 0.88];
    final score = scores[_rng.nextInt(scores.length)];
    setState(() {
      _isRecording = false;
      _score = score;
      _sub = _SubScreen.resultado;
      for (int i = 0; i < _waveBars.length; i++) _waveBars[i] = 0.3;
    });
  }

  void _nextItem() {
    if (_currentItem < _items.length - 1) {
      setState(() {
        _currentItem++;
        _sub = _SubScreen.intro;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _retry() {
    setState(() {
      _sub = _SubScreen.grabar;
      _isRecording = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F0),
      body: SafeArea(
        child: Column(
          children: [
            // Nav
            _buildNav(context),
            // Content
            Expanded(child: _buildBody()),
            // Buttons
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNav(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: _sub == _SubScreen.grabar
                ? () => setState(() => _sub = _SubScreen.intro)
                : () => Navigator.pop(context),
            child: const Row(
              children: [
                Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: AppColors.blue600),
                SizedBox(width: 3),
                Text('volver', style: TextStyle(fontSize: 12, color: AppColors.blue600)),
              ],
            ),
          ),
          Expanded(
            child: Text(
              _currentWord,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 50),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Big word
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Column(
              children: [
                Text(_currentWord, style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E), height: 1)),
                const SizedBox(height: 4),
                Text(
                  '${widget.fichaUI.ficha.words.isEmpty ? "" : widget.fichaUI.ficha.name} · ${widget.modulo.title}',
                  style: AppText.cardSub,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Step dots
          if (_items.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_items.length, (i) => Container(
                  width: 6, height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < _currentItem
                        ? AppColors.blue400
                        : i == _currentItem
                        ? AppColors.blue600
                        : AppColors.gray50,
                  ),
                )),
              ),
            ),

          if (_sub == _SubScreen.intro) ...[
            // Video box
            const SizedBox(height: 4),
            const VideoGuideBox(),
            const SizedBox(height: 10),
            // Instructions
            if (widget.fichaUI.ficha.instructions != null && widget.fichaUI.ficha.instructions!.isNotEmpty)
              InstructionBox(text: widget.fichaUI.ficha.instructions!),
            const SizedBox(height: 8),
            // Hint
            HintRow('No fuerces. Si no sale el sonido, no pasa nada, inténtalo de nuevo.'),
          ],

          if (_sub == _SubScreen.grabar) ...[
            // Wave + mic
            Container(
              margin: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0x26000000), width: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Wave bars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(_waveBars.length, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: 4,
                      height: (_waveBars[i] * 32).clamp(4.0, 32.0),
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      decoration: BoxDecoration(
                        color: _isRecording ? AppColors.teal400 : AppColors.gray200,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    )),
                  ),
                  const SizedBox(height: 14),
                  // Mic button
                  GestureDetector(
                    onTap: _toggleRecording,
                    child: Container(
                      width: 58, height: 58,
                      decoration: BoxDecoration(
                        color: _isRecording ? AppColors.teal400 : AppColors.red400,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                        color: Colors.white, size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isRecording ? 'Grabando… pulsa para parar' : 'Pulsa para grabar',
                    style: AppText.cardSub,
                  ),
                ],
              ),
            ),
            HintRow('No fuerces. Si no sale el sonido, no pasa nada, inténtalo de nuevo.'),
          ],

          if (_sub == _SubScreen.resultado) ...[
            // Score area
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Column(
                children: [
                  Text(
                    '${(_score * 100).round()}%',
                    style: TextStyle(fontSize: 58, fontWeight: FontWeight.w500, color: _score >= 0.70 ? AppColors.teal400 : AppColors.amber400, height: 1),
                  ),
                  Text('Whisper escuchó: "${_currentWord.toLowerCase()}"', style: AppText.cardSub),
                ],
              ),
            ),
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: _score,
                  backgroundColor: AppColors.gray50,
                  valueColor: AlwaysStoppedAnimation(_score >= 0.70 ? AppColors.teal400 : AppColors.amber400),
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Feedback box
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.teal50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.teal100, width: 0.5),
              ),
              child: Text(_feedbackText, style: const TextStyle(fontSize: 12, color: AppColors.teal800, height: 1.5)),
            ),
            const SizedBox(height: 8),
            // Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) => Icon(
                i < _stars ? Icons.star_rounded : Icons.star_outline_rounded,
                color: i < _stars ? AppColors.amber400 : AppColors.gray200,
                size: 22,
              )),
            ),
            Text(_starsLabel, style: AppText.cardSub, textAlign: TextAlign.center),
          ],

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F4F0),
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(
        children: [
          if (_sub == _SubScreen.intro) ...[
            PrimaryButton(label: 'Listo, voy a practicar', onTap: _goGrabar),
            SecondaryButton(label: 'Ver el vídeo de nuevo', onTap: () {}),
          ],
          if (_sub == _SubScreen.grabar)
            SecondaryButton(label: 'Ver el vídeo de nuevo', onTap: () => setState(() => _sub = _SubScreen.intro)),
          if (_sub == _SubScreen.resultado) ...[
            PrimaryButton(
              label: _currentItem < _items.length - 1 ? 'Siguiente · ${_items[_currentItem + 1]} ›' : 'Volver al módulo',
              onTap: _nextItem,
              color: AppColors.teal400,
            ),
            SecondaryButton(label: 'Repetir', onTap: _retry),
            SecondaryButton(label: 'Ver el vídeo otra vez', onTap: () => setState(() => _sub = _SubScreen.intro)),
          ],
        ],
      ),
    );
  }

  String get _feedbackText {
    if (_score >= 0.85) return '¡Muy bien! Tu pronunciación fue reconocida correctamente. El sistema detectó la palabra completa.';
    if (_score >= 0.70) return 'Bien hecho. El sistema reconoció tu pronunciación. Sigue practicando para mejorar.';
    return 'Casi. El sistema captó parte del sonido. Mira el vídeo de nuevo e inténtalo otra vez.';
  }

  int get _stars => _score >= 0.85 ? 3 : _score >= 0.70 ? 2 : 1;

  String get _starsLabel => _stars == 3 ? '¡Excelente! 3 estrellas' : _stars == 2 ? 'Bien · 2 estrellas' : 'Sigue practicando · 1 estrella';
}

enum _SubScreen { intro, grabar, resultado }