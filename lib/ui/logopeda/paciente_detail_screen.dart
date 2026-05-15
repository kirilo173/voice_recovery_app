// ─────────────────────────────────────────────────────────────────────────────
// logopeda/paciente_detail_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../../data/static_data.dart';
import '../../../theme/app_theme.dart';
import 'package:voice_rec_app/ui/shared_widgets.dart';
import 'asignar_ficha_screen.dart';

class PacienteDetailScreen extends StatelessWidget {
  final PatientProgress progress;

  const PacienteDetailScreen({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final p = progress.patient;
    final modulos = buildModulosForPatient(p.id);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F0),
      body: CustomScrollView(
        slivers: [
          // Nav
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            foregroundColor: AppColors.blue600,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(p.name ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E))),
          ),

          // Patient header
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Column(
                children: [
                  Row(
                    children: [
                      UserAvatar(initials: p.initials, bg: AppColors.blue50, fg: AppColors.blue600, size: 46),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name ?? '', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E))),
                          Row(
                            children: [
                              Text('${p.voiceTypeLabel} · Fase A · ${p.streakDays} días racha', style: AppText.cardSub),
                              const SizedBox(width: 4),
                              if (p.streakDays > 0) const Icon(Icons.local_fire_department_outlined, size: 12, color: AppColors.amber400),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: StatCard(label: 'tasa éxito', value: '${(progress.successRate * 100).round()}%', valueColor: AppColors.teal400)),
                      const SizedBox(width: 8),
                      Expanded(child: StatCard(label: 'sesiones', value: '${progress.sessionCount}')),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Assigned modules
          const SliverToBoxAdapter(child: SectionLabel('Módulos asignados')),

          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, i) {
                final m = modulos[i];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AsignarFichaScreen(patient: p))),
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
                        ModuleIcon(icon: AppIcons.fromName(m.iconName), bg: m.bgColor, fg: m.iconColor),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m.title, style: AppText.cardTitle),
                              Text('${m.doneFichas} de ${m.totalFichas} fichas · ${(m.progress * 100).round()}%', style: AppText.cardSub),
                              const SizedBox(height: 4),
                              AppProgressBar(value: m.progress, color: m.iconColor),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.gray400),
                      ],
                    ),
                  ),
                );
              },
              childCount: modulos.where((m) => !m.locked).length,
            ),
          ),

          // Actions
          const SliverToBoxAdapter(child: SectionLabel('Acciones')),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 30),
              child: Column(
                children: [
                  PrimaryButton(
                    label: 'Asignar nueva ficha',
                    icon: Icons.add,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AsignarFichaScreen(patient: p))),
                  ),
                  const SizedBox(height: 7),
                  SecondaryButton(label: 'Ajustar umbrales', onTap: () {}),
                  SecondaryButton(label: 'Ver historial completo', onTap: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}