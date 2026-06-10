import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../core/models.dart';
import '../services/auth_service.dart';
import '../widgets/common.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    setState(() { _loading = true; _error = null; });
    try {
      final auth = await AuthService.loginEmail(
        _emailCtrl.text.trim(),
        _passCtrl.text.trim(),
      );
      if (!mounted) return;
      _navigate(auth.user);
    } catch (e) {
      setState(() => _error = _parseError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _navigate(AppUser user) {
    if (user.role == UserRole.logopeda) {
      context.go('/logopeda');
    } else {
      context.go('/inicio');
    }
  }

  String _parseError(Object e) {
    final s = e.toString();
    if (s.contains('401') || s.contains('Unauthorized')) return 'Email o contraseña incorrectos';
    if (s.contains('SocketException') || s.contains('Connection')) return 'No se puede conectar al servidor';
    return 'Error inesperado. Inténtalo de nuevo.';
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Column(children: [
                // Logo / título
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                      color: C.blueBg, borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.record_voice_over_outlined,
                      color: C.blue, size: 28),
                ),
                const SizedBox(height: 16),
                const Text('Recupera tu voz',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: C.txt)),
                const SizedBox(height: 4),
                const Text('Rehabilitación guiada por logopeda',
                    style: TextStyle(fontSize: 13, color: C.txt2)),
                const SizedBox(height: 36),

                // Email
                const Align(alignment: Alignment.centerLeft,
                    child: Text('Email', style: TextStyle(fontSize: 11, color: C.txt2, letterSpacing: 0.4))),
                const SizedBox(height: 4),
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(hintText: 'tu@email.com'),
                ),
                const SizedBox(height: 14),

                // Password
                const Align(alignment: Alignment.centerLeft,
                    child: Text('Contraseña', style: TextStyle(fontSize: 11, color: C.txt2, letterSpacing: 0.4))),
                const SizedBox(height: 4),
                TextField(
                  controller: _passCtrl,
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                  decoration: const InputDecoration(hintText: '••••••••'),
                  onSubmitted: (_) => _login(),
                ),
                const SizedBox(height: 6),

                // Error
                if (_error != null) ...[
                  const SizedBox(height: 4),
                  ErrorBox(_error!),
                ],
                const SizedBox(height: 20),

                // Botón login
                BtnP(label: 'Entrar', onTap: _login, loading: _loading),
                const SizedBox(height: 12),

                // Divider
                const Row(children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('o', style: TextStyle(fontSize: 12, color: C.txt2)),
                  ),
                  Expanded(child: Divider()),
                ]),
                const SizedBox(height: 12),

                // Google (de momento deshabilitado hasta tener SDK)
                SizedBox(
                  width: double.infinity, height: 44,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implementar Google Sign-In
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Google Sign-In pendiente de configurar')));
                    },
                    icon: const Icon(Icons.g_mobiledata_rounded, size: 22),
                    label: const Text('Continuar con Google'),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}