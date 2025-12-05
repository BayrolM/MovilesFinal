import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  bool _isLoading = false;
  int _currentPage = 1;
  int _totalPages = 1;
  Map<String, dynamic> _filters = {'limit': 10};

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  Future<void> fetchProducts({
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
      final effectiveFilters = {..._filters, 'page': _currentPage};
      final result = await _productService.listarProductos(effectiveFilters);

      _products = result['items'];
      _totalPages = result['totalPages'];
    } catch (e) {
      debugPrint('Error al cargar los productos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
