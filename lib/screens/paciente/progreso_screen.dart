import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/models.dart';
import '../../services/ficha_service.dart';
import '../../widgets/common.dart';

class ProgresoScreen extends StatefulWidget {
  const ProgresoScreen({super.key});
  @override State<ProgresoScreen> createState() => _ProgresoScreenState();
}

class _ProgresoScreenState extends State<ProgresoScreen> {
  List<Attempt> _intentos = [];
  List<Session> _sessions = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

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

  double get _tasaExito {
    if (_intentos.isEmpty) return 0;
    final passed = _intentos.where((a) => a.passed == true).length;
    return passed / _intentos.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(child: Column(children: [
        AppNav(backLabel: 'inicio', onBack: () => context.go('/inicio'), title: 'Mi progreso'),

        Expanded(child: _loading
            ? const Center(child: CircularProgressIndicator(color: C.blue))
            : _error != null
            ? Center(child: ErrorBox(_error!))
            : ListView(padding: EdgeInsets.zero, children: [
          // Stats
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Expanded(child: StatMini(
                label: 'intentos',
                value: '${_intentos.length}',
              )),
              const SizedBox(width: 10),
              Expanded(child: StatMini(
                label: 'tasa éxito',
                value: '${(_tasaExito * 100).round()}%',
                valueColor: C.teal,
              )),
            ]),
          ),

          // Últimos intentos
          const SLbl('Últimos ejercicios'),
          if (_intentos.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('Aún no has practicado ningún ejercicio.',
                  style: TextStyle(fontSize: 13, color: C.txt2),
                  textAlign: TextAlign.center)),
            )
          else
            ..._intentos.take(20).map((a) => _IntentoRow(attempt: a)),

          const SizedBox(height: 12),
        ])),

        PatientTabBar(current: 1, onTap: (i) {
          if (i == 0) context.go('/inicio');
          if (i == 2) context.go('/perfil');
        }),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ])),
    );
  }
}

class _IntentoRow extends StatelessWidget {
  final Attempt attempt;
  const _IntentoRow({required this.attempt});

  @override
  Widget build(BuildContext context) {
    final pct   = attempt.scorePercent;
    final color = pct >= 70 ? C.teal : C.amber;
    final date  = attempt.attemptedAt != null
        ? '${attempt.attemptedAt!.day}/${attempt.attemptedAt!.month}'
        : '';

    return WCard(child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(attempt.wordAttempted ?? '—',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        Text(date, style: const TextStyle(fontSize: 11, color: C.txt2)),
      ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text('$pct%', style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: color)),
        Row(children: List.generate(3, (i) => Icon(
            Icons.star_rounded, size: 12,
            color: i < attempt.stars ? C.amber : C.border))),
      ]),
    ]));
  }
}