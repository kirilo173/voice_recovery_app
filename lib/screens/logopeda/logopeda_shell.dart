import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/sidebar.dart';

class LogopedaShell extends StatelessWidget {
  final Widget child;
  const LogopedaShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      backgroundColor: C.bg,
      body: Row(children: [
        AppSidebar(
          appTitle:    'Recupera tu voz',
          appSubtitle: 'Panel logopeda',
          currentRoute: location,
          items: const [
            SidebarItem(icon: Icons.home_outlined,    label: 'Inicio',     route: '/logopeda/inicio'),
            SidebarItem(icon: Icons.description_outlined, label: 'Fichas', route: '/logopeda/fichas'),
            SidebarItem(icon: Icons.people_outline,   label: 'Pacientes',  route: '/logopeda/pacientes'),
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
