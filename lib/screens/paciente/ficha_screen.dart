import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';
import '../../../core/models.dart';
import '../../../services/ficha_service.dart';
import '../../../widgets/common.dart';

class FichaScreen extends StatefulWidget {
  final String userFichaId;
  const FichaScreen({super.key, required this.userFichaId});
  @override State<FichaScreen> createState() => _FichaScreenState();
}

class _FichaScreenState extends State<FichaScreen> {
  UserFicha? _userFicha;
  Session?   _session;
  bool _loading = true;
  String? _error;
  int _wordIdx = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final fichas = await FichaService.getMisFichas();
      final uf = fichas.firstWhere((f) => f.id == widget.userFichaId);
      final session = await FichaService.startSession();
      if (!mounted) return;
      setState(() { _userFicha = uf; _session = session; _loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _goGrabar() {
    final ficha = _userFicha?.ficha;
    if (ficha == null || _session == null) return;
    context.go(
      '/ficha/${widget.userFichaId}/grabar/$_wordIdx',
      extra: {'sessionId': _session!.id, 'ficha': ficha},
    );
  }

  @override
  Widget build(BuildContext context) {
    final ficha  = _userFicha?.ficha;
    final words  = ficha?.words ?? [];
    final word   = words.isEmpty ? '...' : words[_wordIdx];

    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(child: Column(children: [
        AppNav(
          backLabel: 'inicio', onBack: () => context.go('/inicio'),
          title: word,
        ),

        Expanded(child: _loading
            ? const Center(child: CircularProgressIndicator(color: C.blue))
            : _error != null
            ? Center(child: ErrorBox(_error!))
            : ListView(padding: const EdgeInsets.only(bottom: 16), children: [
          // Palabra grande
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Column(children: [
              Text(word, style: const TextStyle(
                  fontSize: 64, fontWeight: FontWeight.w500, color: C.txt, height: 1)),
              const SizedBox(height: 3),
              Text(ficha?.name ?? '',
                  style: const TextStyle(fontSize: 12, color: C.txt2),
                  textAlign: TextAlign.center),
            ]),
          ),

          StepDots(total: words.length, current: _wordIdx),

          // Nav entre palabras
          if (words.length > 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              child: Row(children: [
                Expanded(child: BtnS(
                  label: '← Anterior',
                  onTap: _wordIdx > 0
                      ? () => setState(() => _wordIdx--)
                      : null,
                )),
                const SizedBox(width: 8),
                Expanded(child: BtnS(
                  label: 'Siguiente →',
                  onTap: _wordIdx < words.length - 1
                      ? () => setState(() => _wordIdx++)
                      : null,
                )),
              ]),
            ),

          const VideoBox(),
          InstrBox(ficha?.instructions ?? ''),
        ])),

        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: Column(children: [
            BtnP(
              label: 'Listo, voy a practicar',
              onTap: _loading ? null : _goGrabar,
            ),
            const SizedBox(height: 7),
            const BtnS(label: 'Ver el vídeo de nuevo'),
          ]),
        ),
      ])),
    );
  }
}