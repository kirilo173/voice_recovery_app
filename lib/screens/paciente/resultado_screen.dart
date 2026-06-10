import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';
import '../../../core/models.dart';
import '../../../widgets/common.dart';
import '../../../services/ficha_service.dart';

class ResultadoScreen extends StatelessWidget {
  final String  userFichaId;
  final int     wordIdx;
  final Ficha   ficha;
  final Attempt attempt;

  const ResultadoScreen({
    super.key,
    required this.userFichaId,
    required this.wordIdx,
    required this.ficha,
    required this.attempt,
  });

  Color get _color => attempt.scorePercent >= 70 ? C.teal : C.amber;

  String get _feedback {
    final s = attempt.scorePercent;
    if (s >= 85) return '¡Muy bien! Tu pronunciación fue reconocida correctamente. El sistema detectó la palabra completa.';
    if (s >= 70) return 'Bien hecho. El sistema reconoció tu pronunciación. Sigue practicando para mejorar.';
    return 'Casi. El sistema captó parte del sonido. Mira el vídeo de nuevo e inténtalo otra vez.';
  }

  bool get _hasNext => wordIdx < ficha.words.length - 1;

  @override
  Widget build(BuildContext context) {
    final starsLabel = attempt.stars == 3 ? '¡Excelente! 3 estrellas'
        : attempt.stars == 2 ? 'Bien · 2 estrellas'
        : 'Sigue practicando · 1 estrella';

    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(child: Column(children: [
        AppNav(
          backLabel: 'mis ejercicios',
          onBack: () => context.go('/inicio'),
          title: attempt.wordAttempted ?? ficha.words[wordIdx],
        ),

        Expanded(child: ListView(padding: const EdgeInsets.only(bottom: 16), children: [
          // Score
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Column(children: [
              Text('${attempt.scorePercent}%', style: TextStyle(
                  fontSize: 58, fontWeight: FontWeight.w500, color: _color, height: 1)),
              const SizedBox(height: 4),
              Text('Whisper escuchó: "${attempt.wordAttempted ?? ''}"',
                  style: const TextStyle(fontSize: 12, color: C.txt2)),
            ]),
          ),

          // Barra
          Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
            height: 6,
            decoration: BoxDecoration(color: C.bg, borderRadius: BorderRadius.circular(3)),
            child: FractionallySizedBox(
              widthFactor: (attempt.whisperScore ?? 0).clamp(0, 1),
              alignment: Alignment.centerLeft,
              child: Container(
                  decoration: BoxDecoration(color: _color, borderRadius: BorderRadius.circular(3))),
            ),
          ),

          // Feedback
          Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
            decoration: BoxDecoration(
              color: C.tealBg,
              borderRadius: BorderRadius.circular(R.card),
              border: Border.all(color: C.tealBdr, width: 0.5),
            ),
            child: Text(_feedback,
                style: const TextStyle(fontSize: 12, color: C.tealDeep, height: 1.5)),
          ),

          // Estrellas
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                  child: Icon(Icons.star_rounded, size: 22,
                      color: i < attempt.stars ? C.amber : C.border),
                ))),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(starsLabel, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: C.txt2)),
          ),
        ])),

        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: Column(children: [
            BtnP(
              label: _hasNext ? 'Siguiente · ${ficha.words[wordIdx + 1]} ›' : 'Volver a mis ejercicios',
              color: C.teal,
              onTap: () {
                if (_hasNext) {
                  // siguiente palabra de la misma ficha — vuelve a la pantalla de ficha
                  context.go('/ficha/$userFichaId');
                } else {
                  context.go('/inicio');
                }
              },
            ),
            const SizedBox(height: 7),
            BtnS(label: 'Repetir esta palabra',
                onTap: () => context.go('/ficha/$userFichaId')),
            const SizedBox(height: 7),
            BtnS(label: 'Ver el vídeo otra vez',
                onTap: () => context.go('/ficha/$userFichaId')),
          ]),
        ),
      ])),
    );
  }
}