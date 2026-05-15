// ─────────────────────────────────────────────────────────────────────────────
// patient/home_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../../data/static_data.dart';
import '../../../theme/app_theme.dart';
import 'package:voice_rec_app/ui/shared_widgets.dart';
import 'modulo_screen.dart';

class PatientHomeScreen extends StatelessWidget {
  final UserModel patient;
  final PatientStats stats;
  final List<ModuloUI> modulos;

  const PatientHomeScreen({
    super.key,
    required this.patient,
    required this.stats,
    required this.modulos,
  });

  @override
  Widget build(BuildContext context) {
    // Find recommended ficha (first active one)
    FichaUI? recommended;
    ModuloUI? recommendedModulo;
    for (final m in modulos) {
      for (final f in m.fichas) {
        if (f.status == FichaStatus.active) {
          recommended = f;
          recommendedModulo = m;
          break;
        }
      }
      if (recommended != null) break;
    }

    return CustomScrollView(
      slivers: [
        // ── Hero header ──────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Container(
            color: AppColors.blue600,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Mi rehabilitación', style: TextStyle(fontSize: 10, color: Color(0xB3FFFFFF))),
                const SizedBox(height: 2),
                const Text(
                  'Fase A — Iniciación a la voz esofágica',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                ),
                const SizedBox(height: 10),
                // Streak card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department_outlined, color: Color(0xFFFFD060), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        '${stats.streakDays} días seguidos · ¡Sigue así!',
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Módulos ───────────────────────────────────────────────────────────
        const SliverToBoxAdapter(child: SectionLabel('Módulos')),

        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, i) {
              final m = modulos[i];
              return _ModuloRow(
                modulo: m,
                onTap: m.locked
                    ? null
                    : () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ModuloScreen(modulo: m)),
                ),
              );
            },
            childCount: modulos.length,
          ),
        ),

        // ── Recommended card ──────────────────────────────────────────────────
        if (recommended != null && recommendedModulo != null) ...[
          const SliverToBoxAdapter(child: SectionLabel('Sesión de hoy')),
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ModuloScreen(modulo: recommendedModulo!)),
              ),
              child: Container(
                margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.amber50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.amber100, width: 0.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_outline_rounded, size: 22, color: AppColors.amber400),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('RECOMENDADO AHORA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.amber800, letterSpacing: 0.4)),
                          Text(recommended!.ficha.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.amber800)),
                          Text('Empieza por ${recommendedModulo!.title.toLowerCase()}', style: const TextStyle(fontSize: 11, color: AppColors.amber600)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_rounded, size: 18, color: AppColors.amber600),
                  ],
                ),
              ),
            ),
          ),
        ],

        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}

class _ModuloRow extends StatelessWidget {
  final ModuloUI modulo;
  final VoidCallback? onTap;

  const _ModuloRow({required this.modulo, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: modulo.locked ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.fromLTRB(14, 0, 14, 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0x26000000), width: 0.5),
          ),
          child: Row(
            children: [
              ModuleIcon(
                icon: AppIcons.fromName(modulo.iconName),
                bg: modulo.bgColor,
                fg: modulo.iconColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(modulo.title, style: AppText.cardTitle),
                    Text(modulo.subtitle, style: AppText.cardSub),
                    const SizedBox(height: 5),
                    AppProgressBar(value: modulo.progress, color: modulo.iconColor),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              modulo.locked
                  ? const Icon(Icons.lock_outline_rounded, size: 16, color: AppColors.gray400)
                  : Text(
                '${modulo.doneFichas}/${modulo.totalFichas}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.blue600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}