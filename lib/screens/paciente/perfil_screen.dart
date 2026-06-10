import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';
import '../../../core/models.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/common.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});
  @override State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  AppUser? _user;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final user = await AuthService.me();
      if (!mounted) return;
      setState(() { _user = user; _loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(child: Column(children: [
        AppNav(backLabel: 'inicio', onBack: () => context.go('/inicio'), title: 'Mi perfil'),

        Expanded(child: _loading
            ? const Center(child: CircularProgressIndicator(color: C.blue))
            : _error != null
            ? Center(child: ErrorBox(_error!))
            : ListView(children: [
          // Avatar + nombre
          Container(
            color: C.surface,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: C.blueBg,
                child: Text(
                    _user?.initials ?? '??',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: C.blue)),
              ),
              const SizedBox(height: 8),
              Text(_user?.displayName ?? '',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(_user?.email ?? '',
                  style: const TextStyle(fontSize: 12, color: C.txt2)),
            ]),
          ),
          const Divider(),
          const SizedBox(height: 12),

          const SLbl('Mi configuración'),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: C.surface,
              borderRadius: BorderRadius.circular(R.card),
              border: Border.all(color: C.border, width: 0.5),
            ),
            child: Column(children: [
              _CfgRow(
                label: 'Tipo de voz',
                value: _user?.voiceType == VoiceType.esofagico
                    ? 'Esofágica'
                    : _user?.voiceType == VoiceType.electrolaringe
                    ? 'Electrolaringe'
                    : 'No definido',
              ),
              const Divider(height: 0),
              _CfgRow(
                label: 'Nivel actual',
                value: 'Nivel ${_user?.currentLevel ?? 1}',
              ),
              const Divider(height: 0),
              _CfgRow(
                label: 'Racha',
                value: '${_user?.streakDays ?? 0} días 🔥',
              ),
              const Divider(height: 0),
              _CfgRow(
                label: 'Rol',
                value: _user?.role == UserRole.logopeda ? 'Logopeda' : 'Paciente',
                blue: true,
              ),
            ]),
          ),
          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: BtnS(
              label: 'Cerrar sesión',
              onTap: _logout,
            ),
          ),
          const SizedBox(height: 12),
        ])),

        PatientTabBar(current: 2, onTap: (i) {
          if (i == 0) context.go('/inicio');
          if (i == 1) context.go('/progreso');
        }),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ])),
    );
  }
}

class _CfgRow extends StatelessWidget {
  final String label, value;
  final bool blue;
  const _CfgRow({required this.label, required this.value, this.blue = false});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(fontSize: 13)),
      Text(value, style: TextStyle(fontSize: 13, color: blue ? C.blue : C.txt2)),
    ]),
  );
}