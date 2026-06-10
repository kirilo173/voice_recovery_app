import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/models.dart';
import '../../services/logopeda_service.dart';
import '../../widgets/common.dart';

class AsignarFichaScreen extends StatefulWidget {
  final String pacienteId;
  const AsignarFichaScreen({super.key, required this.pacienteId});
  @override State<AsignarFichaScreen> createState() => _AsignarFichaScreenState();
}

class _AsignarFichaScreenState extends State<AsignarFichaScreen> {
  List<Ficha> _fichas    = [];
  AppUser?    _paciente;
  String?     _selectedId;
  double      _threshold = 0.65;
  bool _loadingData = true;
  bool _saving      = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final fichas    = await LogopedaService.getMisFichas();
      final pacientes = await LogopedaService.getMisPacientes();
      final paciente  = pacientes.firstWhere((p) => p.id == widget.pacienteId);
      if (!mounted) return;
      setState(() { _fichas = fichas; _paciente = paciente; _loadingData = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString(); _loadingData = false; });
    }
  }

  Future<void> _asignar() async {
    if (_selectedId == null) {
      setState(() => _error = 'Selecciona una ficha');
      return;
    }
    setState(() { _saving = true; _error = null; });
    try {
      await LogopedaService.asignarFicha(
        userId:   widget.pacienteId,
        fichaId:  _selectedId!,
        umbral:   _threshold,
      );
      if (!mounted) return;
      context.go('/logopeda/paciente/${widget.pacienteId}');
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString(); _saving = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(child: Column(children: [
        AppNav(
          backLabel: _paciente?.displayName ?? 'paciente',
          onBack: () => context.go('/logopeda/paciente/${widget.pacienteId}'),
          title: 'Asignar ficha',
        ),

        Expanded(child: _loadingData
          ? const Center(child: CircularProgressIndicator(color: C.blue))
          : _error != null && _fichas.isEmpty
              ? Center(child: ErrorBox(_error!))
              : ListView(padding: const EdgeInsets.all(14), children: [
                  // Info paciente
                  if (_paciente != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: C.blueBg,
                        borderRadius: BorderRadius.circular(R.card),
                      ),
                      child: Row(children: [
                        CircleAvatar(
                          radius: 16, backgroundColor: C.blue,
                          child: Text(_paciente!.initials,
                            style: const TextStyle(fontSize: 11, color: Colors.white)),
                        ),
                        const SizedBox(width: 10),
                        Text('Asignando a ${_paciente!.displayName}',
                          style: const TextStyle(fontSize: 13, color: C.blueDark)),
                      ]),
                    ),

                  // Lista fichas
                  const Text('SELECCIONA UNA FICHA',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500,
                      color: C.txt2, letterSpacing: 0.6)),
                  const SizedBox(height: 8),

                  if (_fichas.isEmpty)
                    Column(children: [
                      const Text('No tienes fichas creadas.',
                        style: TextStyle(fontSize: 13, color: C.txt2)),
                      const SizedBox(height: 10),
                      BtnP(
                        label: 'Crear primera ficha',
                        icon: Icons.add_rounded,
                        onTap: () => context.go('/logopeda/nueva-ficha'),
                      ),
                    ])
                  else
                    ..._fichas.map((f) {
                      final sel = _selectedId == f.id;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedId = f.id),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: sel ? C.blueBg : C.surface,
                            borderRadius: BorderRadius.circular(R.card),
                            border: Border.all(
                              color: sel ? C.blueLight : C.border,
                              width: sel ? 1.5 : 0.5,
                            ),
                          ),
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
                            if (sel)
                              const Icon(Icons.check_circle_rounded, color: C.blue, size: 20),
                          ]),
                        ),
                      );
                    }),

                  // Umbral personalizado
                  if (_selectedId != null) ...[
                    const SizedBox(height: 16),
                    Text('Umbral de éxito: ${(_threshold * 100).round()}%',
                      style: const TextStyle(fontSize: 11, color: C.txt2, letterSpacing: 0.4)),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor:   C.blue,
                        inactiveTrackColor: C.border,
                        thumbColor:         C.blue,
                        trackHeight:        3,
                      ),
                      child: Slider(
                        value: _threshold,
                        min: 0.4, max: 1.0, divisions: 12,
                        onChanged: (v) => setState(() => _threshold = v),
                      ),
                    ),
                  ],

                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    ErrorBox(_error!),
                  ],
                ])),

        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: BtnP(
            label: 'Asignar ficha',
            loading: _saving,
            onTap: _selectedId != null ? _asignar : null,
          ),
        ),
      ])),
    );
  }
}