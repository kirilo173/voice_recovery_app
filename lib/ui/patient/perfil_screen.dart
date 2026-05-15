// ─────────────────────────────────────────────────────────────────────────────
// patient/perfil_screen.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../../theme/app_theme.dart';
import 'package:voice_rec_app/ui/shared_widgets.dart';

class PerfilScreen extends StatelessWidget {
  final UserModel patient;
  const PerfilScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Avatar + name
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0x26000000), width: 0.5)),
            ),
            child: Column(
              children: [
                UserAvatar(initials: patient.initials, bg: AppColors.blue50, fg: AppColors.blue600, size: 60),
                const SizedBox(height: 8),
                Text(patient.name ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1C1C1E))),
                const SizedBox(height: 2),
                Text('${patient.voiceTypeLabel} · Fase A', style: AppText.cardSub),
              ],
            ),
          ),

          const SectionLabel('Mi configuración'),

          // Settings list
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0x26000000), width: 0.5),
            ),
            child: Column(
              children: [
                _SettingRow(label: 'Tipo de voz', value: patient.voiceTypeLabel),
                const Divider(height: 0.5, thickness: 0.5, color: Color(0x26000000)),
                _SettingRow(label: 'Fase actual', value: 'Fase A'),
                const Divider(height: 0.5, thickness: 0.5, color: Color(0x26000000)),
                _SettingRow(label: 'Logopeda', value: 'Dra. García', valueColor: AppColors.blue600),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SettingRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF1C1C1E))),
          Text(value, style: TextStyle(fontSize: 13, color: valueColor ?? AppColors.gray400)),
        ],
      ),
    );
  }
}