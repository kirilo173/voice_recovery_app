import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';
import '../../../core/models.dart';
import '../../../services/auth_service.dart';
import '../../../services/ficha_service.dart';
import '../../../widgets/common.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppUser? _user;
  List<UserFicha> _fichas = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final user   = await AuthService.me();
      final fichas = await FichaService.getMisFichas();
      if (!mounted) return;
      setState(() { _user = user; _fichas = fichas; _loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: Column(children: [
        // Status bar
        Container(color: C.heroBlue, height: MediaQuery.of(context).padding.top),
        // Hero
        Container(color: C.heroBlue, child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('', style: TextStyle(color: Colors.white, fontSize: 11)),
              const Text('···', style: TextStyle(color: Colors.white, fontSize: 11)),
            ]),
          ),
          HeroBlue(
            label: 'Mi rehabilitación',
            title: _user == null ? 'Cargando...' : 'Hola, ${_user!.displayName}',
            bottom: _user != null && _user!.streakDays > 0
                ? _StreakBadge(days: _user!.streakDays) : null,
          ),
        ])),

        // Cuerpo
        Expanded(child: _loading
            ? const Center(child: CircularProgressIndicator(color: C.blue))
            : _error != null
            ? _ErrorState(error: _error!, onRetry: _load)
            : _Body(fichas: _fichas, user: _user),
        ),

        PatientTabBar(current: 0, onTap: (i) {
          if (i == 1) context.go('/progreso');
          if (i == 2) context.go('/perfil');
        }),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ]),
    );
  }
}

// ── Cuerpo con las fichas ─────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  final List<UserFicha> fichas;
  final AppUser? user;
  const _Body({required this.fichas, this.user});

  @override
  Widget build(BuildContext context) {
    final pendientes  = fichas.where((f) => f.isPending).toList();
    final completadas = fichas.where((f) => f.isCompleted).toList();

    if (fichas.isEmpty) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.inbox_outlined, size: 48, color: C.txt3),
          SizedBox(height: 12),
          Text('No tienes fichas asignadas aún.\nTu logopeda te asignará ejercicios pronto.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: C.txt2, height: 1.5)),
        ]),
      ));
    }

    return ListView(padding: EdgeInsets.zero, children: [
      if (pendientes.isNotEmpty) ...[
        const SLbl('Mis ejercicios'),
        ...pendientes.map((uf) => _FichaCard(uf: uf)),
      ],
      if (completadas.isNotEmpty) ...[
        const SLbl('Completados'),
        ...completadas.map((uf) => _FichaCard(uf: uf, done: true)),
      ],
      const SizedBox(height: 12),
    ]);
  }
}

class _FichaCard extends StatelessWidget {
  final UserFicha uf;
  final bool done;
  const _FichaCard({required this.uf, this.done = false});

  @override
  Widget build(BuildContext context) {
    final ficha = uf.ficha;
    final title = ficha?.name ?? 'Ficha';
    final words = ficha?.words ?? [];
    final score = uf.bestScore != null ? '${(uf.bestScore! * 100).round()}%' : null;

    return WCard(
      onTap: done ? null : () => context.go('/ficha/${uf.id}'),
      child: Row(children: [
        // Icono
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: done ? C.tealBg : C.blueBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            done ? Icons.check_circle_outline_rounded : Icons.play_circle_outline_rounded,
            color: done ? C.tealDark : C.blue, size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text('${words.length} ${words.length == 1 ? 'palabra' : 'palabras'}',
              style: const TextStyle(fontSize: 11, color: C.txt2)),
          if (words.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(words.take(3).join(' · '),
                style: const TextStyle(fontSize: 11, color: C.txt2)),
          ],
        ])),
        if (done && score != null) ...[
          const SizedBox(width: 8),
          Text(score, style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w500, color: C.teal)),
        ],
        if (!done) ...[
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, size: 16, color: C.txt2),
        ],
      ]),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  final int days;
  const _StreakBadge({required this.days});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.18),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.local_fire_department_rounded,
          color: Color(0xFFFFD060), size: 18),
      const SizedBox(width: 8),
      Text('$days días seguidos · ¡Sigue así!',
          style: const TextStyle(color: Colors.white, fontSize: 12)),
    ]),
  );
}

class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.wifi_off_rounded, size: 48, color: C.txt3),
      const SizedBox(height: 12),
      const Text('No se pudo conectar al servidor',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      const SizedBox(height: 8),
      Text(error, style: const TextStyle(fontSize: 11, color: C.txt2),
          textAlign: TextAlign.center),
      const SizedBox(height: 20),
      BtnP(label: 'Reintentar', onTap: onRetry, icon: Icons.refresh_rounded),
    ]),
  ));
}