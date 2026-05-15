// ─────────────────────────────────────────────────────────────────────────────
// logopeda/nuevo_modulo_screen.dart
// Pantalla para crear un módulo nuevo o editar uno existente.
// Contiene también la sub-pantalla de nueva ficha (NuevaFichaScreen).
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../../data/static_data.dart';
import '../../../theme/app_theme.dart';
import 'package:voice_rec_app/ui/shared_widgets.dart';

// ═════════════════════════════════════════════════════════════════════════════
// NuevoModuloScreen
// ═════════════════════════════════════════════════════════════════════════════
class NuevoModuloScreen extends StatefulWidget {
  final bool editMode;
  const NuevoModuloScreen({super.key, this.editMode = false});

  @override
  State<NuevoModuloScreen> createState() => _NuevoModuloScreenState();
}

class _NuevoModuloScreenState extends State<NuevoModuloScreen> {
  final _nameCtrl = TextEditingController(text: '');
  final _descCtrl = TextEditingController();

  // Icon selector
  String _selectedIcon = 'mouth';
  static const _icons = [
    ('mouth',          Icons.record_voice_over_outlined),
    ('wind',           Icons.air_outlined),
    ('letter-a',       Icons.text_fields_outlined),
    ('alphabet-latin', Icons.abc_outlined),
    ('message',        Icons.chat_bubble_outline_rounded),
    ('book',           Icons.menu_book_outlined),
  ];

  // Color selector
  int _selectedColor = 0;
  static const _colorPairs = [
    (AppColors.blue50,   AppColors.blue600),
    (AppColors.teal50,   AppColors.teal600),
    (AppColors.purple50, AppColors.purple600),
    (AppColors.coral50,  AppColors.coral600),
    (AppColors.amber50,  AppColors.amber600),
    (Color(0xFFFBEAF0),  Color(0xFF993556)),
  ];

  // Phase tags
  final Set<String> _phases = {'Fase A — iniciación'};
  static const _allPhases = ['Fase A — iniciación', 'Fase B — consolidación', 'Fase C — avanzada'];

  // Voice type tags
  final Set<String> _voiceTypes = {'Esofágica'};
  static const _allVoiceTypes = ['Esofágica', 'Electrolaringe', 'Prótesis', 'Todos'];

