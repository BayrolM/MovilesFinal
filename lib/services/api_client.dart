import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../config/app_config.dart';

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException: $message (Status Code: $statusCode)';
}

class ApiClient {
  final String _baseUrl = baseUrl;

  // Token global en memoria
  static String? authToken;

  Map<String, String> _headers() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    dynamic responseBody;
    try {
      responseBody = json.decode(response.body);
    } catch (e) {
      // Si falla el decode (ej: HTML error), lanzar excepción con el contenido crudo
      // Intenta extraer el título si es HTML para ser menos ruidoso
      String msg = response.body;
      if (msg.contains('<title>') && msg.contains('</title>')) {
        msg = msg.split('<title>')[1].split('</title>')[0];
      }
      // Limitar longitud
      if (msg.length > 200) msg = msg.substring(0, 200) + '...';

      throw ApiException(
        'Error de servidor (${response.statusCode}): $msg',
        response.statusCode,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseBody;
    } else {
      final errorMessage =
          responseBody['message'] ?? 'Error desconocido del servidor.';
      throw ApiException(errorMessage, response.statusCode);
    }
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint').replace(
      queryParameters: queryParams?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
    try {
      final response = await http.get(uri, headers: _headers());
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Error de red - Sin conexión', 0);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await http.post(
        uri,
        headers: _headers(),
        body: json.encode(body),
      );
      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Error de red - Sin conexión', 0);
    } catch (e) {
      rethrow;
    }
  }
}
