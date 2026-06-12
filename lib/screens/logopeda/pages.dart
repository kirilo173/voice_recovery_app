import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/models.dart';
import '../../core/mock_data.dart';
import '../../widgets/common.dart';

// ══════════════════════════════════════════════════════════════════════════════
//  HOME LOGOPEDA
// ══════════════════════════════════════════════════════════════════════════════

class LogopedaHomePage extends StatelessWidget {
  const LogopedaHomePage({super.key});

  void _mostrarCodigo(BuildContext ctx) {
    showDialog(
      context: ctx,
      barrierDismissible: true,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Código de vinculación'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Comparte este código con tu paciente:',
            style: TextStyle(fontSize: 13, color: C.txt2)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: C.blueBg, borderRadius: BorderRadius.circular(12)),
            child: const Text('RTV-1234', style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.w700,
              color: C.blue, letterSpacing: 6)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Código de prueba — conecta el backend para generar códigos reales',
            style: TextStyle(fontSize: 11, color: C.txt3),
            textAlign: TextAlign.center),
        ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Cerrar')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stats    = MockData.stats;
    final pacientes = MockData.pacientes;
    final tasaExito = '${((stats['tasa_exito'] as num) * 100).round()}%';

    return _LogopedaScaffold(
      title: 'Panel · ${MockData.logopeda.displayName}',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: StatBox(value: '${pacientes.length}', label: 'pacientes')),
          const SizedBox(width: 12),
          Expanded(child: StatBox(value: '${stats['sesiones']}', label: 'sesiones')),
          const SizedBox(width: 12),
          Expanded(child: StatBox(value: tasaExito, label: 'tasa éxito', valueColor: C.teal)),
        ]),
        const SizedBox(height: 24),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const SLbl('Pacientes recientes'),
          TextButton(
            onPressed: () => context.go('/logopeda/pacientes'),
            child: const Text('Ver todos', style: TextStyle(fontSize: 12))),
        ]),
        ...pacientes.map((p) => _PacienteRow(p: p,
          onTap: () => context.go('/logopeda/paciente/${p.id}'))),

        const SizedBox(height: 8),
        const SLbl('Acciones'),
        Row(children: [
          Expanded(child: BtnP(
            label: 'Nueva ficha', icon: Icons.add_rounded,
            onTap: () => context.go('/logopeda/nueva-ficha'),
          )),
          const SizedBox(width: 8),
          Expanded(child: BtnS(
            label: 'Generar código vinculación',
            onTap: () => _mostrarCodigo(context),
          )),
        ]),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  FICHAS
// ══════════════════════════════════════════════════════════════════════════════

class LogopedaFichasPage extends StatelessWidget {
  const LogopedaFichasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fichas = MockData.fichas;
    return _LogopedaScaffold(
      title: 'Mis fichas',
      action: BtnP(
        label: 'Nueva ficha', icon: Icons.add_rounded, fullWidth: false,
        onTap: () => context.go('/logopeda/nueva-ficha'),
      ),
      child: Column(children: fichas.map((f) => WCard(child: Row(children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(color: C.blueBg, borderRadius: BorderRadius.circular(9)),
          child: const Icon(Icons.description_outlined, color: C.blue, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(f.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          Text('${f.words.length} palabras · nivel ${f.level} · ${(f.successThreshold*100).round()}% umbral',
            style: const TextStyle(fontSize: 11, color: C.txt2)),
          if (f.words.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(f.words.take(5).join(' · '),
              style: const TextStyle(fontSize: 11, color: C.txt2)),
          ],
        ])),
        Bdg.blue('nivel ${f.level}'),
      ]))).toList()),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  PACIENTES
// ══════════════════════════════════════════════════════════════════════════════

class LogopedaPacientesPage extends StatelessWidget {
  const LogopedaPacientesPage({super.key});

