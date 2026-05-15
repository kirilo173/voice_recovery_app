// ─────────────────────────────────────────────────────────────────────────────
// patient/progreso_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../data/static_data.dart';
import '../../../theme/app_theme.dart';
import 'package:voice_rec_app/ui/shared_widgets.dart';

class ProgresoScreen extends StatelessWidget {
  final PatientStats stats;
  const ProgresoScreen({super.key, required this.stats});

  static const _days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── Stats grid ─────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.0,
              children: [
                StatCard(label: 'sesiones', value: '${stats.totalSessions}'),
                StatCard(label: 'racha', value: '${stats.streakDays} 🔥', valueColor: AppColors.amber400),
                StatCard(label: 'tasa de éxito', value: '${(stats.successRate * 100).round()}%', valueColor: AppColors.teal400),
                StatCard(label: 'ejercicios', value: '${stats.exercisesDone}'),
              ],
            ),
          ),
        ),

        // ── Weekly chart ───────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ESTA SEMANA', style: AppText.sectionLabel),
                const SizedBox(height: 10),
                SizedBox(
                  height: 80,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(7, (i) {
                      final val = stats.weeklyActivity[i];
                      final isToday = i == 4; // Friday
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: FractionallySizedBox(
                                  heightFactor: val.clamp(0.05, 1.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isToday ? AppColors.blue600 : val > 0 ? AppColors.blue400 : AppColors.gray50,
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _days[i],
                              style: TextStyle(
                                fontSize: 9,
                                color: isToday ? AppColors.blue600 : AppColors.gray400,
                                fontWeight: isToday ? FontWeight.w500 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Recent exercises ───────────────────────────────────────────────
        const SliverToBoxAdapter(child: SectionLabel('Últimos ejercicios')),

        SliverList(
          delegate: SliverChildListDelegate([
            _RecentRow(word: 'ea', category: 'diptongo · vocales', score: 0.91, stars: 3),
            _RecentRow(word: 'pan', category: 'monosílaba · sílabas', score: 0.84, stars: 2),
            _RecentRow(word: 'sol', category: 'monosílaba · sílabas', score: 0.62, stars: 1),
          ]),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
    );
  }
}

class _RecentRow extends StatelessWidget {
  final String word;
  final String category;
  final double score;
  final int stars;

  const _RecentRow({required this.word, required this.category, required this.score, required this.stars});

  @override
  Widget build(BuildContext context) {
    final color = score >= 0.70 ? AppColors.teal400 : AppColors.amber400;
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 7),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x26000000), width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(word, style: AppText.cardTitle),
                Text(category, style: AppText.cardSub),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${(score * 100).round()}%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color)),
              Row(
                children: List.generate(3, (i) => Icon(
                  i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 14,
                  color: i < stars ? AppColors.amber400 : AppColors.gray200,
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}