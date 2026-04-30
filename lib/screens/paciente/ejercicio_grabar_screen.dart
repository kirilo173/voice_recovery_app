import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/models.dart';
import '../../widgets/waveform_logo.dart';

class EjercicioGrabarScreen extends StatefulWidget {
  final Ejercicio ejercicio;

  const EjercicioGrabarScreen({super.key, required this.ejercicio});

  @override
  State<EjercicioGrabarScreen> createState() => _EjercicioGrabarScreenState();
}

class _EjercicioGrabarScreenState extends State<EjercicioGrabarScreen> {
  bool _grabando = false;

  void _toggleGrabacion() async {
    if (_grabando) {
      // Para la grabación → mock análisis
      setState(() => _grabando = false);
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;

      // Mock resultado: simulamos un 87% de éxito reconociendo la palabra
      final resultado = ResultadoIntento(
        ejercicioId: widget.ejercicio.id,
        porcentaje: 87,
        textoReconocido: widget.ejercicio.palabra,
        fecha: DateTime.now(),
      );

      context.go(
        '/ejercicios/${widget.ejercicio.id}/resultado',
        extra: resultado,
      );
    } else {
      setState(() => _grabando = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.go('/ejercicios/${widget.ejercicio.id}'),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 8),
              Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              Text('ver vídeo', style: TextStyle(
                color: AppColors.primary, fontSize: 14, fontFamily: 'Geist',
              )),
            ],
          ),
        ),
        leadingWidth: 90,
        title: Text(widget.ejercicio.palabra),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Palabra
            Text(
              widget.ejercicio.palabra,
              style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                fontFamily: 'Geist',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${widget.ejercicio.nivel.label} - nivel ${widget.ejercicio.nivel.numero}',
              style: tt.bodyMedium,
            ),
            const SizedBox(height: 32),

            // Área de grabación
            Expanded(
              child: GestureDetector(
                onTap: _toggleGrabacion,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _grabando
                        ? AppColors.primary.withOpacity(0.08)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _grabando ? AppColors.primary.withOpacity(0.4) : AppColors.border,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Waveform
                      WaveformLogo(
                        size: 40,
                        animate: _grabando,
                      ),
                      const SizedBox(height: 24),

                      // Botón de grabación
                      GestureDetector(
                        onTap: _toggleGrabacion,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _grabando
                                ? AppColors.primary.withOpacity(0.20)
                                : AppColors.surface,
                            border: Border.all(
                              color: _grabando ? AppColors.primary : AppColors.border,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: _grabando ? 24 : 36,
                              height: _grabando ? 24 : 36,
                              decoration: BoxDecoration(
                                color: _grabando ? AppColors.primary : AppColors.recordRed,
                                borderRadius: BorderRadius.circular(_grabando ? 6 : 50),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        _grabando
                            ? 'Grabando... pulsa para parar'
                            : 'Pulsa para grabar',
                        style: tt.bodyMedium?.copyWith(
                          color: _grabando ? AppColors.primary : AppColors.textSecondary,
                          fontWeight: _grabando ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () => context.go('/ejercicios/${widget.ejercicio.id}'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  foregroundColor: AppColors.textPrimary,
                ),
                child: const Text('Ver el vídeo de nuevo'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}