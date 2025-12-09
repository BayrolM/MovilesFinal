import 'package:intl/intl.dart';

class Product {
  final int idProducto;
  final String sku;
  final String nombre;
  final String? descripcion;
  final int idMarca;
  final int idCategoria;
  final double precioVenta;
  final int stockActual;
  final bool estado;

  Product({
    required this.idProducto,
    required this.sku,
    required this.nombre,
    this.descripcion,
    required this.idMarca,
    required this.idCategoria,
    required this.precioVenta,
    required this.stockActual,
    required this.estado,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      idProducto: int.tryParse(json['id_producto'].toString()) ?? 0,
      sku: json['sku']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      idMarca: int.tryParse(json['id_marca'].toString()) ?? 0,
      idCategoria: int.tryParse(json['id_categoria'].toString()) ?? 0,
      precioVenta: double.tryParse(json['precio_venta'].toString()) ?? 0.0,
      stockActual: int.tryParse(json['stock_actual'].toString()) ?? 0,
      estado:
          json['estado'] == true ||
          json['estado'] == 1 ||
          json['estado'].toString() == '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_producto': idProducto,
      'sku': sku,
      'nombre': nombre,
      'descripcion': descripcion,
      'id_marca': idMarca,
      'id_categoria': idCategoria,
      'precio_venta': precioVenta,
      'stock_actual': stockActual,
      'estado': estado,
    };
  }

  String get formattedPrice => NumberFormat.currency(
    locale: 'es',
    symbol: '\$/',
    decimalDigits: 2,
  ).format(precioVenta);
}
