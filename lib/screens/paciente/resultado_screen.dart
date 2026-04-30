import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/models.dart';

class ResultadoScreen extends StatelessWidget {
  final Ejercicio ejercicio;
  final ResultadoIntento resultado;

  const ResultadoScreen({
    super.key,
    required this.ejercicio,
    required this.resultado,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final exito = resultado.porcentaje >= ejercicio.umbralExito;
    final stars = resultado.estrellas;

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
          children: [
            const SizedBox(height: 16),

            // Porcentaje
            Text(
              '${resultado.porcentaje}%',
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                fontFamily: 'Geist',
                letterSpacing: -2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Whisper escuchó: "${resultado.textoReconocido}"',
              style: tt.bodyMedium,
            ),

            const SizedBox(height: 16),

            // Barra de progreso
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: resultado.porcentaje / 100,
                backgroundColor: AppColors.surfaceLight,
                valueColor: AlwaysStoppedAnimation(
                  exito ? AppColors.primary : AppColors.warning,
                ),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 20),

            // Mensaje de feedback
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: exito
                    ? AppColors.primary.withOpacity(0.08)
                    : AppColors.warning.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: exito
                      ? AppColors.primary.withOpacity(0.25)
                      : AppColors.warning.withOpacity(0.25),
                ),
              ),
              child: Text(
                exito
                    ? 'Muy bien. Tu pronunciación fue reconocida correctamente. El sistema detectó la palabra completa.'
                    : 'Buen intento. Sigue practicando para mejorar la claridad. Intenta soltar el aire con más calma.',
                style: tt.bodyLarge?.copyWith(
                  color: exito ? AppColors.primary : AppColors.warning,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Estrellas
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 36,
                  color: i < stars ? AppColors.warning : AppColors.textMuted,
                ),
              )),
            ),
            const SizedBox(height: 8),
            Text(
              'Has ganado $stars ${stars == 1 ? "estrella" : "estrellas"} en este ejercicio',
              style: tt.bodyMedium,
            ),

            const Spacer(),

            // Botones
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => context.go('/ejercicios'),
                child: const Text('Siguiente ejercicio'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () => context.go('/ejercicios/${ejercicio.id}/grabar'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  foregroundColor: AppColors.textPrimary,
                ),
                child: const Text('Repetir para mejorar'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () => context.go('/ejercicios/${ejercicio.id}'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  foregroundColor: AppColors.textPrimary,
                ),
                child: const Text('Ver el vídeo otra vez'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}