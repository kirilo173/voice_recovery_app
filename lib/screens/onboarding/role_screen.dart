import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/models.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  UserRole _selected = UserRole.paciente;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('¿Cómo usarás la app?', style: tt.titleLarge?.copyWith(fontSize: 22)),
              const SizedBox(height: 8),
              Text(
                'Esto determina tu experiencia dentro de la aplicación',
                style: tt.bodyMedium,
              ),
              const SizedBox(height: 32),

              // Opción paciente
              _RoleCard(
                selected: _selected == UserRole.paciente,
                title: 'Soy paciente',
                subtitle: 'Hago los ejercicios de mi logopeda',
                icon: Icons.person_outline_rounded,
                onTap: () => setState(() => _selected = UserRole.paciente),
              ),
              const SizedBox(height: 12),

              // Opción logopeda
              _RoleCard(
                selected: _selected == UserRole.logopeda,
                title: 'Soy logopeda',
                subtitle: 'Gestiono pacientes y ejercicios',
                icon: Icons.add_box_outlined,
                onTap: () => setState(() => _selected = UserRole.logopeda),
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Los logopedas acceden con contraseña facilitada por la clínica',
                style: tt.bodyMedium?.copyWith(color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_selected == UserRole.paciente) {
                      context.go('/onboarding/perfil');
                    } else {
                      context.go('/logopeda');
                    }
                  },
                  child: const Text('Continuar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final bool selected;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _RoleCard({
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBg.withOpacity(0.12) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Avatar / icono
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary.withOpacity(0.15)
                    : AppColors.surfaceLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: selected ? AppColors.primary : AppColors.textSecondary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: tt.titleMedium?.copyWith(
                      color: selected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: tt.bodyMedium),
                ],
              ),
            ),
            // Radio
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.textMuted,
                  width: 2,
                ),
                color: selected ? AppColors.primary : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.check, size: 14, color: AppColors.background)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}