// ─────────────────────────────────────────────────────────────────────────────
// patient/patient_app.dart  —  entry point for the patient-facing app
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../../data/repositories.dart';
import '../../../data/static_data.dart';
import '../../../theme/app_theme.dart';
import 'home_screen.dart';
import 'progreso_screen.dart';
import 'perfil_screen.dart';

class PatientApp extends StatefulWidget {
  const PatientApp({super.key});

  @override
  State<PatientApp> createState() => _PatientAppState();
}

class _PatientAppState extends State<PatientApp> {
  int _tab = 0;

  // In production: load from PatientRepository
  final _patient = kPatient;
  final _stats = kPatientStats;
  late final _modulos = buildModulosForPatient(kPatient.id);

  static const _tabs = [
    _TabInfo(icon: Icons.home_outlined, label: 'Inicio'),
    _TabInfo(icon: Icons.bar_chart_outlined, label: 'Progreso'),
    _TabInfo(icon: Icons.person_outline_rounded, label: 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F0),
      // ── App bar ───────────────────────────────────────────────────────────
      // Only shown on non-home tabs
      appBar: _tab == 0
          ? null
          : AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          _tabs[_tab].label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E)),
        ),
        centerTitle: true,
      ),

      // ── Body ──────────────────────────────────────────────────────────────
      body: IndexedStack(
        index: _tab,
        children: [
          PatientHomeScreen(patient: _patient, stats: _stats, modulos: _modulos),
          ProgresoScreen(stats: _stats),
          PerfilScreen(patient: _patient),
        ],
      ),

      // ── Bottom navigation ─────────────────────────────────────────────────
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
                        Icon(t.icon, size: 22, color: active ? AppColors.blue600 : AppColors.gray400),
                        const SizedBox(height: 2),
                        Text(t.label, style: TextStyle(fontSize: 9, color: active ? AppColors.blue600 : AppColors.gray400)),
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