// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

const String _tokenKey = 'jwt_token';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late final AuthService _authService;

  bool _authenticated = false;
  bool _loading = false;
  User? _user;
  String? _token;

  // Getters
  bool get authenticated => _authenticated;
  bool get loading => _loading;
  User? get user => _user;
  String? get token => _token;

  /// Retorna el rol del usuario ('admin' o 'cliente')
  String get role {
    if (_user?.idRol == 1) {
      return 'admin';
    }
    return 'cliente';
  }

  AuthProvider() {
    _authService = AuthService();
    checkAuth();
  }


  /// Verificar si hay una sesión guardada al iniciar la app
  Future<void> checkAuth() async {
    _loading = true;
    notifyListeners();

    try {
      final savedToken = await _secureStorage.read(key: _tokenKey);
      if (savedToken != null) {
        try {
          // Validar el token obteniendo el perfil
          final profile = await _authService.getProfile(savedToken);
          _token = savedToken;
          _user = profile;
          _authenticated = true;
        } catch (e) {
          // Token inválido o expirado
          await _secureStorage.delete(key: _tokenKey);
          _authenticated = false;
          _token = null;
          _user = null;
        }
      } else {
        _authenticated = false;
        _token = null;
        _user = null;
      }
    } catch (e) {
      _authenticated = false;
      _token = null;
      _user = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Iniciar sesión
  Future<void> login(String email, String password) async {
    _loading = true;
    notifyListeners();

    try {
      // 1. Obtener token
      final result = await _authService.login(email: email, password: password);
      final token = result['token'] as String?;

      if (token == null) {
        throw Exception('Token no recibido del servidor');
      }

      // 2. Obtener perfil del usuario
      _user = await _authService.getProfile(token);
      _token = token;

      // DEBUG
      print('✅ Login exitoso');
      print('📧 Email: ${_user?.email}');
      print('👤 Nombre: ${_user?.nombreCompleto}');
      print('🔑 ID Rol: ${_user?.idRol}');
      print('👑 Rol: $role');

      // 3. Guardar token en almacenamiento seguro
      await _secureStorage.write(key: _tokenKey, value: token);

      _authenticated = true;
    } catch (e) {
      print('❌ Error en login: $e');
      _authenticated = false;
      _token = null;
      _user = null;
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Registrar nuevo usuario
  Future<void> register({
    required String nombres,
    required String apellidos,
    required String email,
    required String password,
    required String tipoDocumento,
    required String documento,
    required String telefono,
    required String direccion,
    required String ciudad,
    int idRol = 2,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      // 1. Registrar usuario
      await _authService.register(
        nombres: nombres,
        apellidos: apellidos,
        email: email,
        password: password,
        tipoDocumento: tipoDocumento,
        documento: documento,
        telefono: telefono,
        direccion: direccion,
        ciudad: ciudad,
        idRol: idRol,
      );

      // 2. Hacer login automáticamente
      await login(email, password);
    } catch (e) {
      _authenticated = false;
      _token = null;
      _user = null;
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Cerrar sesión
  Future<void> logout() async {
    _loading = true;
    notifyListeners();

    try {
      if (_token != null) {
        try {
          await _authService.logout(_token!);
        } catch (_) {
          // Ignorar errores en logout del servidor
        }
      }
      await _secureStorage.delete(key: _tokenKey);
      _authenticated = false;
      _token = null;
      _user = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
