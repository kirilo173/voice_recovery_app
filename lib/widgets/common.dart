import 'package:flutter/material.dart';
import '../core/theme.dart';

// ── Card ──────────────────────────────────────────────────────────────────────

class WCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color? color;

  const WCard({
    super.key, required this.child, this.onTap,
    this.margin = const EdgeInsets.only(bottom: 8),
    this.padding = const EdgeInsets.all(14),
    this.color,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? C.surface,
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
    padding: const EdgeInsets.fromLTRB(0, 12, 0, 6),
    child: Text(text.toUpperCase(),
      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500,
        color: C.txt2, letterSpacing: 0.7)),
  );
}

// ── Botones ───────────────────────────────────────────────────────────────────

class BtnP extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final IconData? icon;
  final bool loading;
  final bool fullWidth;

  const BtnP({
    super.key, required this.label, this.onTap,
    this.color, this.icon, this.loading = false, this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final btn = ElevatedButton(
      onPressed: loading ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? C.blue,
        minimumSize: fullWidth ? const Size(double.infinity, 40) : const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      child: loading
        ? const SizedBox(width: 16, height: 16,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
        : Row(mainAxisSize: MainAxisSize.min, children: [
            if (icon != null) ...[Icon(icon, size: 14), const SizedBox(width: 6)],
            Text(label),
          ]),
    );
    return fullWidth ? SizedBox(width: double.infinity, child: btn) : btn;
  }
}

class BtnS extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool fullWidth;

  const BtnS({super.key, required this.label, this.onTap, this.fullWidth = true});

  @override
  Widget build(BuildContext context) {
    final btn = OutlinedButton(onPressed: onTap, child: Text(label));
    return fullWidth ? SizedBox(width: double.infinity, child: btn) : btn;
  }
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
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
    child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: fg)),
  );
}

// ── StatBox ───────────────────────────────────────────────────────────────────

class StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;

  const StatBox({super.key, required this.value, required this.label, this.valueColor});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: C.surface,
      borderRadius: BorderRadius.circular(R.card),
      border: Border.all(color: C.border, width: 0.5),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(value, style: TextStyle(
        fontSize: 26, fontWeight: FontWeight.w600,
        color: valueColor ?? C.txt)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 12, color: C.txt2)),
    ]),
  );
}

// ── Waveform ──────────────────────────────────────────────────────────────────

class Waveform extends StatelessWidget {
  final bool active;
  final List<double> heights;
  const Waveform({super.key, required this.active, required this.heights});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 40,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: heights.map((h) => Container(
        width: 4, height: h,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: active ? C.teal : C.border2,
          borderRadius: BorderRadius.circular(2),
        ),
      )).toList(),
    ),
  );
}

// ── Cajas info ────────────────────────────────────────────────────────────────

class InstrBox extends StatelessWidget {
  final String text;
  const InstrBox(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: C.tealBg,
        borderRadius: BorderRadius.circular(R.card),
        border: Border.all(color: C.tealBdr, width: 0.5),
      ),
      child: Text(text, style: const TextStyle(fontSize: 13, color: C.tealDeep, height: 1.55)),
    );
  }
}

class ErrorBox extends StatelessWidget {
  final String message;
  const ErrorBox(this.message, {super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: C.redBg,
      borderRadius: BorderRadius.circular(R.card),
      border: Border.all(color: C.red.withOpacity(0.3), width: 0.5),
    ),
    child: Row(children: [
      const Icon(Icons.error_outline_rounded, size: 16, color: C.red),
      const SizedBox(width: 8),
      Expanded(child: Text(message, style: const TextStyle(fontSize: 12, color: C.red))),
    ]),
  );
}

// ── VideoBox placeholder ──────────────────────────────────────────────────────

class VideoBox extends StatelessWidget {
  const VideoBox({super.key});
  @override
  Widget build(BuildContext context) => Container(
    height: 160,
    decoration: BoxDecoration(
      color: C.bg,
      borderRadius: BorderRadius.circular(R.card),
      border: Border.all(color: C.border, width: 0.5),
    ),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: C.surface, shape: BoxShape.circle,
          border: Border.all(color: C.border, width: 0.5),
        ),
        child: const Icon(Icons.play_arrow_rounded, size: 22, color: C.txt),
      ),
      const SizedBox(height: 8),
      const Text('Ver cómo se pronuncia · vídeo logopeda',
        style: TextStyle(fontSize: 12, color: C.txt2)),
    ]),
  );
}

// ── StepDots ──────────────────────────────────────────────────────────────────

class StepDots extends StatelessWidget {
  final int total, current;
  const StepDots({super.key, required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    if (total <= 1) return const SizedBox.shrink();
    return Row(mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        Color c = i < current ? C.blueLight : i == current ? C.blue : C.bg;
        return Container(
          width: 7, height: 7,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(shape: BoxShape.circle, color: c,
            border: Border.all(color: C.border, width: 0.5)),
        );
      }));
  }
}

// ── PageTitle ─────────────────────────────────────────────────────────────────

class PageTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;

  const PageTitle({super.key, required this.title, this.subtitle, this.action});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.w600, color: C.txt)),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle!, style: const TextStyle(fontSize: 13, color: C.txt2)),
        ],
      ])),
      if (action != null) action!,
    ]),
  );
}
