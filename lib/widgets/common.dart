import 'package:flutter/material.dart';
import '../core/theme.dart';

// ── NavBar ────────────────────────────────────────────────────────────────────

class AppNav extends StatelessWidget implements PreferredSizeWidget {
  final String? backLabel;
  final VoidCallback? onBack;
  final String title;
  final Widget? trailing;

  const AppNav({super.key, this.backLabel, this.onBack, required this.title, this.trailing});

  @override Size get preferredSize => const Size.fromHeight(44);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: C.surface,
        border: Border(bottom: BorderSide(color: C.border, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(children: [
        if (backLabel != null)
          GestureDetector(
            onTap: onBack ?? () => Navigator.of(context).pop(),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.chevron_left, color: C.blue, size: 20),
              Text(backLabel!, style: const TextStyle(fontSize: 12, color: C.blue)),
            ]),
          )
        else
          const SizedBox(width: 60),
        Expanded(child: Text(title, textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: C.txt))),
        if (trailing != null) trailing! else const SizedBox(width: 60),
      ]),
    );
  }
}

// ── Hero azul ─────────────────────────────────────────────────────────────────

class HeroBlue extends StatelessWidget {
  final String label;
  final String title;
  final Widget? bottom;
  final Color color;

  const HeroBlue({
    super.key, required this.label, required this.title,
    this.bottom, this.color = C.heroBlue,
  });

  @override
  Widget build(BuildContext context) => Container(
    color: color,
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 10, color: Color(0xB3FFFFFF))),
      const SizedBox(height: 2),
      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
      if (bottom != null) ...[const SizedBox(height: 10), bottom!],
    ]),
  );
}

// ── Card ──────────────────────────────────────────────────────────────────────

class WCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets margin;
  final EdgeInsets padding;

  const WCard({
    super.key, required this.child, this.onTap,
    this.margin = const EdgeInsets.fromLTRB(14, 0, 14, 8),
    this.padding = const EdgeInsets.all(13),
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.circular(R.card),
        border: Border.all(color: C.border, width: 0.5),
      ),
      child: child,
    ),
  );
}

// ── SectionLabel ─────────────────────────────────────────────────────────────

class SLbl extends StatelessWidget {
  final String text;
  const SLbl(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
    child: Text(text.toUpperCase(),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500,
            color: C.txt2, letterSpacing: 0.6)),
  );
}

// ── Botones ───────────────────────────────────────────────────────────────────

class BtnP extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final IconData? icon;
  final bool loading;

  const BtnP({super.key, required this.label, this.onTap, this.color, this.icon, this.loading = false});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity, height: 48,
    child: ElevatedButton(
      onPressed: loading ? null : onTap,
      style: ElevatedButton.styleFrom(backgroundColor: color ?? C.blue),
      child: loading
          ? const SizedBox(width: 18, height: 18,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (icon != null) ...[Icon(icon, size: 15), const SizedBox(width: 6)],
        Text(label),
      ]),
    ),
  );
}

class BtnS extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const BtnS({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity, height: 44,
    child: OutlinedButton(onPressed: onTap, child: Text(label)),
  );
}

// ── TabBar paciente ───────────────────────────────────────────────────────────

class PatientTabBar extends StatelessWidget {
  final int current;
  final Function(int) onTap;
  const PatientTabBar({super.key, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) => _TabBarBase(
    current: current, onTap: onTap,
    tabs: const [
      (Icons.home_outlined,     'Inicio'),
      (Icons.bar_chart_rounded, 'Progreso'),
      (Icons.person_outline,    'Perfil'),
    ],
  );
}

// ── TabBar logopeda ───────────────────────────────────────────────────────────

class LogopedaTabBar extends StatelessWidget {
  final int current;
  final Function(int) onTap;
  const LogopedaTabBar({super.key, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) => _TabBarBase(
    current: current, onTap: onTap,
    tabs: const [
      (Icons.home_outlined,    'Inicio'),
      (Icons.layers_outlined,  'Fichas'),
      (Icons.people_outline,   'Pacientes'),
    ],
  );
}

class _TabBarBase extends StatelessWidget {
  final int current;
  final Function(int) onTap;
  final List<(IconData, String)> tabs;
  const _TabBarBase({required this.current, required this.onTap, required this.tabs});

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: C.surface,
      border: Border(top: BorderSide(color: C.border, width: 0.5)),
    ),
    padding: const EdgeInsets.only(top: 6, bottom: 8),
    child: Row(children: tabs.asMap().entries.map((e) {
      final active = e.key == current;
      final color  = active ? C.blue : C.txt2;
      final (icon, label) = e.value;
      return Expanded(child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(e.key),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 9, color: color)),
        ]),
      ));
    }).toList()),
  );
}

