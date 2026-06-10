import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';
import '../../../core/models.dart';
import '../../../services/auth_service.dart';
import '../../../services/logopeda_service.dart';
import '../../../widgets/common.dart';

class PanelScreen extends StatefulWidget {
  const PanelScreen({super.key});
  @override State<PanelScreen> createState() => _PanelScreenState();
}

class _PanelScreenState extends State<PanelScreen> {
  int _tab = 0;
  AppUser? _logopeda;
  List<AppUser> _pacientes = [];
  List<Ficha>   _fichas    = [];
  Map<String, dynamic> _stats = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final logopeda  = await AuthService.me();
      final pacientes = await LogopedaService.getMisPacientes();
      final fichas    = await LogopedaService.getMisFichas();
      final stats     = await LogopedaService.getStats();
      if (!mounted) return;
      setState(() {
        _logopeda  = logopeda;
        _pacientes = pacientes;
        _fichas    = fichas;
        _stats     = stats;
        _loading   = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: Column(children: [
        // Status bar
        Container(color: C.blue, height: MediaQuery.of(context).padding.top),
        // Hero
        Container(color: C.blue, child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const SizedBox(),
              GestureDetector(
                onTap: () async { await AuthService.logout(); if (mounted) context.go('/login'); },
                child: const Icon(Icons.logout_rounded, color: Colors.white, size: 18),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('panel logopeda',
                style: TextStyle(fontSize: 10, color: Color(0xB3FFFFFF))),
              const SizedBox(height: 2),
              Text(_logopeda?.displayName ?? 'Cargando...',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white)),
              Text('${_pacientes.length} pacientes',
                style: const TextStyle(fontSize: 12, color: Color(0xBFFFFFFF))),
            ]),
          ),
        ])),

        Expanded(child: _loading
          ? const Center(child: CircularProgressIndicator(color: C.blue))
          : _error != null
              ? Center(child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    ErrorBox(_error!),
                    const SizedBox(height: 12),
                    BtnP(label: 'Reintentar', onTap: _load, icon: Icons.refresh_rounded),
                  ])))
              : _body(),
        ),

        LogopedaTabBar(current: _tab, onTap: (i) => setState(() => _tab = i)),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ]),
    );
  }

  Widget _body() => switch (_tab) {
    0 => _HomeTab(pacientes: _pacientes, stats: _stats),
    1 => _FichasTab(fichas: _fichas),
    2 => _PacientesTab(pacientes: _pacientes),
    _ => const SizedBox(),
  };
}

// ── Tab Inicio ────────────────────────────────────────────────────────────────

class _HomeTab extends StatelessWidget {
  final List<AppUser> pacientes;
  final Map<String, dynamic> stats;
  const _HomeTab({required this.pacientes, required this.stats});

  @override
  Widget build(BuildContext context) {
    final numPacientes = stats['pacientes'] ?? pacientes.length;
    final numSesiones  = stats['sesiones']  ?? 0;
    final tasaExito    = stats['tasa_exito'] != null
        ? '${((stats['tasa_exito'] as num) * 100).round()}%'
        : '—';

    return ListView(padding: EdgeInsets.zero, children: [
      // Stats
      Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
        child: Row(children: [
          Expanded(child: StatMini(label: 'pacientes',  value: '$numPacientes')),
          const SizedBox(width: 8),
          Expanded(child: StatMini(label: 'sesiones',   value: '$numSesiones')),
          const SizedBox(width: 8),
          Expanded(child: StatMini(label: 'tasa éxito', value: tasaExito, valueColor: C.teal)),
        ]),
      ),

      const SLbl('Pacientes recientes'),
      ...pacientes.take(3).map((p) => _PacienteRow(
        p: p,
        onTap: () => context.go('/logopeda/paciente/${p.id}'),
      )),

      const SLbl('Acciones'),
      Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: Column(children: [
          BtnP(
            label: 'Crear nueva ficha',
            icon: Icons.add_rounded,
            onTap: () => context.go('/logopeda/nueva-ficha'),
          ),
          const SizedBox(height: 7),
          BtnS(label: 'Generar código de vinculación',
            onTap: () async {
              try {
                final code = await LogopedaService.generarCodigo();
                if (context.mounted) {
                  showDialog(context: context, builder: (_) => AlertDialog(
                    title: const Text('Código de vinculación'),
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Text('Comparte este código con tu paciente:',
                        style: TextStyle(fontSize: 13)),
                      const SizedBox(height: 12),
                      Text(code, style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w700,
                        color: C.blue, letterSpacing: 4)),
                    ]),
                    actions: [TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar'),
                    )],
                  ));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')));
                }
              }
            }),
        ]),
      ),
    ]);
  }
}