  // Fichas list (static preview)
  final List<_FichaPreview> _fichas = [
    _FichaPreview(name: 'Apertura mandibular', sub: 'praxia · vídeo + instrucción'),
    _FichaPreview(name: 'Movimientos de lengua', sub: 'praxia · vídeo + dinámica'),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.editMode) {
      _nameCtrl.text = 'Praxias orofaciales';
      _descCtrl.text = 'Labios, lengua y mandíbula';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  // ── Build ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final bg = _colorPairs[_selectedColor].$1;
    final fg = _colorPairs[_selectedColor].$2;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F0),
      body: Column(
        children: [
          // Nav
          _buildNav(context, fg),
          // Scroll body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre
                  const _FieldLabel('Nombre del módulo'),
                  _AppInput(controller: _nameCtrl, hint: 'ej: Frases sencillas'),
                  const SizedBox(height: 14),

                  // Descripción
                  const _FieldLabel('Descripción breve'),
                  _AppInput(controller: _descCtrl, hint: 'ej: Frases de 4 palabras del día a día'),
                  const SizedBox(height: 14),

                  // Icono
                  const _FieldLabel('Icono'),
                  _buildIconSelector(bg, fg),
                  const SizedBox(height: 14),

                  // Color
                  const _FieldLabel('Color del módulo'),
                  _buildColorSelector(),
                  const SizedBox(height: 14),

                  // Fase
                  const _FieldLabel('Fase del tratamiento'),
                  _buildTagRow(_allPhases, _phases),
                  const SizedBox(height: 14),

                  // Tipo de voz
                  const _FieldLabel('Tipo de voz'),
                  _buildTagRow(_allVoiceTypes, _voiceTypes),
                  const SizedBox(height: 14),

                  const _Divider(),

                  // Fichas
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Fichas del módulo',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E))),
                        if (widget.editMode)
                          GestureDetector(
                            onTap: _openNuevaFicha,
                            child: const Text('+ Añadir',
                                style: TextStyle(fontSize: 12, color: AppColors.blue600)),
                          ),
                      ],
                    ),
                  ),
                  ..._fichas.asMap().entries.map((e) => _FichaRow(
                    preview: e.value,
                    index: e.key,
                    editMode: widget.editMode,
                    onTap: _openNuevaFicha,
                  )),
                  _AddFichaButton(onTap: _openNuevaFicha),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          // Save button
          _buildSaveBar(context),
        ],
      ),
    );
  }

  // ── Nav bar ──────────────────────────────────────────────────────────────────
  Widget _buildNav(BuildContext context, Color fg) {
    return SafeArea(
      bottom: false,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Row(
                children: [
                  Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: AppColors.blue600),
                  SizedBox(width: 3),
                  Text('inicio', style: TextStyle(fontSize: 12, color: AppColors.blue600)),
                ],
              ),
            ),
            Expanded(
              child: Text(
                widget.editMode ? 'Editar módulo' : 'Nuevo módulo',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E)),
              ),
            ),
            if (widget.editMode)
              GestureDetector(
                onTap: () => _showDeleteDialog(context),
                child: const Text('Borrar', style: TextStyle(fontSize: 12, color: AppColors.red400)),
              )
            else
              const SizedBox(width: 40),
          ],
        ),
      ),
    );
  }

  // ── Icon selector ─────────────────────────────────────────────────────────
  Widget _buildIconSelector(Color bg, Color fg) {
    return Wrap(
      spacing: 6,
      children: _icons.map((pair) {
        final isSelected = _selectedIcon == pair.$1;
        return GestureDetector(
          onTap: () => setState(() => _selectedIcon = pair.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: isSelected ? bg : AppColors.gray50,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: isSelected ? fg : const Color(0x26000000),
                width: isSelected ? 2 : 0.5,
              ),
            ),
            child: Icon(pair.$2,
                size: 18, color: isSelected ? fg : AppColors.gray400),
          ),
        );
      }).toList(),
    );
  }

  // ── Color selector ────────────────────────────────────────────────────────
  Widget _buildColorSelector() {
    return Row(
      children: List.generate(_colorPairs.length, (i) {
        final isSelected = _selectedColor == i;
        final fg = _colorPairs[i].$2;
        return GestureDetector(
          onTap: () => setState(() => _selectedColor = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 28, height: 28,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: _colorPairs[i].$1,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? fg : const Color(0x26000000),
                width: isSelected ? 2 : 0.5,
              ),
            ),
          ),
        );
      }),
    );
  }

  // ── Tag row ────────────────────────────────────────────────────────────────
  Widget _buildTagRow(List<String> all, Set<String> selected) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: all.map((tag) {
        final on = selected.contains(tag);
        return GestureDetector(
          onTap: () => setState(() => on ? selected.remove(tag) : selected.add(tag)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: on ? AppColors.blue50 : AppColors.gray50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: on ? AppColors.blue200 : const Color(0x26000000),
                width: 0.5,
              ),
            ),
            child: Text(tag,
                style: TextStyle(
                    fontSize: 11,
                    color: on ? AppColors.blue800 : AppColors.gray400)),
          ),
        );
      }).toList(),
    );
  }

  // ── Save bar ───────────────────────────────────────────────────────────────
  Widget _buildSaveBar(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F4F0),
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
      child: PrimaryButton(
        label: widget.editMode ? 'Guardar cambios' : 'Guardar módulo',
        icon: Icons.check_rounded,
        color: AppColors.teal400,
        onTap: () => Navigator.pop(context),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  void _openNuevaFicha() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const NuevaFichaScreen()));
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Borrar módulo'),
        content: const Text('¿Seguro que quieres borrar este módulo? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Borrar', style: TextStyle(color: AppColors.red400)),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// NuevaFichaScreen
// ═════════════════════════════════════════════════════════════════════════════
class NuevaFichaScreen extends StatefulWidget {
  const NuevaFichaScreen({super.key});

  @override
  State<NuevaFichaScreen> createState() => _NuevaFichaScreenState();
}

class _NuevaFichaScreenState extends State<NuevaFichaScreen> {
  final _titleCtrl   = TextEditingController();
  final _descCtrl    = TextEditingController();
  final _instrCtrl   = TextEditingController();
  final _hintCtrl    = TextEditingController();
  final _newItemCtrl = TextEditingController();

  bool _isSequence = true;   // tipo de contenido
  bool _requiresPrev = true; // requiere ficha anterior
  double _threshold = 0.65;  // umbral de éxito

  // Items a practicar
  final List<String> _items = ['A', 'E', 'I', 'O', 'U'];