// ── Badge ─────────────────────────────────────────────────────────────────────

class Bdg extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const Bdg({super.key, required this.label, required this.bg, required this.fg});
  factory Bdg.green(String l) => Bdg(label: l, bg: C.tealBg,  fg: C.tealDark);
  factory Bdg.amber(String l) => Bdg(label: l, bg: C.amberBg, fg: C.amberTxt);
  factory Bdg.gray(String l)  => Bdg(label: l, bg: C.bg,      fg: C.txt2);
  factory Bdg.blue(String l)  => Bdg(label: l, bg: C.blueBg,  fg: C.blueDark);
  factory Bdg.red(String l)   => Bdg(label: l, bg: C.redBg,   fg: C.red);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
    child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: fg)),
  );
}

// ── Waveform ──────────────────────────────────────────────────────────────────

class Waveform extends StatelessWidget {
  final bool active;
  final List<double> heights;
  const Waveform({super.key, required this.active, required this.heights});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 32,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: heights.map((h) => Container(
        width: 4, height: h,
        margin: const EdgeInsets.symmetric(horizontal: 1.5),
        decoration: BoxDecoration(
          color: active ? C.teal : C.border2,
          borderRadius: BorderRadius.circular(2),
        ),
      )).toList(),
    ),
  );
}

// ── Cajas de instrucción y pista ──────────────────────────────────────────────

class InstrBox extends StatelessWidget {
  final String text;
  const InstrBox(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: C.tealBg,
        borderRadius: BorderRadius.circular(R.card),
        border: Border.all(color: C.tealBdr, width: 0.5),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, color: C.tealDeep, height: 1.55)),
    );
  }
}

class HintBox extends StatelessWidget {
  final String text;
  const HintBox(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 8),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(color: C.bg, borderRadius: BorderRadius.circular(R.md)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.info_outline_rounded, size: 15, color: C.txt2),
        const SizedBox(width: 8),
        Expanded(child: Text(text,
            style: const TextStyle(fontSize: 11, color: C.txt2, height: 1.4))),
      ]),
    );
  }
}

// ── StepDots ──────────────────────────────────────────────────────────────────

class StepDots extends StatelessWidget {
  final int total;
  final int current;
  const StepDots({super.key, required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    if (total <= 1) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(total, (i) {
            Color c = i < current ? C.blueLight : i == current ? C.blue : C.bg;
            return Container(
              width: 6, height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(shape: BoxShape.circle, color: c),
            );
          })),
    );
  }
}

// ── VideoBox placeholder ──────────────────────────────────────────────────────

class VideoBox extends StatelessWidget {
  const VideoBox({super.key});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
    height: 110,
    decoration: BoxDecoration(
      color: C.bg,
      borderRadius: BorderRadius.circular(R.card),
      border: Border.all(color: C.border, width: 0.5),
    ),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: C.surface, shape: BoxShape.circle,
          border: Border.all(color: C.border, width: 0.5),
        ),
        child: const Icon(Icons.play_arrow_rounded, size: 18, color: C.txt),
      ),
      const SizedBox(height: 6),
      const Text('Ver cómo se pronuncia · vídeo logopeda',
          style: TextStyle(fontSize: 11, color: C.txt2)),
    ]),
  );
}

// ── ErrorBox ──────────────────────────────────────────────────────────────────

class ErrorBox extends StatelessWidget {
  final String message;
  const ErrorBox(this.message, {super.key});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: C.redBg,
      borderRadius: BorderRadius.circular(R.card),
      border: Border.all(color: C.red.withOpacity(0.3), width: 0.5),
    ),
    child: Row(children: [
      const Icon(Icons.error_outline_rounded, size: 16, color: C.red),
      const SizedBox(width: 8),
      Expanded(child: Text(message,
          style: const TextStyle(fontSize: 12, color: C.red))),
    ]),
  );
}

// ── StatMini ──────────────────────────────────────────────────────────────────

class StatMini extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const StatMini({super.key, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(color: C.bg, borderRadius: BorderRadius.circular(R.card)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, color: C.txt2)),
      const SizedBox(height: 3),
      Text(value, style: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w500, color: valueColor ?? C.txt)),
    ]),
  );
}