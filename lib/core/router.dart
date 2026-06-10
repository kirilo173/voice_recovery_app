import 'package:go_router/go_router.dart';
import '../screens/login_screen.dart';
import '../screens/paciente/home_screen.dart';
import '../screens/paciente/ficha_screen.dart';
import '../screens/paciente/grabar_screen.dart';
import '../screens/paciente/resultado_screen.dart';
import '../screens/paciente/progreso_screen.dart';
import '../screens/paciente/perfil_screen.dart';
import '../screens/logopeda/panel_screen.dart';
import '../screens/logopeda/paciente_detalle_screen.dart';
import '../screens/logopeda/nueva_ficha_screen.dart';
import '../screens/logopeda/asignar_ficha_screen.dart';
import '../core/models.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login',    builder: (_, __) => const LoginScreen()),

    // ── Paciente ──────────────────────────────────────────────────────────
    GoRoute(path: '/inicio',   builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/progreso', builder: (_, __) => const ProgresoScreen()),
    GoRoute(path: '/perfil',   builder: (_, __) => const PerfilScreen()),

    GoRoute(
      path: '/ficha/:userFichaId',
      builder: (_, s) => FichaScreen(userFichaId: s.pathParameters['userFichaId']!),
    ),
    GoRoute(
      path: '/ficha/:userFichaId/grabar/:wordIdx',
      builder: (_, s) {
        final extra = s.extra as Map<String, dynamic>;
        return GrabarScreen(
          userFichaId: s.pathParameters['userFichaId']!,
          wordIdx:     int.parse(s.pathParameters['wordIdx']!),
          sessionId:   extra['sessionId'],
          ficha:       extra['ficha'] as Ficha,
        );
      },
    ),
    GoRoute(
      path: '/ficha/:userFichaId/resultado/:wordIdx',
      builder: (_, s) {
        final extra = s.extra as Map<String, dynamic>;
        return ResultadoScreen(
          userFichaId: s.pathParameters['userFichaId']!,
          wordIdx:     int.parse(s.pathParameters['wordIdx']!),
          ficha:       extra['ficha'] as Ficha,
          attempt:     extra['attempt'] as Attempt,
        );
      },
    ),

    // ── Logopeda ──────────────────────────────────────────────────────────
    GoRoute(path: '/logopeda', builder: (_, __) => const PanelScreen()),
    GoRoute(
      path: '/logopeda/paciente/:id',
      builder: (_, s) => PacienteDetalleScreen(pacienteId: s.pathParameters['id']!),
    ),
    GoRoute(path: '/logopeda/nueva-ficha', builder: (_, __) => const NuevaFichaScreen()),
    GoRoute(
      path: '/logopeda/asignar/:pacienteId',
      builder: (_, s) => AsignarFichaScreen(pacienteId: s.pathParameters['pacienteId']!),
    ),
  ],
);