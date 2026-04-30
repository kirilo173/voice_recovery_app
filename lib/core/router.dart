import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding/welcome_screen.dart';
import '../screens/onboarding/role_screen.dart';
import '../screens/onboarding/profile_screen.dart';
import '../screens/paciente/ejercicios_screen.dart';
import '../screens/paciente/ejercicio_detalle_screen.dart';
import '../screens/paciente/ejercicio_grabar_screen.dart';
import '../screens/paciente/resultado_screen.dart';
import '../screens/logopeda/panel_logopeda_screen.dart';
import '../screens/logopeda/detalle_paciente_screen.dart';
import '../core/models.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (_, __) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/onboarding/rol',
      builder: (_, __) => const RoleScreen(),
    ),
    GoRoute(
      path: '/onboarding/perfil',
      builder: (_, __) => const ProfileScreen(),
    ),

    // ── Paciente ──────────────────────────────────────────────────────────
    GoRoute(
      path: '/ejercicios',
      builder: (_, __) => const EjerciciosScreen(),
    ),
    GoRoute(
      path: '/ejercicios/:id',
      builder: (_, state) {
        final id = state.pathParameters['id']!;
        final ejercicio = MockData.ejercicios.firstWhere((e) => e.id == id);
        return EjercicioDetalleScreen(ejercicio: ejercicio);
      },
    ),
    GoRoute(
      path: '/ejercicios/:id/grabar',
      builder: (_, state) {
        final id = state.pathParameters['id']!;
        final ejercicio = MockData.ejercicios.firstWhere((e) => e.id == id);
        return EjercicioGrabarScreen(ejercicio: ejercicio);
      },
    ),
    GoRoute(
      path: '/ejercicios/:id/resultado',
      builder: (_, state) {
        final id = state.pathParameters['id']!;
        final ejercicio = MockData.ejercicios.firstWhere((e) => e.id == id);
        final extra = state.extra as ResultadoIntento;
        return ResultadoScreen(ejercicio: ejercicio, resultado: extra);
      },
    ),

    // ── Logopeda ──────────────────────────────────────────────────────────
    GoRoute(
      path: '/logopeda',
      builder: (_, __) => const PanelLogopedaScreen(),
    ),
    GoRoute(
      path: '/logopeda/paciente/:id',
      builder: (_, state) {
        final id = state.pathParameters['id']!;
        final paciente = MockData.pacientes.firstWhere((p) => p.id == id);
        return DetallePacienteScreen(paciente: paciente);
      },
    ),
  ],
);