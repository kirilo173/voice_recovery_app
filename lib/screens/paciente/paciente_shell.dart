import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/sidebar.dart';

class PacienteShell extends StatelessWidget {
  final Widget child;
  const PacienteShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      backgroundColor: C.bg,
      body: Row(children: [
        AppSidebar(
          appTitle:    'Recupera tu voz',
          appSubtitle: 'Mi rehabilitación',
          currentRoute: location,
          items: const [
            SidebarItem(icon: Icons.home_outlined,     label: 'Inicio',   route: '/inicio'),
            SidebarItem(icon: Icons.bar_chart_rounded, label: 'Progreso', route: '/progreso'),
            SidebarItem(icon: Icons.person_outline,    label: 'Perfil',   route: '/perfil'),
          ],
          onLogout: () async {
            await AuthService.logout();
            if (context.mounted) context.go('/login');
          },
        ),
        // Contenido principal
        Expanded(child: child),
      ]),
    );
  }
}