  @override
  Widget build(BuildContext context) => _LogopedaScaffold(
    title: 'Mis pacientes',
    child: Column(children: MockData.pacientes.map((p) => _PacienteRow(
      p: p, onTap: () => context.go('/logopeda/paciente/${p.id}'))).toList()),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
//  DETALLE PACIENTE
// ══════════════════════════════════════════════════════════════════════════════

class LogopedaPacienteDetallePage extends StatelessWidget {
  final String pacienteId;
  const LogopedaPacienteDetallePage({super.key, required this.pacienteId});

  @override
  Widget build(BuildContext context) {
    final paciente = MockData.pacientes.firstWhere((p) => p.id == pacienteId);
    final fichas   = MockData.userFichas.where((uf) => uf.userId == pacienteId).toList();
    final intentos = MockData.intentos.where((a) => a.userId == pacienteId).toList();
    final tasa = intentos.isEmpty ? 0.0
      : intentos.where((a) => a.passed == true).length / intentos.length;

    return _LogopedaScaffold(
      title: paciente.displayName,
      subtitle: paciente.email,
      backRoute: '/logopeda/pacientes',
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: StatBox(
              value: '${(tasa * 100).round()}%', label: 'tasa éxito', valueColor: C.teal)),
            const SizedBox(width: 12),
            Expanded(child: StatBox(value: '${intentos.length}', label: 'intentos')),
            const SizedBox(width: 12),
            Expanded(child: StatBox(value: '${fichas.length}', label: 'fichas')),
          ]),
          const SizedBox(height: 20),
          const SLbl('Fichas asignadas'),
          ...fichas.map((uf) => WCard(child: Row(children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: uf.isCompleted ? C.tealBg : C.blueBg,
                borderRadius: BorderRadius.circular(8)),
              child: Icon(
                uf.isCompleted ? Icons.check_circle_outline_rounded : Icons.description_outlined,
                color: uf.isCompleted ? C.tealDark : C.blue, size: 15),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(uf.ficha?.name ?? uf.fichaId,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              Text('${uf.ficha?.words.length ?? 0} palabras',
                style: const TextStyle(fontSize: 11, color: C.txt2)),
            ])),
            if (uf.bestScore != null) Bdg.green('${(uf.bestScore! * 100).round()}%'),
            if (uf.isCompleted) ...[const SizedBox(width: 6), Bdg.green('hecho')],
          ]))),
          if (fichas.isEmpty)
            const Text('Sin fichas asignadas',
              style: TextStyle(fontSize: 12, color: C.txt2)),
        ])),
        const SizedBox(width: 20),
        Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SLbl('Últimos intentos'),
          ...intentos.take(8).map((a) {
            final color = a.scorePercent >= 70 ? C.teal : C.amber;
            return WCard(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(children: [
                Expanded(child: Text(a.wordAttempted ?? '—',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
                Row(children: List.generate(3, (i) => Icon(
                  Icons.star_rounded, size: 11,
                  color: i < a.stars ? C.amber : C.border))),
                const SizedBox(width: 8),
                Text('${a.scorePercent}%', style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: color)),
              ]));
          }),
          if (intentos.isEmpty)
            const Text('Sin actividad registrada',
              style: TextStyle(fontSize: 12, color: C.txt2)),
          const SizedBox(height: 16),
          BtnP(
            label: 'Asignar nueva ficha', icon: Icons.add_rounded,
            onTap: () => context.go('/logopeda/asignar/$pacienteId'),
          ),
        ])),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  NUEVA FICHA
// ══════════════════════════════════════════════════════════════════════════════

class LogopedaNuevaFichaPage extends StatefulWidget {
  const LogopedaNuevaFichaPage({super.key});
  @override State<LogopedaNuevaFichaPage> createState() => _LogopedaNuevaFichaPageState();
}

class _LogopedaNuevaFichaPageState extends State<LogopedaNuevaFichaPage> {
  final _nameCtrl  = TextEditingController();
  final _instrCtrl = TextEditingController();
  final _wordCtrl  = TextEditingController();
  int    _level     = 1;
  String _voiceType = 'esofagico';
  double _threshold = 0.65;
  List<String> _words = [];
  String? _error;

  @override void dispose() { _nameCtrl.dispose(); _instrCtrl.dispose(); _wordCtrl.dispose(); super.dispose(); }

  void _addWord() {
    final w = _wordCtrl.text.trim();
    if (w.isEmpty) return;
    setState(() { _words.add(w); _wordCtrl.clear(); });
  }

