// ─────────────────────────────────────────────────────────────────────────────
// logopeda/logopeda_app.dart  —  shell con bottom nav para el panel logopeda
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../data/static_data.dart';
import '../../../theme/app_theme.dart';
import 'logopeda_home_screen.dart';
import 'modulos_list_screen.dart';
import 'paciente_detail_screen.dart';

class LogopedaApp extends StatefulWidget {
  const LogopedaApp({super.key});

  @override
  State<LogopedaApp> createState() => _LogopedaAppState();
}

class _LogopedaAppState extends State<LogopedaApp> {
  int _tab = 0;

  static const _tabs = [
    _TabInfo(icon: Icons.home_outlined,    label: 'Inicio'),
    _TabInfo(icon: Icons.layers_outlined,  label: 'Módulos'),
    _TabInfo(icon: Icons.people_outline,   label: 'Pacientes'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F0),
      body: IndexedStack(
        index: _tab,
        children: [
          // Tab 0: Home
          LogopedaHomeScreen(logopeda: kLogopeda, patients: kPatientProgress),
          // Tab 1: Módulos
          const ModulosListScreen(),
          // Tab 2: Pacientes (muestra el primero de la lista como demo)
          PacienteDetailScreen(progress: kPatientProgress.first),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0x26000000), width: 0.5)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final t = _tabs[i];
                final active = _tab == i;
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() => _tab = i),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(t.icon, size: 22,
                            color: active ? AppColors.blue600 : AppColors.gray400),
                        const SizedBox(height: 2),
                        Text(t.label,
                            style: TextStyle(
                                fontSize: 9,
                                color: active ? AppColors.blue600 : AppColors.gray400)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabInfo {
  final IconData icon;
  final String label;
  const _TabInfo({required this.icon, required this.label});
}