// ── Tab Fichas ────────────────────────────────────────────────────────────────

class _FichasTab extends StatelessWidget {
  final List<Ficha> fichas;
  const _FichasTab({required this.fichas});

  @override
  Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.zero, children: [
      const SLbl('Mis fichas'),
      if (fichas.isEmpty)
        const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: Text('Aún no has creado ninguna ficha.',
            style: TextStyle(fontSize: 13, color: C.txt2),
            textAlign: TextAlign.center)),
        )
      else
        ...fichas.map((f) => WCard(child: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: C.blueBg, borderRadius: BorderRadius.circular(9)),
            child: const Icon(Icons.description_outlined, color: C.blue, size: 17),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(f.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            Text('${f.words.length} palabras · nivel ${f.level}',
              style: const TextStyle(fontSize: 11, color: C.txt2)),
          ])),
          const Icon(Icons.chevron_right, size: 16, color: C.txt2),
        ]))),

      Padding(
        padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
        child: BtnP(
          label: 'Crear nueva ficha',
          icon: Icons.add_rounded,
          onTap: () => context.go('/logopeda/nueva-ficha'),
        ),
      ),
    ]);
  }
}

// ── Tab Pacientes ─────────────────────────────────────────────────────────────

class _PacientesTab extends StatelessWidget {
  final List<AppUser> pacientes;
  const _PacientesTab({required this.pacientes});

  @override
  Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.zero, children: [
      const SLbl('Mis pacientes'),
      if (pacientes.isEmpty)
        const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: Text('Aún no tienes pacientes vinculados.',
            style: TextStyle(fontSize: 13, color: C.txt2),
            textAlign: TextAlign.center)),
        )
      else
        ...pacientes.map((p) => _PacienteRow(
          p: p,
          onTap: () => context.go('/logopeda/paciente/${p.id}'),
        )),
    ]);
  }
}

// ── Fila paciente ─────────────────────────────────────────────────────────────

class _PacienteRow extends StatelessWidget {
  final AppUser p;
  final VoidCallback? onTap;
  const _PacienteRow({required this.p, this.onTap});

  @override
  Widget build(BuildContext context) {
    final voiceLabel = p.voiceType == VoiceType.esofagico
        ? 'Esofágica'
        : p.voiceType == VoiceType.electrolaringe
            ? 'Electrolaringe'
            : 'Sin definir';

    return WCard(onTap: onTap, child: Row(children: [
      CircleAvatar(
        radius: 18,
        backgroundColor: C.blueBg,
        child: Text(p.initials,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: C.blue)),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(p.displayName,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        Text('$voiceLabel · nivel ${p.currentLevel}',
          style: const TextStyle(fontSize: 11, color: C.txt2)),
      ])),
      if (p.streakDays > 0) ...[
        const Icon(Icons.local_fire_department_rounded, color: C.amber, size: 14),
        const SizedBox(width: 2),
        Text('${p.streakDays}d', style: const TextStyle(fontSize: 11, color: C.amber)),
        const SizedBox(width: 6),
      ],
      const Icon(Icons.chevron_right, size: 16, color: C.txt2),
    ]));
  }
}