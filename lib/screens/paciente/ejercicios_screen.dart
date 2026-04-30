import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../core/models.dart';

class EjerciciosScreen extends StatefulWidget {
  const EjerciciosScreen({super.key});

  @override
  State<EjerciciosScreen> createState() => _EjerciciosScreenState();
}

class _EjerciciosScreenState extends State<EjerciciosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _levelTab;

  // Progreso simulado para la demo
  final Set<String> _completados = {'e1', 'e2'};
  final String _siguiente = 'e3';

  @override
  void initState() {
    super.initState();
    _levelTab = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _levelTab.dispose();
    super.dispose();
  }

  EstadoEjercicio _estado(String id) {
    if (_completados.contains(id)) return EstadoEjercicio.completado;
    if (id == _siguiente) return EstadoEjercicio.siguiente;
    return EstadoEjercicio.bloqueado;
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final ejercicios = MockData.ejercicios;
    final total = ejercicios.length;
    final completados = _completados.length;

    // Días de la semana
    final dias = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    final hoy = DateTime.now().weekday - 1; // 0 = Lunes

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'recupera tu voz',
                    style: tt.headlineMedium?.copyWith(fontSize: 20),
                  ),
                  Text('Adrián M.', style: tt.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Días de la semana
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (i) {
                  final activo = i <= hoy;
                  final esHoy = i == hoy;
                  return _DayBubble(dia: dias[i], activo: activo, esHoy: esHoy);
                }),
              ),
            ),
            const SizedBox(height: 16),

            // Progreso del nivel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'nivel 1 - monosílabas',
                        style: tt.bodyMedium?.copyWith(color: AppColors.textSecondary),
                      ),
                      Text(
                        '$completados/$total',
                        style: tt.bodyMedium?.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: completados / total,
                    backgroundColor: AppColors.surfaceLight,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tabs nivel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TabBar(
                controller: _levelTab,
                tabs: const [
                  Tab(text: 'Nivel 1'),
                  Tab(text: 'Nivel 2'),
                  Tab(text: 'Nivel 3'),
                ],
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textMuted,
                indicatorColor: AppColors.primary,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: AppColors.border,
                labelStyle: const TextStyle(fontFamily: 'Geist', fontSize: 14),
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _levelTab,
                children: [
                  // Nivel 1 - con datos reales
                  _EjerciciosLista(
                    ejercicios: ejercicios
                        .where((e) => e.nivel == NivelEjercicio.mono)
                        .toList(),
                    estadoFn: _estado,
                  ),
                  // Nivel 2 y 3 bloqueados
                  const _NivelBloqueado(),
                  const _NivelBloqueado(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _DayBubble extends StatelessWidget {
  final String dia;
  final bool activo;
  final bool esHoy;

  const _DayBubble({required this.dia, required this.activo, required this.esHoy});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: esHoy
            ? AppColors.primary
            : activo
            ? AppColors.primaryMuted.withOpacity(0.4)
            : AppColors.surface,
      ),
      child: Center(
        child: Text(
          dia,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: esHoy
                ? AppColors.background
                : activo
                ? AppColors.primary
                : AppColors.textMuted,
            fontFamily: 'Geist',
          ),
        ),
      ),
    );
  }
}

class _EjerciciosLista extends StatelessWidget {
  final List<Ejercicio> ejercicios;
  final EstadoEjercicio Function(String) estadoFn;

  const _EjerciciosLista({required this.ejercicios, required this.estadoFn});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    // Agrupar por estado
    final completados  = ejercicios.where((e) => estadoFn(e.id) == EstadoEjercicio.completado).toList();
    final siguiente    = ejercicios.where((e) => estadoFn(e.id) == EstadoEjercicio.siguiente).toList();
    final bloqueados   = ejercicios.where((e) => estadoFn(e.id) == EstadoEjercicio.bloqueado).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      children: [
        if (completados.isNotEmpty) ...[
          Text('Completadas', style: tt.bodyMedium?.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 8),
          ...completados.map((e) => _EjercicioTile(ejercicio: e, estado: EstadoEjercicio.completado)),
          const SizedBox(height: 20),
        ],
        if (siguiente.isNotEmpty) ...[
          Text('Siguiente', style: tt.bodyMedium?.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 8),
          ...siguiente.map((e) => _EjercicioTile(ejercicio: e, estado: EstadoEjercicio.siguiente)),
          const SizedBox(height: 20),
        ],
        if (bloqueados.isNotEmpty) ...[
          Text('Bloqueadas', style: tt.bodyMedium?.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 8),
          ...bloqueados.map((e) => _EjercicioTile(ejercicio: e, estado: EstadoEjercicio.bloqueado)),
        ],
      ],
    );
  }
}

class _EjercicioTile extends StatelessWidget {
  final Ejercicio ejercicio;
  final EstadoEjercicio estado;

  const _EjercicioTile({required this.ejercicio, required this.estado});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final bloqueado = estado == EstadoEjercicio.bloqueado;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: bloqueado ? null : () => context.go('/ejercicios/${ejercicio.id}'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ejercicio.palabra,
                      style: tt.titleMedium?.copyWith(
                        color: bloqueado ? AppColors.textMuted : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Estrellas (solo si completado)
                    if (estado == EstadoEjercicio.completado)
                      Row(children: List.generate(3, (i) => Icon(
                        i < 2 ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 14,
                        color: i < 2 ? AppColors.warning : AppColors.textMuted,
                      ))),
                  ],
                ),
              ),
              _EstadoBadge(estado: estado),
            ],
          ),
        ),
      ),
    );
  }
}

class _EstadoBadge extends StatelessWidget {
  final EstadoEjercicio estado;

  const _EstadoBadge({required this.estado});

  @override
  Widget build(BuildContext context) {
    switch (estado) {
      case EstadoEjercicio.completado:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text('hecho', style: TextStyle(
            color: AppColors.primary, fontSize: 12,
            fontWeight: FontWeight.w500, fontFamily: 'Geist',
          )),
        );
      case EstadoEjercicio.siguiente:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text('practicar', style: TextStyle(
            color: AppColors.textSecondary, fontSize: 12,
            fontWeight: FontWeight.w500, fontFamily: 'Geist',
          )),
        );
      case EstadoEjercicio.bloqueado:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: const Text('Bloqueado', style: TextStyle(
            color: AppColors.textMuted, fontSize: 12,
            fontWeight: FontWeight.w500, fontFamily: 'Geist',
          )),
        );
    }
  }
}

class _NivelBloqueado extends StatelessWidget {
  const _NivelBloqueado();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline_rounded, color: AppColors.textMuted, size: 40),
          const SizedBox(height: 12),
          Text(
            'Completa el nivel anterior\npara desbloquear',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}