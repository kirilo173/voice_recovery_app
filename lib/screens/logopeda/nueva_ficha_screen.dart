import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/models.dart';
import '../../services/logopeda_service.dart';
import '../../widgets/common.dart';

class NuevaFichaScreen extends StatefulWidget {
  const NuevaFichaScreen({super.key});
  @override State<NuevaFichaScreen> createState() => _NuevaFichaScreenState();
}

class _NuevaFichaScreenState extends State<NuevaFichaScreen> {
  final _nameCtrl  = TextEditingController();
  final _instrCtrl = TextEditingController();
  final _wordCtrl  = TextEditingController();

  int    _level     = 1;
  String _voiceType = 'esofagico';
  double _threshold = 0.65;
  List<String> _words = [];
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _instrCtrl.dispose();
    _wordCtrl.dispose();
    super.dispose();
  }

  void _addWord() {
    final w = _wordCtrl.text.trim();
    if (w.isEmpty) return;
    setState(() { _words.add(w); _wordCtrl.clear(); });
  }

  Future<void> _guardar() async {
    if (_nameCtrl.text.trim().isEmpty) {
      setState(() => _error = 'El nombre es obligatorio');
      return;
    }
    if (_words.isEmpty) {
      setState(() => _error = 'Añade al menos una palabra');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final ficha = Ficha(
        id:               '',
        name:             _nameCtrl.text.trim(),
        level:            _level,
        assignmentType:   'personalizada',
        voiceTypeFilter:  _voiceType == 'esofagico'
                            ? VoiceType.esofagico
                            : VoiceType.electrolaringe,
        words:            _words,
        instructions:     _instrCtrl.text.trim().isEmpty ? null : _instrCtrl.text.trim(),
        successThreshold: _threshold,
      );
      await LogopedaService.crearFicha(ficha);
      if (!mounted) return;
      context.go('/logopeda');
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(child: Column(children: [
        AppNav(
          backLabel: 'panel',
          onBack: () => context.go('/logopeda'),
          title: 'Nueva ficha',
        ),

        Expanded(child: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            // Nombre
            _label('Nombre de la ficha'),
            TextField(controller: _nameCtrl,
              decoration: const InputDecoration(hintText: 'ej: Vocales aisladas')),
            const SizedBox(height: 14),

            // Instrucciones
            _label('Instrucciones (opcional)'),
            TextField(
              controller: _instrCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'ej: Suelta el aire desde el esófago y emite la vocal...'),
            ),
            const SizedBox(height: 14),

            // Nivel
            _label('Nivel'),
            _ChipRow<int>(
              options: const [1, 2, 3],
              labels:  const ['Nivel 1', 'Nivel 2', 'Nivel 3'],
              selected: _level,
              onSelect: (v) => setState(() => _level = v),
            ),
            const SizedBox(height: 14),

            // Tipo de voz
            _label('Tipo de voz'),
            _ChipRow<String>(
              options: const ['esofagico', 'electrolaringe', 'todos'],
              labels:  const ['Esofágica', 'Electrolaringe', 'Todos'],
              selected: _voiceType,
              onSelect: (v) => setState(() => _voiceType = v),
            ),
            const SizedBox(height: 14),

            // Umbral de éxito
            _label('Umbral de éxito: ${(_threshold * 100).round()}%'),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor:   C.blue,
                inactiveTrackColor: C.border,
                thumbColor:         C.blue,
                overlayColor:       C.blueBg,
                trackHeight:        3,
              ),
              child: Slider(
                value: _threshold,
                min: 0.4, max: 1.0,
                divisions: 12,
                onChanged: (v) => setState(() => _threshold = v),
              ),
            ),
            const SizedBox(height: 14),

            // Palabras
            _label('Palabras / sílabas'),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _wordCtrl,
                  decoration: const InputDecoration(hintText: 'ej: pan, sol, flor...'),
                  onSubmitted: (_) => _addWord(),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: _addWord,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(44, 44),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(Icons.add_rounded, size: 20),
                ),
              ),
            ]),
            const SizedBox(height: 8),

            // Lista palabras añadidas
            if (_words.isNotEmpty)
              Wrap(
                spacing: 6, runSpacing: 6,
                children: _words.map((w) => Chip(
                  label: Text(w, style: const TextStyle(fontSize: 12)),
                  backgroundColor: C.blueBg,
                  side: const BorderSide(color: C.blueLight, width: 0.5),
                  deleteIcon: const Icon(Icons.close, size: 14, color: C.blue),
                  onDeleted: () => setState(() => _words.remove(w)),
                )).toList(),
              ),

            const SizedBox(height: 8),
            if (_error != null) ErrorBox(_error!),
            const SizedBox(height: 8),
          ],
        )),

        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: BtnP(
            label: 'Guardar ficha',
            color: C.teal,
            icon: Icons.check_rounded,
            loading: _loading,
            onTap: _guardar,
          ),
        ),
      ])),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(text, style: const TextStyle(
      fontSize: 11, color: C.txt2, letterSpacing: 0.4)),
  );
}

class _ChipRow<T> extends StatelessWidget {
  final List<T> options;
  final List<String> labels;
  final T selected;
  final Function(T) onSelect;

  const _ChipRow({
    required this.options, required this.labels,
    required this.selected, required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 6, children: List.generate(options.length, (i) {
      final sel = options[i] == selected;
      return GestureDetector(
        onTap: () => onSelect(options[i]),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: sel ? C.blueBg : C.bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: sel ? C.blueLight : C.border, width: sel ? 1.5 : 0.5),
          ),
          child: Text(labels[i], style: TextStyle(
            fontSize: 12,
            color: sel ? C.blue : C.txt2,
            fontWeight: sel ? FontWeight.w500 : FontWeight.w400,
          )),
        ),
      );
    }));
  }
}