  // Archivos adjuntos (estático para demo)
  final List<_AttachFile> _files = [
    _AttachFile(icon: Icons.videocam_outlined, color: AppColors.blue600, name: 'vídeo_vocales.mp4', sub: 'Vídeo guía de la logopeda · 45 seg'),
    _AttachFile(icon: Icons.picture_as_pdf_outlined, color: AppColors.red400, name: 'VOCALES_iniciacion.pdf', sub: 'Ficha imprimible de referencia'),
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _instrCtrl.dispose();
    _hintCtrl.dispose();
    _newItemCtrl.dispose();
    super.dispose();
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
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: AppColors.blue600),
                        SizedBox(width: 3),
                        Text('módulo', style: TextStyle(fontSize: 12, color: AppColors.blue600)),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: Text('Nueva ficha',
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
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Campos básicos ──────────────────────────────────────
                  const _FieldLabel('Título de la ficha'),
                  _AppInput(controller: _titleCtrl, hint: 'ej: Vocales aisladas'),
                  const SizedBox(height: 14),

                  const _FieldLabel('Descripción'),
                  _AppInput(controller: _descCtrl, hint: 'ej: A · E · I · O · U'),
                  const SizedBox(height: 14),

                  const _FieldLabel('Instrucción para el paciente'),
                  _AppInput(controller: _instrCtrl, hint: 'ej: Introduce el aire en el esófago…', maxLines: 3),
                  const SizedBox(height: 14),

                  const _FieldLabel('Consejo (hint)'),
                  _AppInput(controller: _hintCtrl, hint: 'ej: No fuerces. Si no sale, inténtalo de nuevo.'),
                  const SizedBox(height: 14),

                  const _Divider(),

                  // ── Recursos adjuntos ───────────────────────────────────
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('Recursos adjuntos',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E))),
                  ),
                  ..._files.asMap().entries.map((e) => _FileRow(
                    file: e.value,
                    onRemove: () => setState(() => _files.removeAt(e.key)),
                  )),
                  Row(
                    children: [
                      Expanded(child: _AddAttachButton(icon: Icons.videocam_outlined, label: 'Vídeo', onTap: () {})),
                      const SizedBox(width: 6),
                      Expanded(child: _AddAttachButton(icon: Icons.picture_as_pdf_outlined, label: 'PDF', onTap: () {})),
                    ],
                  ),

                  const _Divider(),

                  // ── Contenido dinámico ──────────────────────────────────
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 4),
                    child: Text('Contenido dinámico',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E))),
                  ),
                  const Text(
                    'El paciente practica elemento a elemento con grabación y análisis de voz.',
                    style: TextStyle(fontSize: 11, color: AppColors.gray400),
                  ),
                  const SizedBox(height: 12),

                  // Tipo de contenido
                  const _FieldLabel('Tipo de contenido'),
                  _TipoSelector(isSequence: _isSequence, onChanged: (v) => setState(() => _isSequence = v)),
                  const SizedBox(height: 14),

                  // Items (solo si es secuencia)
                  if (_isSequence) ...[
                    const _FieldLabel('Elementos a practicar'),
                    _ItemsEditor(
                      items: _items,
                      controller: _newItemCtrl,
                      onAdd: () {
                        final val = _newItemCtrl.text.trim();
                        if (val.isEmpty) return;
                        setState(() { _items.add(val); _newItemCtrl.clear(); });
                      },
                      onRemove: (i) => setState(() => _items.removeAt(i)),
                    ),
                    const SizedBox(height: 14),

                    // Umbral de éxito
                    const _FieldLabel('Umbral de éxito'),
                    _ThresholdSlider(
                      value: _threshold,
                      onChanged: (v) => setState(() => _threshold = v),
                    ),
                    const SizedBox(height: 14),
                  ],

                  const _Divider(),

                  // ── Orden y desbloqueo ──────────────────────────────────
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('Orden y desbloqueo',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E))),
                  ),
                  _LockToggleRow(
                    value: _requiresPrev,
                    onChanged: (v) => setState(() => _requiresPrev = v),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          // Buttons
          Container(
            color: const Color(0xFFF5F4F0),
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
            child: Column(
              children: [
                PrimaryButton(
                  label: 'Guardar ficha',
                  icon: Icons.check_rounded,
                  color: AppColors.teal400,
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 7),
                SecondaryButton(label: 'Cancelar', onTap: () => Navigator.pop(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(text, style: const TextStyle(fontSize: 11, color: AppColors.gray400, letterSpacing: 0.4)),
  );
}

class _AppInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  const _AppInput({required this.controller, required this.hint, this.maxLines = 1});

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    maxLines: maxLines,
    style: const TextStyle(fontSize: 13, color: Color(0xFF1C1C1E)),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: AppColors.gray400),
    ),
  );
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Divider(height: 0.5, thickness: 0.5, color: Color(0x26000000)),
  );
}

class _FichaPreview {
  final String name;
  final String sub;
  _FichaPreview({required this.name, required this.sub});
}

class _FichaRow extends StatelessWidget {
  final _FichaPreview preview;
  final int index;
  final bool editMode;
  final VoidCallback onTap;
  const _FichaRow({required this.preview, required this.index, required this.editMode, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Step indicator
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index < 3 ? AppColors.blue50 : AppColors.gray50,
              border: Border.all(color: const Color(0x26000000), width: 0.5),
            ),
            alignment: Alignment.center,
            child: Text('${index + 1}',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: index < 3 ? AppColors.blue600 : AppColors.gray400)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(preview.name, style: const TextStyle(fontSize: 13, color: Color(0xFF1C1C1E))),
                Text(preview.sub, style: const TextStyle(fontSize: 11, color: AppColors.gray400)),
              ],
            ),
          ),
          Icon(editMode ? Icons.edit_outlined : Icons.chevron_right_rounded,
              size: 16, color: AppColors.gray400),
        ],
      ),
    ),
  );
}

