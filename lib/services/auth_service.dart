import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final String _endpoint = '/api/auth';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _apiClient.post(
      '$_endpoint/login',
      body: {'email': email, 'password': password},
    );

    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> register({
    required String nombre,
    required String email,
    required String password,
    String? telefono,
  }) async {
    final response = await _apiClient.post(
      '$_endpoint/register',
      body: {
        'nombre': nombre,
        'email': email,
        'password': password,
        'telefono': telefono,
      },
    );

    return response as Map<String, dynamic>;
  }
}
