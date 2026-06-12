import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../core/theme.dart';
import '../core/models.dart';
import '../services/auth_service.dart';
import '../widgets/common.dart';

const _googleClientId =
    '16632811043-oqpuaibfapb1gqvdjipg211ms5svv8rt.apps.googleusercontent.com';

final _googleSignIn = GoogleSignIn(
  clientId: _googleClientId,
  scopes: ['email', 'profile', 'openid'],
);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl    = TextEditingController();
  final _passCtrl     = TextEditingController();
  bool _loading       = false;
  bool _loadingGoogle = false;
  bool _obscure       = true;
  String? _error;

  Future<void> _login() async {
    final email = _emailCtrl.text.trim();
    final pass  = _passCtrl.text.trim();
    if (email.isEmpty || pass.isEmpty) {
      setState(() => _error = 'Introduce email y contraseña');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final auth = await AuthService.loginEmail(email, pass);
      if (!mounted) return;
      auth.user.role == UserRole.logopeda
        ? context.go('/logopeda/inicio')
        : context.go('/inicio');
    } catch (e) {
      setState(() { _error = _msg(e); _loading = false; });
    }
  }

  Future<void> _loginGoogle() async {
    setState(() { _loadingGoogle = true; _error = null; });
    try {
      // Forzar selección de cuenta siempre
      await _googleSignIn.signOut();
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _loadingGoogle = false);
        return;
      }

      // En web, usamos el accessToken para el backend
      final googleAuth = await googleUser.authentication;
      
      // Intentar con idToken primero, si no con accessToken
      final token = googleAuth.idToken ?? googleAuth.accessToken;
      
      if (token == null) {
        setState(() {
          _error = 'No se pudo obtener el token. Intenta de nuevo.';
          _loadingGoogle = false;
        });
        return;
      }

      final auth = await AuthService.loginGoogle(token);
      if (!mounted) return;
      auth.user.role == UserRole.logopeda
        ? context.go('/logopeda/inicio')
        : context.go('/inicio');

    } catch (e) {
      setState(() {
        _error = 'Error Google: ${e.toString().substring(0, e.toString().length > 80 ? 80 : e.toString().length)}';
        _loadingGoogle = false;
      });
    }
  }

  String _msg(Object e) {
    final s = e.toString();
    if (s.contains('401') || s.contains('Unauthorized')) return 'Email o contraseña incorrectos';
    if (s.contains('Connection') || s.contains('SocketException')) return 'No se puede conectar al servidor';
    return 'Error: ${s.substring(0, s.length > 100 ? 100 : s.length)}';
  }

  @override
  void dispose() { _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: C.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: C.border, width: 0.5),
              boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 24, offset: const Offset(0, 4))],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(child: Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: C.blueBg, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.record_voice_over_outlined, color: C.blue, size: 24),
              )),
              const SizedBox(height: 16),
              const Center(child: Text('Recupera tu voz',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: C.txt))),
              const SizedBox(height: 4),
              const Center(child: Text('Accede a tu cuenta',
                style: TextStyle(fontSize: 13, color: C.txt2))),
              const SizedBox(height: 28),

              const Text('Email', style: TextStyle(fontSize: 12, color: C.txt2)),
              const SizedBox(height: 4),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'tu@email.com'),
              ),
              const SizedBox(height: 14),

              const Text('Contraseña', style: TextStyle(fontSize: 12, color: C.txt2)),
              const SizedBox(height: 4),
              TextField(
                controller: _passCtrl,
                obscureText: _obscure,
                onSubmitted: (_) => _login(),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  suffixIcon: IconButton(
                    icon: Icon(_obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                      size: 18, color: C.txt2),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),

              if (_error != null) ...[
                const SizedBox(height: 10),
                ErrorBox(_error!),
              ],
              const SizedBox(height: 20),

              BtnP(label: 'Entrar', onTap: _login, loading: _loading),
              const SizedBox(height: 14),

              Row(children: const [
                Expanded(child: Divider()),
                Padding(padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('o', style: TextStyle(fontSize: 12, color: C.txt2))),
                Expanded(child: Divider()),
              ]),
              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity, height: 40,
                child: OutlinedButton(
                  onPressed: _loadingGoogle ? null : _loginGoogle,
                  child: _loadingGoogle
                    ? const SizedBox(width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: C.blue))
                    : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        SizedBox(width: 18, height: 18,
                          child: CustomPaint(painter: _GoogleLogoPainter())),
                        const SizedBox(width: 10),
                        const Text('Continuar con Google',
                          style: TextStyle(fontSize: 13)),
                      ]),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = size.width / 2;
    final r = size.width / 2;
    final rect = Rect.fromCircle(center: Offset(c, c), radius: r * 0.75);
    final stroke = Paint()..style = PaintingStyle.stroke..strokeWidth = r * 0.35;
    stroke.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, -1.8, 1.4, false, stroke);
    stroke.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, -0.4, 1.2, false, stroke);
    stroke.color = const Color(0xFF34A853);
    canvas.drawArc(rect, 0.8, 1.2, false, stroke);
    stroke.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, 2.0, 1.1, false, stroke);
  }
  @override bool shouldRepaint(_) => false;
}
