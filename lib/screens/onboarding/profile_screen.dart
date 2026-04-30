import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/models.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameCtrl = TextEditingController();
  TipoVoz _selected = TipoVoz.esofagica;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('Cuéntanos un poco', style: tt.titleLarge?.copyWith(fontSize: 22)),
              const SizedBox(height: 6),
              Text('Solo para personalizar tu experiencia', style: tt.bodyMedium),
              const SizedBox(height: 32),

              // Nombre
              Text('TU NOMBRE', style: tt.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: _nameCtrl,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(hintText: ''),
              ),
              const SizedBox(height: 28),

              // Tipo de voz
              Text('TIPO DE VOZ', style: tt.labelLarge),
              const SizedBox(height: 12),

              ...TipoVoz.values.map((tipo) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _VozCard(
                  tipo: tipo,
                  selected: _selected == tipo,
                  onTap: () => setState(() => _selected = tipo),
                ),
              )),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.go('/ejercicios'),
                  child: const Text('Listo, empezar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VozCard extends StatelessWidget {
  final TipoVoz tipo;
  final bool selected;
  final VoidCallback onTap;

  const _VozCard({
    required this.tipo,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBg.withOpacity(0.10) : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tipo.label,
              style: tt.titleMedium?.copyWith(
                color: selected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(tipo.descripcion, style: tt.bodyMedium),
          ],
        ),
      ),
    );
  }
}