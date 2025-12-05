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
  final String _baseUrl = BASE_URL;

  Map<String, String> _headers() {
    return {'Content-Type': 'application/json', 'Accept': 'application/json'};
  }

  dynamic _handleResponse(http.Response response) {
    final responseBody = json.decode(response.body);

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
      throw ApiException('Error de red', 500);
    } catch (e) {
      rethrow;
    }
  }
}
