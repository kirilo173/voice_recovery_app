// ─────────────────────────────────────────────────────────────────────────────
// logopeda/asignar_ficha_screen.dart
// Pantalla para asignar fichas de un módulo a un paciente concreto.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../../data/static_data.dart';
import '../../../theme/app_theme.dart';
import 'package:voice_rec_app/ui/shared_widgets.dart';

class AsignarFichaScreen extends StatefulWidget {
  final UserModel patient;
  const AsignarFichaScreen({super.key, required this.patient});

  @override
  State<AsignarFichaScreen> createState() => _AsignarFichaScreenState();
}

class _AsignarFichaScreenState extends State<AsignarFichaScreen> {
  // Módulo seleccionado (índice en kLogopedaModulos)
  int _selectedMod = 0;

  // Estado de asignación de cada ficha del módulo (estático)
  // true = ya asignada/marcada, false = sin asignar
  late List<_FichaAssignState> _fichasState;

  // Umbral personalizado para este paciente
  double _threshold = 0.65;

  @override
  void initState() {
    super.initState();
    _buildFichasState();
  }

  void _buildFichasState() {
    // Genera fichas de ejemplo según el módulo seleccionado
    final mod = kLogopedaModulos[_selectedMod];
    _fichasState = _staticFichasForMod(mod.id);
  }

  // Fichas estáticas por módulo (en producción vendrán del repositorio)
  List<_FichaAssignState> _staticFichasForMod(String modId) {
    final Map<String, List<_FichaAssignState>> data = {
      'mod_001': [
        _FichaAssignState('Apertura mandibular',   'vídeo + instrucción',     alreadyAssigned: true),
        _FichaAssignState('Movimientos de lengua', 'vídeo + dinámica',        alreadyAssigned: true),
        _FichaAssignState('Labios — protrusión',   'vídeo + secuencia'),
        _FichaAssignState('Mejillas — inflado',    'vídeo'),
        _FichaAssignState('Velo del paladar',      'instrucción'),
      ],
      'mod_002': [
        _FichaAssignState('Soplo bucal suave',     'vídeo + instrucción',     alreadyAssigned: true),
        _FichaAssignState('Soplo bucal fuerte',    'vídeo + instrucción',     alreadyAssigned: true),
        _FichaAssignState('Soplo dirigido',        'vídeo + secuencia'),
        _FichaAssignState('Soplo fragmentado',     'instrucción'),
        _FichaAssignState('Independencia completa','instrucción'),
      ],
      'mod_003': [
        _FichaAssignState('Vocales aisladas',      'vídeo + secuencia A E I O U', alreadyAssigned: true),
        _FichaAssignState('Diptongos con A',       'secuencia ae ai ao au'),
        _FichaAssignState('Diptongos con E',       'secuencia ea ei eo eu'),
        _FichaAssignState('Diptongos con I',       'secuencia ia ie io iu'),
        _FichaAssignState('Diptongos con O y U',   'secuencia oa oe ua ue'),
      ],
    };
    return data[modId] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F0),
      body: Column(
        children: [
          // Nav
          SafeArea(
            bottom: false,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: AppColors.blue600),
                        const SizedBox(width: 3),
                        Text(
                          widget.patient.name?.split(' ').first ?? 'Paciente',
                          style: const TextStyle(fontSize: 12, color: AppColors.blue600),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: Text('Asignar ficha',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E))),
                  ),
                  const SizedBox(width: 50),
                ],
              ),
            ),
          ),

          // Body
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Elegir módulo ─────────────────────────────────────
                  const SectionLabel('Elegir módulo'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      children: kLogopedaModulos.asMap().entries.map((e) {
                        final i = e.key;
                        final m = e.value;
                        final selected = _selectedMod == i;
                        return GestureDetector(
                          onTap: () => setState(() {
                            _selectedMod = i;
                            _buildFichasState();
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: selected ? m.bgColor : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected ? m.iconColor : const Color(0x26000000),
                                width: selected ? 2 : 0.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                ModuleIcon(
                                  icon: AppIcons.fromName(m.iconName),
                                  bg: m.bgColor,
                                  fg: m.iconColor,
                                  size: 30,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(m.title,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: selected ? m.iconColor : const Color(0xFF1C1C1E))),
                                      Text('${m.fichaCount} fichas',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: selected ? m.iconColor.withOpacity(0.7) : AppColors.gray400)),
                                    ],
                                  ),
                                ),
                                if (selected)
                                  Icon(Icons.check_rounded, size: 16, color: m.iconColor),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // ── Fichas disponibles ────────────────────────────────
                  const SectionLabel('Fichas disponibles'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                    child: Column(
                      children: _fichasState.asMap().entries.map((e) {
                        final f = e.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0x26000000), width: 0.5),
                          ),
                          child: Row(
                            children: [
                              // Checkbox
                              GestureDetector(
                                onTap: f.alreadyAssigned
                                    ? null
                                    : () => setState(() => f.checked = !f.checked),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 120),
                                  width: 18, height: 18,
                                  decoration: BoxDecoration(
                                    color: (f.checked || f.alreadyAssigned) ? AppColors.blue600 : Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: (f.checked || f.alreadyAssigned) ? AppColors.blue600 : AppColors.gray200,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: (f.checked || f.alreadyAssigned)
                                      ? const Icon(Icons.check_rounded, size: 12, color: Colors.white)
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(f.name,
                                        style: const TextStyle(fontSize: 13, color: Color(0xFF1C1C1E))),
                                    Text(f.sub,
                                        style: const TextStyle(fontSize: 11, color: AppColors.gray400)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (f.alreadyAssigned)
                                StatusBadge.active()
                              else
                                StatusBadge.locked(),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // ── Umbral personalizado ──────────────────────────────
                  const SectionLabel('Umbral de éxito para este paciente'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppColors.blue600,
                              inactiveTrackColor: AppColors.gray50,
                              thumbColor: AppColors.blue600,
                              overlayColor: AppColors.blue50,
                            ),
                            child: Slider(
                              min: 0.40,
                              max: 0.95,
                              divisions: 11,
                              value: _threshold,
                              onChanged: (v) => setState(() => _threshold = v),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 42,
                          child: Text(
                            '${(_threshold * 100).round()}%',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E)),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Save button
          Container(
            color: const Color(0xFFF5F4F0),
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
            child: PrimaryButton(
              label: 'Guardar asignación',
              icon: Icons.check_rounded,
              color: AppColors.teal400,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Ficha state helper ────────────────────────────────────────────────────────
class _FichaAssignState {
  final String name;
  final String sub;
  final bool alreadyAssigned;
  bool checked;

  _FichaAssignState(this.name, this.sub, {this.alreadyAssigned = false})
      : checked = alreadyAssigned;
}