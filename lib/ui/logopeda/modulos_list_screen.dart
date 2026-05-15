// ─────────────────────────────────────────────────────────────────────────────
// logopeda/modulos_list_screen.dart  —  list of all logopeda's modules
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../data/static_data.dart';
import '../../../theme/app_theme.dart';
import 'package:voice_rec_app/ui/shared_widgets.dart';
import 'nuevo_modulo_screen.dart';

class ModulosListScreen extends StatelessWidget {
  const ModulosListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F0),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            foregroundColor: AppColors.blue600,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Mis módulos', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E))),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: AppColors.blue600),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NuevoModuloScreen())),
              ),
            ],
          ),

          const SliverToBoxAdapter(child: SectionLabel('Módulos activos')),

          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, i) {
                final m = kLogopedaModulos[i];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NuevoModuloScreen(editMode: true))),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(14, 0, 14, 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0x26000000), width: 0.5)),
                    child: Row(
                      children: [
                        ModuleIcon(icon: AppIcons.fromName(m.iconName), bg: m.bgColor, fg: m.iconColor),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m.title, style: AppText.cardTitle),
                              Text('${m.fichaCount} fichas · ${m.patientCount} pacientes', style: AppText.cardSub),
                            ],
                          ),
                        ),
                        const Icon(Icons.edit_outlined, size: 16, color: AppColors.gray400),
                      ],
                    ),
                  ),
                );
              },
              childCount: kLogopedaModulos.length,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 30),
              child: PrimaryButton(
                label: 'Crear nuevo módulo',
                icon: Icons.add,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NuevoModuloScreen())),
              ),
            ),
          ),
        ],
      ),
    );
  }
}