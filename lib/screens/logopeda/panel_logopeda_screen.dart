import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/models.dart';

class PanelLogopedaScreen extends StatefulWidget {
  const PanelLogopedaScreen({super.key});

  @override
  State<PanelLogopedaScreen> createState() => _PanelLogopedaScreenState();
}

class _PanelLogopedaScreenState extends State<PanelLogopedaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text('panel logopeda', style: tt.headlineMedium),
            ),
            const SizedBox(height: 12),

            // TabBar al estilo Figma
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TabBar(
                controller: _tab,
                tabs: const [
                  Tab(text: 'Nuevo ejercicio'),
                  Tab(text: 'Pacientes'),
                ],
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textMuted,
                indicatorColor: AppColors.primary,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: AppColors.border,
                labelStyle: const TextStyle(
                  fontFamily: 'Geist', fontSize: 14, fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tab,
                children: const [
                  _NuevoEjercicioTab(),
                  _PacientesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tab: Nuevo ejercicio ──────────────────────────────────────────────────────

class _NuevoEjercicioTab extends StatefulWidget {
  const _NuevoEjercicioTab();

  @override
  State<_NuevoEjercicioTab> createState() => _NuevoEjercicioTabState();
}

class _NuevoEjercicioTabState extends State<_NuevoEjercicioTab> {
  final _palabraCtrl  = TextEditingController();
  final _videoUrlCtrl = TextEditingController();
  final _instrCtrl    = TextEditingController();
  NivelEjercicio _nivel  = NivelEjercicio.bi;
  TipoVoz _perfil         = TipoVoz.esofagica;
  double _umbral          = 0.65;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('PALABRA OBJETIVO', style: tt.labelLarge),
          const SizedBox(height: 8),
          TextField(
            controller: _palabraCtrl,
            style: const TextStyle(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 20),

          // Nivel + Perfil en fila
          Row(children: [
            Expanded(child: _buildNivelDropdown(tt)),
            const SizedBox(width: 12),
            Expanded(child: _buildPerfilDropdown(tt)),
          ]),
          const SizedBox(height: 20),

          Text('UMBRAL DE ÉXITO', style: tt.labelLarge),
          const SizedBox(height: 4),
          _UmbralSlider(
            value: _umbral,
            onChanged: (v) => setState(() => _umbral = v),
          ),
          const SizedBox(height: 20),

          Text('URL VÍDEO GUÍA', style: tt.labelLarge),
          const SizedBox(height: 8),
          TextField(
            controller: _videoUrlCtrl,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(hintText: 'drive.google.com/...'),
          ),
          const SizedBox(height: 20),

          Text('URL VÍDEO GUÍA', style: tt.labelLarge),
          const SizedBox(height: 8),
          TextField(
            controller: _instrCtrl,
            maxLines: 3,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              hintText: 'Instrucciones para el paciente...',
            ),
          ),
          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ejercicio guardado')),
                );
              },
              child: const Text('Guardar ejercicio'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNivelDropdown(TextTheme tt) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('NIVEL', style: tt.labelLarge),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: DropdownButton<NivelEjercicio>(
          value: _nivel,
          isExpanded: true,
          underline: const SizedBox(),
          dropdownColor: AppColors.surface,
          style: const TextStyle(color: AppColors.textPrimary, fontFamily: 'Geist', fontSize: 14),
          items: NivelEjercicio.values.map((n) => DropdownMenuItem(
            value: n,
            child: Text('${n.numero} -- ${n.label}'),
          )).toList(),
          onChanged: (v) => setState(() => _nivel = v!),
        ),
      ),
    ],
  );

  Widget _buildPerfilDropdown(TextTheme tt) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('PERFIL', style: tt.labelLarge),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: DropdownButton<TipoVoz>(
          value: _perfil,
          isExpanded: true,
          underline: const SizedBox(),
          dropdownColor: AppColors.surface,
          style: const TextStyle(color: AppColors.textPrimary, fontFamily: 'Geist', fontSize: 14),
          items: TipoVoz.values.map((t) => DropdownMenuItem(
            value: t,
            child: Text(t.label.split(' ').first),
          )).toList(),
          onChanged: (v) => setState(() => _perfil = v!),
        ),
      ),
    ],
  );
}

class _UmbralSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _UmbralSlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.surfaceLight,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withOpacity(0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: 0.4,
            max: 1.0,
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('40%', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
              Text(
                '${(value * 100).round()}%',
                style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
              ),
              Text('100%', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Tab: Pacientes ────────────────────────────────────────────────────────────

class _PacientesTab extends StatelessWidget {
  const _PacientesTab();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final pacientes = MockData.pacientes;

    // Stats globales
    final allHistorial = pacientes.expand((p) => p.historial).toList();
    final tasaGlobal = allHistorial.isEmpty
        ? 0
        : allHistorial.fold<int>(0, (a, r) => a + r.porcentaje) ~/ allHistorial.length;
    final sesiones = allHistorial.length;
    final palabras = allHistorial.map((r) => r.ejercicioId).toSet().length;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            children: [
              Text('ESTA SEMANA', style: tt.labelLarge),
              const SizedBox(height: 12),
              ...pacientes.map((p) => _PacienteRow(paciente: p)),
            ],
          ),
        ),

        // Stats footer
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Expanded(child: _StatBox(value: '$tasaGlobal%', label: 'tasa\nexito', green: true)),
              const SizedBox(width: 10),
              Expanded(child: _StatBox(value: '$sesiones', label: 'sesiones')),
              const SizedBox(width: 10),
              Expanded(child: _StatBox(value: '$palabras', label: 'palabras')),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                if (MockData.pacientes.isNotEmpty) {
                  context.go('/logopeda/paciente/${MockData.pacientes.first.id}');
                }
              },
              child: const Text('Ver detalle paciente'),
            ),
          ),
        ),
      ],
    );
  }
}

class _PacienteRow extends StatelessWidget {
  final Paciente paciente;

  const _PacienteRow({required this.paciente});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final tasa = paciente.tasaExito.round();
    final sinActividad = paciente.historial.isEmpty;

    Color avatarColor;
    switch (paciente.id) {
      case 'p1': avatarColor = AppColors.primaryMuted; break;
      case 'p2': avatarColor = const Color(0xFF6B7BC4); break;
      default:   avatarColor = const Color(0xFFB8860B);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 22,
                backgroundColor: avatarColor,
                child: Text(
                  paciente.iniciales,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(paciente.nombreCompleto, style: tt.titleMedium),
                    Text(
                      sinActividad
                          ? 'sin actividad esta semana'
                          : '${paciente.historial.length} ejercicios · ${paciente.tipoVoz.label.split(' ').last.toLowerCase()}',
                      style: tt.bodySmall,
                    ),
                  ],
                ),
              ),
              if (!sinActividad) ...[
                SizedBox(
                  width: 80,
                  child: LinearProgressIndicator(
                    value: tasa / 100,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor: AlwaysStoppedAnimation(
                      tasa >= 70 ? AppColors.primary : AppColors.warning,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$tasa%',
                  style: tt.bodyMedium?.copyWith(
                    color: tasa >= 70 ? AppColors.primary : AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ] else
                Text('—', style: tt.bodyMedium),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final bool green;

  const _StatBox({required this.value, required this.label, this.green = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: green ? AppColors.primary : AppColors.textPrimary,
              fontFamily: 'Geist',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
              fontFamily: 'Geist',
            ),
          ),
        ],
      ),
    );
  }
}