import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../widgets/waveform_logo.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo + título
              const WaveformLogo(size: 52),
              const SizedBox(height: 18),
              Text(
                'recupera tu voz',
                style: tt.headlineMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Rehabilitación guiada\npor logopeda',
                textAlign: TextAlign.center,
                style: tt.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),

              const Spacer(flex: 2),

              // Features
              _FeatureRow(
                icon: Icons.check_circle_outline_rounded,
                title: 'Ejercicios por niveles',
                subtitle: 'Monosílabas, bísílabas y trísílabas',
              ),
              const SizedBox(height: 16),
              _FeatureRow(
                icon: Icons.video_library_outlined,
                title: 'Vídeos de tu logopeda',
                subtitle: 'Guía visual antes de cada práctica',
              ),
              const SizedBox(height: 16),
              _FeatureRow(
                icon: Icons.add_circle_outline_rounded,
                title: 'Análisis automático de voz',
                subtitle: 'Evaluación de tu pronunciación',
              ),

              const Spacer(flex: 3),

              // Botones
              _PrimaryButton(
                label: 'Empezar',
                onTap: () => context.go('/onboarding/rol'),
              ),
              const SizedBox(height: 12),
              _SecondaryButton(
                label: 'Ya tengo cuenta',
                onTap: () => context.go('/ejercicios'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Widgets internos ──────────────────────────────────────────────────────────

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: tt.titleMedium),
              const SizedBox(height: 2),
              Text(subtitle, style: tt.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(label),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          foregroundColor: AppColors.textPrimary,
          textStyle: const TextStyle(
            fontFamily: 'Geist', fontSize: 16, fontWeight: FontWeight.w500,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}