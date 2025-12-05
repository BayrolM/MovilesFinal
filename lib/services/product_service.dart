// lib/services/product_service.dart

import '../models/product.dart';
import 'api_client.dart';

class ProductService {
  final ApiClient _apiClient = ApiClient();
  final String _endpoint = '/api/products';

  Future<Map<String, dynamic>> listarProductos(
    Map<String, dynamic> filters,
  ) async {
    final responseBody = await _apiClient.get(_endpoint, queryParams: filters);

    if (responseBody['ok'] == true) {
      final List<dynamic> itemsJson = responseBody['items'];
      final products = itemsJson.map((json) => Product.fromJson(json)).toList();

      return {
        'items': products,
        'total': responseBody['total'] as int,
        'totalPages': responseBody['totalPages'] as int? ?? 1,
        'page': responseBody['page'] as int? ?? 1,
      };
    } else {
      throw Exception(responseBody['message'] ?? 'Fallo al listar productos');
    }
  }

  Future<Product> obtenerProductoPorId(int id) async {
    final responseBody = await _apiClient.get('$_endpoint/$id');

    if (responseBody['ok'] == true) {
      return Product.fromJson(responseBody['data']);
    } else {
      throw Exception(responseBody['message'] ?? 'Producto no encontrado');
    }
  }
}
