import '../core/api.dart';
import '../core/models.dart';

class AuthService {
  // ── Login con email y contraseña ──────────────────────────────────────────
  // POST /auth/login  →  { access_token, user }
  static Future<AuthResponse> loginEmail(String email, String password) async {
    final res = await Api.dio.post('/auth/login', data: {
      'email':    email,
      'password': password,
    });
    final auth = AuthResponse.fromJson(res.data);
    await Api.setToken(auth.accessToken);
    return auth;
  }

  // ── Registro con email y contraseña ──────────────────────────────────────
  // POST /auth/register  →  { access_token, user }
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
  // POST /auth/google  →  { access_token, user }
  // Recibe el idToken que obtienes del SDK de Google
  static Future<AuthResponse> loginGoogle(String idToken) async {
    final res = await Api.dio.post('/auth/google', data: {'id_token': idToken});
    final auth = AuthResponse.fromJson(res.data);
    await Api.setToken(auth.accessToken);
    return auth;
  }

  // ── Obtener usuario actual ────────────────────────────────────────────────
  // GET /auth/me  →  user
  static Future<AppUser> me() async {
    final res = await Api.dio.get('/auth/me');
    return AppUser.fromJson(res.data);
  }

  // ── Vincular paciente con logopeda (código RTV-XXXX) ─────────────────────
  // POST /auth/link  →  { message }
  static Future<void> linkWithCode(String code) async {
    await Api.dio.post('/auth/link', data: {'codigo': code});
  }

  // ── Actualizar tipo de voz ────────────────────────────────────────────────
  // PATCH /auth/me  →  user
  static Future<AppUser> updateVoiceType(String voiceType) async {
    final res = await Api.dio.patch('/auth/me', data: {'voice_type': voiceType});
    return AppUser.fromJson(res.data);
  }

  // ── Cerrar sesión ─────────────────────────────────────────────────────────
  static Future<void> logout() async {
    await Api.clearToken();
  }
}