import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';

class SidebarItem {
  final IconData icon;
  final String label;
  final String route;
  const SidebarItem({required this.icon, required this.label, required this.route});
}

class AppSidebar extends StatelessWidget {
  final String appTitle;
  final String appSubtitle;
  final List<SidebarItem> items;
  final String currentRoute;
  final VoidCallback? onLogout;

  const AppSidebar({
    super.key,
    required this.appTitle,
    required this.appSubtitle,
    required this.items,
    required this.currentRoute,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: const BoxDecoration(
        color: C.surface,
        border: Border(right: BorderSide(color: C.border, width: 0.5)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Logo + nombre app
        Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: C.border, width: 0.5)),
          ),
          child: Row(children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: C.blue, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.record_voice_over_outlined,
                color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(appTitle, style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: C.txt)),
              Text(appSubtitle, style: const TextStyle(
                fontSize: 10, color: C.txt2)),
            ])),
          ]),
        ),

        // Items de navegación
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Column(children: items.map((item) {
              final active = currentRoute.startsWith(item.route);
              return _SidebarTile(item: item, active: active,
                onTap: () => context.go(item.route));
            }).toList()),
          ),
        ),

        // Logout
        if (onLogout != null)
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: C.border, width: 0.5))),
            padding: const EdgeInsets.all(8),
            child: _SidebarTile(
              item: const SidebarItem(
                icon: Icons.logout_rounded,
                label: 'Cerrar sesión',
                route: '/login',
              ),
              active: false,
              onTap: onLogout!,
            ),
          ),
      ]),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final SidebarItem item;
  final bool active;
  final VoidCallback onTap;

  const _SidebarTile({required this.item, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: active ? C.blueBg : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(children: [
        Icon(item.icon, size: 17,
          color: active ? C.blue : C.txt2),
        const SizedBox(width: 10),
        Text(item.label, style: TextStyle(
          fontSize: 13,
          color: active ? C.blue : C.txt2,
          fontWeight: active ? FontWeight.w500 : FontWeight.w400,
        )),
      ]),
    ),
  );
}
