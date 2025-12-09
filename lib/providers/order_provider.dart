import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  List<Order> _orders = [];
  bool _isLoading = false;
  int _currentPage = 1;
  int _totalPages = 1;
  Map<String, dynamic> _filters = {'limit': 10};

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  Future<void> fetchOrders({
    int? page,
    Map<String, dynamic>? newFilters,
  }) async {
    _isLoading = true;
    notifyListeners();

    if (newFilters != null) {
      _filters = {..._filters, ...newFilters};
      _currentPage = 1;
    }

    if (page != null) {
      _currentPage = page;
    }

    try {
      // Variables usadas directamente abajo
      // Dado que el servicio espera argumentos posicionales opcionales o nombrados para filtros especificos,
      // adaptamos la llamada si es necesario.
      // Revisando OrderService.listarVentas, toma argumentos nombrados: page, limit, etc.

      final result = await _orderService.listarVentas(
        page: _currentPage,
        limit: _filters['limit'],
        fechaInicio: _filters['fecha_inicio'],
        fechaFin: _filters['fecha_fin'],
        idCliente: _filters['id_cliente'],
      );

      final List<dynamic> items = result['items'];
      _orders = items.map((json) => Order.fromJson(json)).toList();

      // Ordenar por ID descendente (más recientes primero)
      _orders.sort((a, b) => b.idVenta.compareTo(a.idVenta));

      _totalPages = result['totalPages'] ?? 1;
    } catch (e) {
      debugPrint('Error al cargar ventas: $e');
      _orders = []; // Limpiar en error para evitar estados inconsistentes
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Order?> getOrderDetails(int idVenta) async {
    try {
      final data = await _orderService.obtenerVentaPorId(idVenta);
      return Order.fromJson(data);
    } catch (e) {
      debugPrint('Error al cargar detalle de venta: $e');
      return null;
    }
  }
}
