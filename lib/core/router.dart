import 'package:go_router/go_router.dart';
import '../screens/login_screen.dart';
import '../screens/paciente/paciente_shell.dart';
import '../screens/paciente/pages.dart';
import '../screens/logopeda/logopeda_shell.dart';
import '../screens/logopeda/pages.dart';
import '../core/models.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),

    // ── Paciente (shell con sidebar) ──────────────────────────────────────
    ShellRoute(
      builder: (ctx, state, child) => PacienteShell(child: child),
      routes: [
        GoRoute(path: '/inicio',   builder: (_, __) => const PacienteHomePage()),
        GoRoute(path: '/progreso', builder: (_, __) => const PacienteProgresoPage()),
        GoRoute(path: '/perfil',   builder: (_, __) => const PacientePerfilPage()),
        GoRoute(
          path: '/ficha/:id',
          builder: (_, s) => PacienteFichaPage(userFichaId: s.pathParameters['id']!),
        ),
        GoRoute(
          path: '/ficha/:id/grabar/:wi',
          builder: (_, s) {
            final extra = s.extra as Map<String, dynamic>;
            return PacienteGrabarPage(
              userFichaId: s.pathParameters['id']!,
              wordIdx:     int.parse(s.pathParameters['wi']!),
              sessionId:   extra['sessionId'],
              ficha:       extra['ficha'] as Ficha,
            );
          },
        ),
        GoRoute(
          path: '/ficha/:id/resultado/:wi',
          builder: (_, s) {
            final extra = s.extra as Map<String, dynamic>;
            return PacienteResultadoPage(
              userFichaId: s.pathParameters['id']!,
              wordIdx:     int.parse(s.pathParameters['wi']!),
              ficha:       extra['ficha'] as Ficha,
              attempt:     extra['attempt'] as Attempt,
            );
          },
        ),
      ],
    ),

    // ── Logopeda (shell con sidebar) ──────────────────────────────────────
    ShellRoute(
      builder: (ctx, state, child) => LogopedaShell(child: child),
      routes: [
        GoRoute(path: '/logopeda/inicio',     builder: (_, __) => const LogopedaHomePage()),
        GoRoute(path: '/logopeda/fichas',      builder: (_, __) => const LogopedaFichasPage()),
        GoRoute(path: '/logopeda/pacientes',   builder: (_, __) => const LogopedaPacientesPage()),
        GoRoute(path: '/logopeda/nueva-ficha', builder: (_, __) => const LogopedaNuevaFichaPage()),
        GoRoute(
          path: '/logopeda/paciente/:id',
          builder: (_, s) => LogopedaPacienteDetallePage(pacienteId: s.pathParameters['id']!),
        ),
        GoRoute(
          path: '/logopeda/asignar/:pid',
          builder: (_, s) => LogopedaAsignarFichaPage(pacienteId: s.pathParameters['pid']!),
        ),
      ],
    ),
  ],
);
//flutter run -d edge --web-port=8081