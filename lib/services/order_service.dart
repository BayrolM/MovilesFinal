import 'api_client.dart';
import '../models/cart_item.dart';

class OrderService {
  final ApiClient _apiClient = ApiClient();
  final String _endpoint = '/api/sales';

  /// Crear una nueva venta/orden
  ///
  /// Parámetros esperados por la API:
  /// - id_cliente: ID del cliente (int)
  /// - id_empleado: ID del empleado que procesa la venta (int, opcional)
  /// - productos: Lista de productos con cantidad
  ///   Formato: [{ id_producto: int, cantidad: int, precio_unitario: double }]
  Future<Map<String, dynamic>> crearVenta({
    required int idCliente,
    int? idEmpleado,
    required List<CartItem> productos,
  }) async {
    // Convertir los items del carrito al formato esperado por la API
    final productosData = productos.map((item) {
      return {
        'id_producto': item.product.idProducto,
        'cantidad': item.quantity,
        'precio_unitario': item.product.precioVenta,
      };
    }).toList();

    final requestBody = {
      'id_cliente': idCliente,
      if (idEmpleado != null) 'id_empleado': idEmpleado,
      'productos': productosData,
    };

    final responseBody = await _apiClient.post(_endpoint, body: requestBody);

    if (responseBody['ok'] == true) {
      return responseBody['data'];
    } else {
      throw Exception(responseBody['message'] ?? 'Error al crear la venta');
    }
  }

  /// Obtener detalles de una venta por ID
  Future<Map<String, dynamic>> obtenerVentaPorId(int idVenta) async {
    final responseBody = await _apiClient.get('$_endpoint/$idVenta');

    if (responseBody['ok'] == true) {
      return responseBody['data'];
    } else {
      throw Exception(responseBody['message'] ?? 'Venta no encontrada');
    }
  }

  /// Listar ventas con filtros opcionales
  Future<Map<String, dynamic>> listarVentas({
    int? page,
    int? limit,
    int? idCliente,
    String? fechaInicio,
    String? fechaFin,
  }) async {
    final queryParams = <String, dynamic>{};

    if (page != null) queryParams['page'] = page;
    if (limit != null) queryParams['limit'] = limit;
    if (idCliente != null) queryParams['id_cliente'] = idCliente;
    if (fechaInicio != null) queryParams['fecha_inicio'] = fechaInicio;
    if (fechaFin != null) queryParams['fecha_fin'] = fechaFin;

    final responseBody = await _apiClient.get(
      _endpoint,
      queryParams: queryParams,
    );

    if (responseBody['ok'] == true) {
      return {
        'items': responseBody['items'],
        'total': responseBody['total'] as int,
        'totalPages': responseBody['totalPages'] as int? ?? 1,
        'page': responseBody['page'] as int? ?? 1,
      };
    } else {
      throw Exception(responseBody['message'] ?? 'Error al listar ventas');
    }
  }
}
