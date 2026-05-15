// ─────────────────────────────────────────────────────────────────────────────
// shared_widgets.dart  —  reusable components across both apps
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/models.dart';

// ── Avatar with initials ──────────────────────────────────────────────────────
class UserAvatar extends StatelessWidget {
  final String initials;
  final Color bg;
  final Color fg;
  final double size;

  const UserAvatar({
    super.key,
    required this.initials,
    required this.bg,
    required this.fg,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(fontSize: size * 0.33, fontWeight: FontWeight.w500, color: fg),
      ),
    );
  }
}

// ── Section label (uppercase muted) ──────────────────────────────────────────
class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
      child: Text(text.toUpperCase(), style: AppText.sectionLabel),
    );
  }
}

// ── Progress bar ──────────────────────────────────────────────────────────────
class AppProgressBar extends StatelessWidget {
  final double value;   // 0.0–1.0
  final Color color;
  final double height;

  const AppProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.height = 3,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        backgroundColor: AppColors.gray50,
        valueColor: AlwaysStoppedAnimation(color),
        minHeight: height,
      ),
    );
  }
}

// ── Status badge (activo / pendiente / bloqueado) ─────────────────────────────
class StatusBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const StatusBadge({super.key, required this.label, required this.bg, required this.fg});

  factory StatusBadge.active() => const StatusBadge(label: 'activo', bg: AppColors.teal50, fg: AppColors.teal600);
  factory StatusBadge.pending() => const StatusBadge(label: 'pendiente', bg: AppColors.amber50, fg: AppColors.amber600);
  factory StatusBadge.done() => const StatusBadge(label: 'hecho', bg: AppColors.teal50, fg: AppColors.teal600);
  factory StatusBadge.locked() => const StatusBadge(label: 'bloqueado', bg: AppColors.gray50, fg: AppColors.gray400);
  factory StatusBadge.practice() => const StatusBadge(label: 'practicar', bg: AppColors.blue50, fg: AppColors.blue600);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: fg)),
    );
  }
}

// ── Module icon container ─────────────────────────────────────────────────────
class ModuleIcon extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color fg;
  final double size;

  const ModuleIcon({super.key, required this.icon, required this.bg, required this.fg, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(9)),
      child: Icon(icon, color: fg, size: size * 0.5),
    );
  }
}

// ── Stat card (metric box) ────────────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const StatCard({super.key, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.cardSub),
          const SizedBox(height: 3),
          Text(value, style: AppText.bigNumber.copyWith(color: valueColor)),
        ],
      ),
    );
  }
}

// ── Primary button ────────────────────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final IconData? icon;

  const PrimaryButton({super.key, required this.label, required this.onTap, this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.blue600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 0,
        ),
        onPressed: onTap,
        icon: icon != null ? Icon(icon, size: 16) : const SizedBox.shrink(),
        label: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

// ── Secondary button ──────────────────────────────────────────────────────────
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const SecondaryButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: const BorderSide(color: Color(0x26000000), width: 0.5),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: onTap,
        child: Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF1C1C1E))),
      ),
    );
  }
}

// ── Video guide placeholder box ───────────────────────────────────────────────
class VideoGuideBox extends StatelessWidget {
  final String? label;
  final VoidCallback? onTap;

  const VideoGuideBox({super.key, this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        margin: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.gray50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x26000000), width: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x26000000), width: 0.5),
              ),
              child: const Icon(Icons.play_arrow_rounded, size: 20, color: Color(0xFF1C1C1E)),
            ),
            const SizedBox(height: 6),
            Text(
              label ?? 'Ver cómo se pronuncia · vídeo logopeda',
              style: AppText.cardSub,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Instruction box (colored info block) ──────────────────────────────────────
class InstructionBox extends StatelessWidget {
  final String text;
  final Color bg;
  final Color border;
  final Color textColor;

  const InstructionBox({
    super.key,
    required this.text,
    this.bg = AppColors.teal50,
    this.border = AppColors.teal100,
    this.textColor = AppColors.teal800,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Text(text, style: TextStyle(fontSize: 12, color: textColor, height: 1.55)),
    );
  }
}

// ── Hint row ──────────────────────────────────────────────────────────────────
class HintRow extends StatelessWidget {
  final String text;
  const HintRow(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, size: 15, color: AppColors.gray400),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 11, color: AppColors.gray400, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

// ── Icons helper (maps string name → IconData) ────────────────────────────────
// Used because static_data stores icon names as strings
class AppIcons {
  AppIcons._();
  static IconData fromName(String name) {
    switch (name) {
      case 'mouth':           return Icons.record_voice_over_outlined;
      case 'wind':            return Icons.air_outlined;
      case 'letter-a':        return Icons.text_fields_outlined;
      case 'alphabet-latin':  return Icons.abc_outlined;
      case 'book':            return Icons.menu_book_outlined;
      case 'layers':          return Icons.layers_outlined;
      case 'users':           return Icons.people_outline;
      case 'home':            return Icons.home_outlined;
      case 'chart-bar':       return Icons.bar_chart_outlined;
      case 'user':            return Icons.person_outline;
      case 'plus':            return Icons.add;
      case 'edit':            return Icons.edit_outlined;
      case 'file-text':       return Icons.description_outlined;
      case 'lock':            return Icons.lock_outlined;
      case 'check':           return Icons.check_rounded;
      case 'flame':           return Icons.local_fire_department_outlined;
      default:                return Icons.circle_outlined;
    }
  }
}