class _AddFichaButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddFichaButton({required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gray200, width: 0.5, style: BorderStyle.solid),
      ),
      child: const Row(
        children: [
          Icon(Icons.add, size: 16, color: AppColors.gray400),
          SizedBox(width: 8),
          Text('Añadir nueva ficha', style: TextStyle(fontSize: 12, color: AppColors.gray400)),
        ],
      ),
    ),
  );
}

class _AttachFile {
  final IconData icon;
  final Color color;
  final String name;
  final String sub;
  const _AttachFile({required this.icon, required this.color, required this.name, required this.sub});
}

class _FileRow extends StatelessWidget {
  final _AttachFile file;
  final VoidCallback onRemove;
  const _FileRow({required this.file, required this.onRemove});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: AppColors.gray50,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Icon(file.icon, size: 18, color: file.color),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(file.name, style: const TextStyle(fontSize: 12, color: Color(0xFF1C1C1E))),
              Text(file.sub, style: const TextStyle(fontSize: 11, color: AppColors.gray400)),
            ],
          ),
        ),
        GestureDetector(
          onTap: onRemove,
          child: const Icon(Icons.close_rounded, size: 14, color: AppColors.gray400),
        ),
      ],
    ),
  );
}

class _AddAttachButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _AddAttachButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gray200, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: AppColors.gray400),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.gray400)),
        ],
      ),
    ),
  );
}

class _TipoSelector extends StatelessWidget {
  final bool isSequence;
  final ValueChanged<bool> onChanged;
  const _TipoSelector({required this.isSequence, required this.onChanged});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _TipoOption(
        selected: isSequence,
        title: 'Secuencia de elementos',
        subtitle: 'El paciente graba cada elemento por separado (vocales, sílabas, palabras…)',
        onTap: () => onChanged(true),
      ),
      const SizedBox(height: 6),
      _TipoOption(
        selected: !isSequence,
        title: 'Elemento único',
        subtitle: 'El paciente graba una sola palabra o frase completa',
        onTap: () => onChanged(false),
      ),
    ],
  );
}

class _TipoOption extends StatelessWidget {
  final bool selected;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _TipoOption({required this.selected, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected ? AppColors.blue50 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected ? AppColors.blue400 : const Color(0x26000000),
          width: selected ? 2 : 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
              color: selected ? AppColors.blue800 : const Color(0xFF1C1C1E))),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(fontSize: 11,
              color: selected ? AppColors.blue600 : AppColors.gray400)),
        ],
      ),
    ),
  );
}

class _ItemsEditor extends StatelessWidget {
  final List<String> items;
  final TextEditingController controller;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  const _ItemsEditor({
    required this.items,
    required this.controller,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Chips
      Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          ...items.asMap().entries.map((e) => _ItemChip(
            label: e.value,
            onRemove: () => onRemove(e.key),
          )),
        ],
      ),
      const SizedBox(height: 8),
      // Add new item
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 13),
              decoration: const InputDecoration(hintText: 'Añadir elemento…', hintStyle: TextStyle(fontSize: 13, color: AppColors.gray400)),
              onSubmitted: (_) => onAdd(),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.blue600,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('+', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w300)),
            ),
          ),
        ],
      ),
    ],
  );
}

class _ItemChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _ItemChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.blue50,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: AppColors.blue200, width: 0.5),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.blue800, fontWeight: FontWeight.w500)),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onRemove,
          child: const Icon(Icons.close_rounded, size: 12, color: AppColors.blue600),
        ),
      ],
    ),
  );
}

class _ThresholdSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  const _ThresholdSlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => Row(
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
            value: value,
            onChanged: onChanged,
          ),
        ),
      ),
      const SizedBox(width: 8),
      SizedBox(
        width: 42,
        child: Text(
          '${(value * 100).round()}%',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E)),
          textAlign: TextAlign.right,
        ),
      ),
    ],
  );
}

class _LockToggleRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _LockToggleRow({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Color(0x26000000), width: 0.5)),
    ),
    child: Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Requiere ficha anterior', style: TextStyle(fontSize: 13, color: Color(0xFF1C1C1E))),
              Text('Bloqueada hasta completar la anterior',
                  style: TextStyle(fontSize: 11, color: AppColors.gray400)),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40, height: 22,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: value ? AppColors.teal400 : AppColors.gray200,
              borderRadius: BorderRadius.circular(11),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 18, height: 18,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}