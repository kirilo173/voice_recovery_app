// ─────────────────────────────────────────────────────────────────────────────
// main.dart  —  entry point
// Muestra un selector de rol para desarrollo/demo.
// En producción: reemplazar RoleSelector por la pantalla de login real.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/static_data.dart';
import 'theme/app_theme.dart';
import 'ui/patient/patient_app.dart';
import 'ui/logopeda/logopeda_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const RecuperaTuVozApp());
}

class RecuperaTuVozApp extends StatelessWidget {
  const RecuperaTuVozApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recupera tu Voz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const RoleSelector(),
    );
  }
}

// ─── Selector de rol (solo para desarrollo/demo) ──────────────────────────────
class RoleSelector extends StatelessWidget {
  const RoleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue600,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              // Logo / título
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.record_voice_over_outlined, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 20),
              const Text(
                'Recupera\ntu Voz',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Rehabilitación vocal tras laringectomía',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const Spacer(),
              // Botones de rol
              const Text(
                'ENTRAR COMO',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xB3FFFFFF),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 12),
              _RoleButton(
                label: 'Paciente',
                sublabel: 'Adrián Molina',
                icon: Icons.person_outline_rounded,
                bg: Colors.white,
                fg: AppColors.blue600,
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const PatientApp()),
                ),
              ),
              const SizedBox(height: 10),
              _RoleButton(
                label: 'Logopeda',
                sublabel: 'Dra. García',
                icon: Icons.medical_services_outlined,
                bg: Colors.white.withOpacity(0.15),
                fg: Colors.white,
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LogopedaApp()),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String label;
  final String sublabel;
  final IconData icon;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  const _RoleButton({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: fg, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: fg)),
                  Text(sublabel, style: TextStyle(fontSize: 12, color: fg.withOpacity(0.6))),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: fg.withOpacity(0.5), size: 14),
          ],
        ),
      ),
    );
  }
}