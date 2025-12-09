import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_client.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
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

  /// Inicializar y verificar si hay sesión guardada
  Future<void> checkAuth() async {
    _loading = true;
    notifyListeners();

    try {
      //Verificar token guardado en SharedPreferences
      await Future.delayed(const Duration(milliseconds: 500));
      _authenticated = false;
      _token = null;
      ApiClient.authToken = null;
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
      await Future.delayed(const Duration(seconds: 1));

      // Simulación: admin@test.com / cliente@test.com
      if (email == 'admin@test.com' && password == '123456') {
        _authenticated = true;
        _name = 'Administrador';
        _role = 'admin';
        _userId = 1;
        _token = 'fake-token-admin';
      } else if (email == 'cliente@test.com' && password == '123456') {
        _authenticated = true;
        _name = 'Cliente Demo';
        _role = 'cliente';
        _userId = 2;
        _token = 'fake-token-cliente';
      } else {
        throw Exception('Credenciales incorrectas (Demo)');
      }

      // Aunque el token sea falso, lo seteamos por si la API pública lo requiere o lo ignora
      ApiClient.authToken = _token;

      notifyListeners();
      return true;
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
      await Future.delayed(const Duration(milliseconds: 300));

      _authenticated = false;
      _token = null;
      ApiClient.authToken = null;
    } catch (e) {
      debugPrint('Error al cerrar sesión: $e');
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
      // Llamar al AuthService cuando esté implementado
      // final result = await _authService.register(
      //   nombre: nombre,
      //   email: email,
      //   password: password,
      //   telefono: telefono,
      // );
      // _token = result['token'];
      // final user = result['user'];
      // _userId = user.idUsuario;
      // _name = user.nombre;
      // _role = user.rol;
      // _authenticated = true;

      await Future.delayed(const Duration(seconds: 1));
      throw UnimplementedError('Registro aún no implementado');
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