  void _guardar() {
    if (_nameCtrl.text.trim().isEmpty) { setState(() => _error = 'El nombre es obligatorio'); return; }
    if (_words.isEmpty) { setState(() => _error = 'Añade al menos una palabra'); return; }
    // Mock: simplemente volvemos con un snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ficha guardada (mock) — conecta el backend para persistir')));
    context.go('/logopeda/fichas');
  }

  @override
  Widget build(BuildContext context) {
    return _LogopedaScaffold(
      title: 'Nueva ficha', backRoute: '/logopeda/fichas',
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _lbl('Nombre'),
          TextField(controller: _nameCtrl,
            decoration: const InputDecoration(hintText: 'ej: Vocales aisladas')),
          const SizedBox(height: 14),
          _lbl('Instrucciones (opcional)'),
          TextField(controller: _instrCtrl, maxLines: 3,
            decoration: const InputDecoration(hintText: 'ej: Suelta el aire desde el esófago...')),
          const SizedBox(height: 14),
          _lbl('Nivel'),
          _Chips<int>(
            options: const [1,2,3], labels: const ['Nivel 1','Nivel 2','Nivel 3'],
            selected: _level, onSelect: (v) => setState(() => _level = v)),
          const SizedBox(height: 14),
          _lbl('Tipo de voz'),
          _Chips<String>(
            options: const ['esofagico','electrolaringe','todos'],
            labels: const ['Esofágica','Electrolaringe','Todos'],
            selected: _voiceType, onSelect: (v) => setState(() => _voiceType = v)),
          const SizedBox(height: 14),
          _lbl('Umbral de éxito: ${(_threshold * 100).round()}%'),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: C.blue, inactiveTrackColor: C.border,
              thumbColor: C.blue, trackHeight: 3),
            child: Slider(value: _threshold, min: 0.4, max: 1.0, divisions: 12,
              onChanged: (v) => setState(() => _threshold = v))),
          if (_error != null) ErrorBox(_error!),
          const SizedBox(height: 16),
          BtnP(label: 'Guardar ficha', color: C.teal,
            icon: Icons.check_rounded, onTap: _guardar),
        ])),
        const SizedBox(width: 24),
        Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _lbl('Palabras / sílabas'),
          Row(children: [
            Expanded(child: TextField(
              controller: _wordCtrl,
              decoration: const InputDecoration(hintText: 'ej: pan'),
              onSubmitted: (_) => _addWord(),
            )),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addWord,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(40,40), padding: EdgeInsets.zero),
              child: const Icon(Icons.add_rounded, size: 18)),
          ]),
          const SizedBox(height: 10),
          if (_words.isEmpty)
            const Text('Añade al menos una palabra',
              style: TextStyle(fontSize: 12, color: C.txt3))
          else
            Wrap(spacing: 6, runSpacing: 6, children: _words.map((w) => Chip(
              label: Text(w, style: const TextStyle(fontSize: 12)),
              backgroundColor: C.blueBg,
              side: const BorderSide(color: C.blueLight, width: 0.5),
              deleteIcon: const Icon(Icons.close, size: 14, color: C.blue),
              onDeleted: () => setState(() => _words.remove(w)),
            )).toList()),
        ])),
      ]),
    );
  }

  Widget _lbl(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(t, style: const TextStyle(fontSize: 11, color: C.txt2, letterSpacing: 0.3)));
}

// ══════════════════════════════════════════════════════════════════════════════
//  ASIGNAR FICHA
// ══════════════════════════════════════════════════════════════════════════════

class LogopedaAsignarFichaPage extends StatefulWidget {
  final String pacienteId;
  const LogopedaAsignarFichaPage({super.key, required this.pacienteId});
  @override State<LogopedaAsignarFichaPage> createState() => _LogopedaAsignarFichaPageState();
}

class _LogopedaAsignarFichaPageState extends State<LogopedaAsignarFichaPage> {
  String?  _selId;
  double   _threshold = 0.65;
  String?  _error;

