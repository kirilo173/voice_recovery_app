import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/models.dart';

class EjercicioDetalleScreen extends StatelessWidget {
  final Ejercicio ejercicio;

  const EjercicioDetalleScreen({super.key, required this.ejercicio});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.go('/ejercicios'),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 8),
              Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              Text('volver', style: TextStyle(
                color: AppColors.primary, fontSize: 14, fontFamily: 'Geist',
              )),
            ],
          ),
        ),
        leadingWidth: 80,
        title: Text(ejercicio.palabra),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),

            // Palabra grande
            Text(
              ejercicio.palabra,
              style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                fontFamily: 'Geist',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${ejercicio.nivel.label} - nivel ${ejercicio.nivel.numero}',
              style: tt.bodyMedium,
            ),
            const SizedBox(height: 24),

            // Player de vídeo (mock)
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.textPrimary,
                      size: 26,
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Text(
                      'Ver cómo se pronuncia\nvídeo de la logopeda · 45 seg',
                      textAlign: TextAlign.center,
                      style: tt.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Instrucciones
            if (ejercicio.instrucciones != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primaryBg.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary.withOpacity(0.25)),
                ),
                child: Text(
                  ejercicio.instrucciones!,
                  style: tt.bodyLarge?.copyWith(
                    color: AppColors.primary.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
              ),

            const Spacer(),

            // Botones
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => context.go('/ejercicios/${ejercicio.id}/grabar'),
                child: const Text('Listo, voy a practicar'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  foregroundColor: AppColors.textPrimary,
                ),
                child: const Text('Ver el vídeo de nuevo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}