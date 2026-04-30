import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/models.dart';

class DetallePacienteScreen extends StatelessWidget {
  final Paciente paciente;

  const DetallePacienteScreen({super.key, required this.paciente});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.go('/logopeda'),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 8),
              Icon(Icons.arrow_back_ios_new_rounded, size: 16),
              Text('pacientes', style: TextStyle(
                color: AppColors.primary, fontSize: 14, fontFamily: 'Geist',
              )),
            ],
          ),
        ),
        leadingWidth: 100,
        title: Text(paciente.nombreCompleto),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header paciente
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primaryMuted,
                  child: Text(
                    paciente.iniciales,
                    style: const TextStyle(
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(paciente.nombreCompleto, style: tt.titleLarge),
                      Text(
                        '${paciente.tipoVoz.label} - nivel ${paciente.nivelActual.numero}',
                        style: tt.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Activo',
                    style: tt.bodySmall?.copyWith(
                      color: AppColors.primary, fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Stats
            Row(children: [
              Expanded(child: _StatCard(
                value: '${paciente.tasaExito.round()}%',
                label: 'tasa éxito',
                green: true,
              )),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(
                value: '5',
                label: 'racha dias',
              )),
            ]),
            const SizedBox(height: 24),

            Text('Ejercicios recientes', style: tt.titleMedium),
            const SizedBox(height: 12),

            ...paciente.historial.map((r) {
              final ejercicio = MockData.ejercicios.firstWhere(
                    (e) => e.id == r.ejercicioId,
                orElse: () => MockData.ejercicios.first,
              );
              return _EjercicioHistorialRow(ejercicio: ejercicio, resultado: r);
            }),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Asignar nuevo ejercicio'),
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
                child: const Text('Ajustar umbral de flor'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final bool green;

  const _StatCard({required this.value, required this.label, this.green = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: green ? AppColors.primary : AppColors.textPrimary,
              fontFamily: 'Geist',
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted, fontSize: 12, fontFamily: 'Geist',
            ),
          ),
        ],
      ),
    );
  }
}

class _EjercicioHistorialRow extends StatelessWidget {
  final Ejercicio ejercicio;
  final ResultadoIntento resultado;

  const _EjercicioHistorialRow({required this.ejercicio, required this.resultado});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final stars = resultado.estrellas;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(ejercicio.palabra, style: tt.titleMedium),
          ),
          const SizedBox(width: 8),
          Text(ejercicio.nivel.label, style: tt.bodySmall),
          const SizedBox(width: 8),
          // Estrellas
          Row(children: List.generate(3, (i) => Icon(
            i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 18,
            color: i < stars ? AppColors.warning : AppColors.textMuted,
          ))),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _colorForPct(resultado.porcentaje).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${resultado.porcentaje}%',
              style: tt.bodySmall?.copyWith(
                color: _colorForPct(resultado.porcentaje),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _colorForPct(int pct) {
    if (pct >= 80) return AppColors.primary;
    if (pct >= 60) return AppColors.warning;
    return AppColors.error;
  }
}