  @override
  Widget build(BuildContext context) {
    final fichas   = MockData.fichas;
    final paciente = MockData.pacientes.firstWhere((p) => p.id == widget.pacienteId);

    return _LogopedaScaffold(
      title: 'Asignar ficha',
      subtitle: 'Para ${paciente.displayName}',
      backRoute: '/logopeda/paciente/${widget.pacienteId}',
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SLbl('Selecciona una ficha'),
          ...fichas.map((f) {
            final sel = _selId == f.id;
            return GestureDetector(
              onTap: () => setState(() => _selId = f.id),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: sel ? C.blueBg : C.surface,
                  borderRadius: BorderRadius.circular(R.card),
                  border: Border.all(color: sel ? C.blueLight : C.border,
                    width: sel ? 1.5 : 0.5)),
                child: Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(f.name, style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500,
                      color: sel ? C.blue : C.txt)),
                    Text('${f.words.length} palabras · nivel ${f.level}',
                      style: const TextStyle(fontSize: 11, color: C.txt2)),
                    if (f.words.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(f.words.take(4).join(' · '),
                        style: const TextStyle(fontSize: 11, color: C.txt2)),
                    ],
                  ])),
                  if (sel) const Icon(Icons.check_circle_rounded, color: C.blue, size: 20),
                ]),
              ),
            );
          }),
        ])),
        const SizedBox(width: 20),
        Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (_selId != null) ...[
            WCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Umbral de éxito',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text('${(_threshold * 100).round()}% mínimo para superar',
                style: const TextStyle(fontSize: 12, color: C.txt2)),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: C.blue, inactiveTrackColor: C.border,
                  thumbColor: C.blue, trackHeight: 3),
                child: Slider(value: _threshold, min: 0.4, max: 1.0, divisions: 12,
                  onChanged: (v) => setState(() => _threshold = v))),
            ])),
            const SizedBox(height: 12),
          ],
          if (_error != null) ...[ErrorBox(_error!), const SizedBox(height: 10)],
          BtnP(
            label: 'Asignar ficha',
            onTap: _selId == null ? null : () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ficha asignada (mock) — conecta el backend para persistir')));
              context.go('/logopeda/paciente/${widget.pacienteId}');
            },
          ),
        ])),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  Widgets compartidos
// ══════════════════════════════════════════════════════════════════════════════

class _PacienteRow extends StatelessWidget {
  final AppUser p;
  final VoidCallback? onTap;
  const _PacienteRow({required this.p, this.onTap});

  @override
  Widget build(BuildContext context) {
    final voiceLabel = p.voiceType == VoiceType.esofagico ? 'Esofágica'
      : p.voiceType == VoiceType.electrolaringe ? 'Electrolaringe' : 'Sin definir';
    return WCard(onTap: onTap, child: Row(children: [
      CircleAvatar(radius: 18, backgroundColor: C.blueBg,
        child: Text(p.initials,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: C.blue))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(p.displayName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        Text('$voiceLabel · nivel ${p.currentLevel}',
          style: const TextStyle(fontSize: 11, color: C.txt2)),
      ])),
      if (p.streakDays > 0) ...[
        const Icon(Icons.local_fire_department_rounded, color: C.amber, size: 14),
        const SizedBox(width: 2),
        Text('${p.streakDays}d', style: const TextStyle(fontSize: 11, color: C.amber)),
        const SizedBox(width: 8),
      ],
      const Icon(Icons.chevron_right, size: 16, color: C.txt2),
    ]));
  }
}

class _Chips<T> extends StatelessWidget {
  final List<T> options;
  final List<String> labels;
  final T selected;
  final Function(T) onSelect;
  const _Chips({required this.options, required this.labels, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) => Wrap(spacing: 6, children: List.generate(options.length, (i) {
    final sel = options[i] == selected;
    return GestureDetector(
      onTap: () => onSelect(options[i]),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: sel ? C.blueBg : C.bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: sel ? C.blueLight : C.border, width: sel ? 1.5 : 0.5)),
        child: Text(labels[i], style: TextStyle(
          fontSize: 12, color: sel ? C.blue : C.txt2,
          fontWeight: sel ? FontWeight.w500 : FontWeight.w400)),
      ),
    );
  }));
}

class _LogopedaScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? child;
  final Widget? action;
  final String? backRoute;

  const _LogopedaScaffold({
    required this.title, this.subtitle, this.child,
    this.action, this.backRoute,
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
            if (action != null) action!,
          ]),
        ),
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: child ?? const SizedBox())),
      ]),
    );
  }
}
