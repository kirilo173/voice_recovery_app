// ─────────────────────────────────────────────────────────────────────────────
// logopeda/logopeda_home_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../../data/static_data.dart';
import '../../../theme/app_theme.dart';
import 'package:voice_rec_app/ui/shared_widgets.dart';
import 'paciente_detail_screen.dart';
import 'nuevo_modulo_screen.dart';
import 'modulos_list_screen.dart';

class LogopedaHomeScreen extends StatelessWidget {
  final UserModel logopeda;
  final List<PatientProgress> patients;

  const LogopedaHomeScreen({super.key, required this.logopeda, required this.patients});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── Header ─────────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Container(
            color: AppColors.blue600,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('panel logopeda', style: TextStyle(fontSize: 10, color: Color(0xB3FFFFFF))),
                const SizedBox(height: 2),
                Text(logopeda.name ?? '', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white)),
                const SizedBox(height: 2),
                Text('${patients.length} pacientes activos', style: const TextStyle(fontSize: 12, color: Color(0xBFFFFFFF))),
              ],
            ),
          ),
        ),

        // ── Stats ──────────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
            child: Row(
              children: [
                Expanded(child: StatCard(label: 'pacientes', value: '${patients.length}')),
                const SizedBox(width: 8),
                Expanded(child: StatCard(label: 'módulos activos', value: '5')),
              ],
            ),
          ),
        ),

        // ── Patients list ──────────────────────────────────────────────────
        const SliverToBoxAdapter(child: SectionLabel('Mis pacientes')),

        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, i) => _PatientCard(
              progress: patients[i],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PacienteDetailScreen(progress: patients[i])),
              ),
            ),
            childCount: patients.length,
          ),
        ),

        // ── Quick actions ──────────────────────────────────────────────────
        const SliverToBoxAdapter(child: SectionLabel('Acciones rápidas')),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(
              children: [
                PrimaryButton(
                  label: 'Crear nuevo módulo',
                  icon: Icons.add,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NuevoModuloScreen())),
                ),
                const SizedBox(height: 7),
                SecondaryButton(
                  label: 'Ver todos los módulos',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ModulosListScreen())),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PatientCard extends StatelessWidget {
  final PatientProgress progress;
  final VoidCallback onTap;

  const _PatientCard({required this.progress, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = progress.patient;
    final isActive = progress.status == 'activo';
    final avatarBg = isActive ? AppColors.blue50 : AppColors.teal50;
    final avatarFg = isActive ? AppColors.blue600 : AppColors.teal600;
    final barColor = isActive ? AppColors.blue400 : AppColors.teal400;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0x26000000), width: 0.5),
        ),
        child: Column(
          children: [
            Row(
              children: [
                UserAvatar(initials: p.initials, bg: avatarBg, fg: avatarFg),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name ?? '', style: AppText.cardTitle),
                      Text('${p.voiceTypeLabel} · Fase A', style: AppText.cardSub),
                    ],
                  ),
                ),
                StatusBadge(
                  label: progress.status,
                  bg: isActive ? AppColors.teal50 : AppColors.amber50,
                  fg: isActive ? AppColors.teal600 : AppColors.amber600,
                ),
              ],
            ),
            const SizedBox(height: 8),
            AppProgressBar(value: progress.overallProgress, color: barColor),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Progreso general', style: AppText.cardSub),
                Text('${(progress.overallProgress * 100).round()}%', style: TextStyle(fontSize: 11, color: barColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}