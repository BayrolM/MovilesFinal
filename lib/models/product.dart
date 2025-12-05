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
      idProducto: json['id_producto'] as int,
      sku: json['sku'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      idMarca: json['id_marca'] as int,
      idCategoria: json['id_categoria'] as int,
      precioVenta: (json['precio_venta'] as num).toDouble(),
      stockActual: json['stock_actual'] as int,
      estado: json['estado'] == true || json['estado'] == 1,
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
    symbol: 'S/',
    decimalDigits: 2,
  ).format(precioVenta);
}
