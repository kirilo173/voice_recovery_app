import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/models.dart';
import '../../services/logopeda_service.dart';
import '../../widgets/common.dart';

class PacienteDetalleScreen extends StatefulWidget {
  final String pacienteId;
  const PacienteDetalleScreen({super.key, required this.pacienteId});
  @override State<PacienteDetalleScreen> createState() => _PacienteDetalleScreenState();
}

class _PacienteDetalleScreenState extends State<PacienteDetalleScreen> {
  AppUser?      _paciente;
  List<UserFicha> _fichas   = [];
  List<Attempt>   _intentos = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      // Cargamos todos los pacientes y filtramos el que buscamos
      final pacientes = await LogopedaService.getMisPacientes();
      final paciente  = pacientes.firstWhere((p) => p.id == widget.pacienteId);
      final fichas    = await LogopedaService.getFichasDePaciente(widget.pacienteId);
      final intentos  = await LogopedaService.getIntentosDePaciente(widget.pacienteId);
      if (!mounted) return;
      setState(() {
        _paciente = paciente;
        _fichas   = fichas;
        _intentos = intentos;
        _loading  = false;
      });
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
        AppNav(
          backLabel: 'panel',
          onBack: () => context.go('/logopeda'),
          title: _paciente?.displayName ?? 'Paciente',
        ),

        Expanded(child: _loading
            ? const Center(child: CircularProgressIndicator(color: C.blue))
            : _error != null
            ? Center(child: ErrorBox(_error!))
            : ListView(padding: EdgeInsets.zero, children: [
          // Header paciente
          Container(
            color: C.surface,
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Row(children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: C.blueBg,
                child: Text(_paciente?.initials ?? '??',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500, color: C.blue)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_paciente?.displayName ?? '',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                Text(_paciente?.email ?? '',
                    style: const TextStyle(fontSize: 12, color: C.txt2)),
                const SizedBox(height: 2),
                Text(
                    _paciente?.voiceType == VoiceType.esofagico ? 'Voz esofágica'
                        : _paciente?.voiceType == VoiceType.electrolaringe ? 'Electrolaringe'
                        : 'Tipo de voz no definido',
                    style: const TextStyle(fontSize: 11, color: C.txt2)),
              ])),
            ]),
          ),
          const Divider(),

          // Stats
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
            child: Row(children: [
              Expanded(child: StatMini(
                label: 'tasa éxito',
                value: '${(_tasaExito * 100).round()}%',
                valueColor: C.teal,
              )),
              const SizedBox(width: 8),
              Expanded(child: StatMini(
                label: 'intentos',
                value: '${_intentos.length}',
              )),
              const SizedBox(width: 8),
              Expanded(child: StatMini(
                label: 'fichas',
                value: '${_fichas.length}',
              )),
            ]),
          ),

          // Fichas asignadas
          const SLbl('Fichas asignadas'),
          if (_fichas.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text('Sin fichas asignadas',
                  style: TextStyle(fontSize: 12, color: C.txt2)),
            )
          else
            ..._fichas.map((uf) => WCard(child: Row(children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: uf.isCompleted ? C.tealBg : C.blueBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                    uf.isCompleted
                        ? Icons.check_circle_outline_rounded
                        : Icons.description_outlined,
                    color: uf.isCompleted ? C.tealDark : C.blue, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(uf.ficha?.name ?? uf.fichaId,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                Text('${uf.ficha?.words.length ?? 0} palabras',
                    style: const TextStyle(fontSize: 11, color: C.txt2)),
              ])),
              if (uf.bestScore != null)
                Bdg.green('${(uf.bestScore! * 100).round()}%'),
              if (uf.isCompleted)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Bdg.green('hecho'),
                ),
            ]))),

          // Últimos intentos
          const SLbl('Últimos intentos'),
          if (_intentos.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text('Sin actividad registrada',
                  style: TextStyle(fontSize: 12, color: C.txt2)),
            )
          else
            ..._intentos.take(10).map((a) => WCard(child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(a.wordAttempted ?? '—',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                Text(a.attemptedAt != null
                    ? '${a.attemptedAt!.day}/${a.attemptedAt!.month}/${a.attemptedAt!.year}'
                    : '',
                    style: const TextStyle(fontSize: 11, color: C.txt2)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('${a.scorePercent}%', style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500,
                    color: a.scorePercent >= 70 ? C.teal : C.amber)),
                Row(children: List.generate(3, (i) => Icon(
                    Icons.star_rounded, size: 11,
                    color: i < a.stars ? C.amber : C.border))),
              ]),
            ]))),

          // Botones acción
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
            child: Column(children: [
              BtnP(
                label: 'Asignar nueva ficha',
                icon: Icons.add_rounded,
                onTap: () => context.go('/logopeda/asignar/${widget.pacienteId}'),
              ),
            ]),
          ),
        ])),
      ])),
    );
  }
}

// Re-export para que el Bdg.green funcione sin conflicto
extension _BdgExt on Bdg {
  static Bdg green(String l) => Bdg(label: l, bg: C.tealBg, fg: C.tealDark);
}