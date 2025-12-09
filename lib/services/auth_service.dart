import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../config/app_config.dart';

class AuthService {
  final String base = baseUrl; // desde app_config

  /// POST /api/auth/login
  /// Espera respuesta: { "token": "eyJhb..." }
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$base/api/auth/login');
    final res = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}));

    if (res.statusCode == 200 || res.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(res.body);
      return data;
    } else {
      String message;
      try {
        final body = jsonDecode(res.body);
        message = body['message'] ?? body['msg'] ?? res.body;
      } catch (_) {
        message = res.body;
      }
      throw Exception('Login failed (${res.statusCode}): $message');
    }
  }

  /// POST /api/auth/register
  /// Body: { id_rol, tipo_documento, documento, nombres, apellidos, email, telefono, direccion, ciudad, password }
  /// Respuesta: { "message": "Usuario registrado correctamente" }
  Future<Map<String, dynamic>> register({
    required String nombres,
    required String apellidos,
    required String email,
    required String password,
    required String tipoDocumento,
    required String documento,
    required String telefono,
    required String direccion,
    required String ciudad,
    int idRol = 2, // 2 = cliente por defecto
  }) async {
    final url = Uri.parse('$base/api/auth/register');
    final body = {
      'id_rol': idRol,
      'tipo_documento': tipoDocumento,
      'documento': documento,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'telefono': telefono,
      'direccion': direccion,
      'ciudad': ciudad,
      'password': password,
    };

    final res = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      String message;
      try {
        final body = jsonDecode(res.body);
        message = body['message'] ?? body['msg'] ?? res.body;
      } catch (_) {
        message = res.body;
      }
      throw Exception('Register failed (${res.statusCode}): $message');
    }
  }

  /// GET /api/users/profile
  /// Obtener perfil del usuario autenticado con el token
  Future<User> getProfile(String token) async {
    final url = Uri.parse('$base/api/users/profile');
    final res = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (res.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(res.body);
      return User.fromJson(data);
    } else {
      String message;
      try {
        final body = jsonDecode(res.body);
        message = body['message'] ?? body['msg'] ?? res.body;
      } catch (_) {
        message = res.body;
      }
      throw Exception('Failed to fetch profile (${res.statusCode}): $message');
    }
  }

  /// POST /api/auth/logout (opcional)
  /// Invalida el token en el servidor
  Future<void> logout(String token) async {
    final url = Uri.parse('$base/api/auth/logout');
    try {
      await http.post(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
    } catch (e) {
      rethrow;
    }
  }
}
