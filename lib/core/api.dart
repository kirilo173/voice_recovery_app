import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ══════════════════════════════════════════════════════════════════════════════
//  CAMBIA ESTA LÍNEA CUANDO TENGAS LA URL REAL
// ══════════════════════════════════════════════════════════════════════════════
const String baseUrl = 'http://localhost:8000';
// ══════════════════════════════════════════════════════════════════════════════

class Api {
  Api._();

  static final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json'},
  ));

  static Dio get dio => _dio;

  // Guarda el token JWT tras el login
  static Future<void> setToken(String token) async {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Carga el token guardado al arrancar la app
  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  // Borra el token al cerrar sesión
  static Future<void> clearToken() async {
    _dio.options.headers.remove('Authorization');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<bool> get hasToken async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }
}
