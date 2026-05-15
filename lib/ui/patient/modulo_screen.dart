// ─────────────────────────────────────────────────────────────────────────────
// patient/modulo_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../../theme/app_theme.dart';
import 'package:voice_rec_app/ui/shared_widgets.dart';
import 'ejercicio_screen.dart';

class ModuloScreen extends StatelessWidget {
  final ModuloUI modulo;

  const ModuloScreen({super.key, required this.modulo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F0),
      body: CustomScrollView(
        slivers: [
          // ── Nav bar ────────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            foregroundColor: AppColors.blue600,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(modulo.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E))),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: modulo.bgColor, borderRadius: BorderRadius.circular(10)),
                    child: Text('${modulo.doneFichas}/${modulo.totalFichas}', style: TextStyle(fontSize: 10, color: modulo.iconColor, fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
            ],
          ),

          // ── Module header ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ModuleIcon(icon: AppIcons.fromName(modulo.iconName), bg: modulo.bgColor, fg: modulo.iconColor, size: 42),
                  const SizedBox(height: 8),
                  Text(modulo.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E))),
                  Text(modulo.subtitle, style: AppText.cardSub),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: AppProgressBar(value: modulo.progress, color: modulo.iconColor, height: 4)),
                      const SizedBox(width: 8),
                      Text('${modulo.doneFichas} de ${modulo.totalFichas}', style: AppText.cardSub),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Fichas list ────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.only(top: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, i) {
                  final fichaUI = modulo.fichas[i];
                  return _FichaRow(
                    fichaUI: fichaUI,
                    index: i,
                    onTap: fichaUI.status == FichaStatus.locked
                        ? null
                        : () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EjercicioScreen(fichaUI: fichaUI, modulo: modulo)),
                    ),
                  );
                },
                childCount: modulo.fichas.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }
}

class _FichaRow extends StatelessWidget {
  final FichaUI fichaUI;
  final int index;
  final VoidCallback? onTap;

  const _FichaRow({required this.fichaUI, required this.index, this.onTap});

  @override
  Widget build(BuildContext context) {
    final f = fichaUI.ficha;
    final st = fichaUI.status;
    final isDone = st == FichaStatus.done;
    final isLocked = st == FichaStatus.locked;

    return Opacity(
      opacity: isLocked ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.fromLTRB(14, 0, 14, 7),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDone ? AppColors.gray50 : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0x26000000), width: 0.5),
          ),
          child: Row(
            children: [
              // Number circle
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? AppColors.teal50 : st == FichaStatus.active ? AppColors.blue50 : AppColors.gray50,
                ),
                alignment: Alignment.center,
                child: isDone
                    ? const Icon(Icons.check_rounded, size: 12, color: AppColors.teal600)
                    : Text('${index + 1}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: st == FichaStatus.active ? AppColors.blue600 : AppColors.gray400)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(f.name, style: AppText.cardTitle),
                    Text(f.words.isEmpty ? '' : f.words.take(4).join(' · '), style: AppText.cardSub),
                    if (f.words.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Wrap(
                          spacing: 4,
                          children: f.words.take(4).map((w) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(color: AppColors.gray50, borderRadius: BorderRadius.circular(5)),
                            child: Text(w, style: const TextStyle(fontSize: 11, color: AppColors.gray400)),
                          )).toList(),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (isDone) StatusBadge.done(),
              if (st == FichaStatus.active) StatusBadge.practice(),
              if (isLocked) const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.gray400),
            ],
          ),
        ),
      ),
    );
  }
}