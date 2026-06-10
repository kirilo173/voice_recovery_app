import '../core/api.dart';
import '../core/models.dart';
import 'demo_service.dart';

// Variable en memoria para saber si la sesión actual es demo
bool _demoSessionActive = false;
bool get isDemoSession => _demoSessionActive;

class AuthService {
  // ── Login con email y contraseña ──────────────────────────────────────────
  static Future<AuthResponse> loginEmail(String email, String password) async {
    // ── DEMO: credenciales estáticas sin BD ───────────────────────────────
    if (email.trim().toLowerCase() == demoEmail &&
        password.trim() == demoPassword) {
      _demoSessionActive = true;
      return AuthResponse(
        accessToken: 'demo-token',
        user: demoLogopeda,
      );
    }
    // ── FIN DEMO ──────────────────────────────────────────────────────────

    _demoSessionActive = false;
    final res = await Api.dio.post('/auth/login', data: {
      'email':    email,
      'password': password,
    });
    final auth = AuthResponse.fromJson(res.data);
    await Api.setToken(auth.accessToken);
    return auth;
  }

  // ── Registro con email y contraseña ──────────────────────────────────────
  static Future<AuthResponse> register(String email, String password, String name) async {
    final res = await Api.dio.post('/auth/register', data: {
      'email':    email,
      'password': password,
      'name':     name,
    });
    final auth = AuthResponse.fromJson(res.data);
    await Api.setToken(auth.accessToken);
    return auth;
  }

  // ── Login con Google ──────────────────────────────────────────────────────
  static Future<AuthResponse> loginGoogle(String idToken) async {
    final res = await Api.dio.post('/auth/google', data: {'id_token': idToken});
    final auth = AuthResponse.fromJson(res.data);
    await Api.setToken(auth.accessToken);
    return auth;
  }

  // ── Obtener usuario actual ────────────────────────────────────────────────
  static Future<AppUser> me() async {
    if (_demoSessionActive) return demoLogopeda; // DEMO
    final res = await Api.dio.get('/auth/me');
    return AppUser.fromJson(res.data);
  }

  // ── Vincular paciente con logopeda (código RTV-XXXX) ─────────────────────
  static Future<void> linkWithCode(String code) async {
    if (_demoSessionActive) return; // DEMO: no-op
    await Api.dio.post('/auth/link', data: {'codigo': code});
  }

  // ── Actualizar tipo de voz ────────────────────────────────────────────────
  static Future<AppUser> updateVoiceType(String voiceType) async {
    if (_demoSessionActive) return demoLogopeda; // DEMO
    final res = await Api.dio.patch('/auth/me', data: {'voice_type': voiceType});
    return AppUser.fromJson(res.data);
  }

  // ── Cerrar sesión ─────────────────────────────────────────────────────────
  static Future<void> logout() async {
    _demoSessionActive = false;
    await Api.clearToken();
  }
}
