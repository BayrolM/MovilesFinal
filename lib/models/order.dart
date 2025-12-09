import 'package:intl/intl.dart';

class Order {
  final int idVenta;
  final DateTime fechaVenta;
  final double total;
  final String estado;
  final String clienteNombre;
  final List<OrderDetail> detalles;

  Order({
    required this.idVenta,
    required this.fechaVenta,
    required this.total,
    required this.estado,
    required this.clienteNombre,
    this.detalles = const [],
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    // Helper para buscar claves
    dynamic getVal(List<String> keys) {
      for (var key in keys) {
        if (json.containsKey(key) && json[key] != null) return json[key];
      }
      return null;
    }

    final id = getVal(['id', 'id_venta', 'id_orden', 'order_id']);
    final fecha = getVal([
      'fecha_venta',
      'fecha',
      'date',
      'created_at',
      'createdAt',
    ]);
    final total = getVal(['total', 'amount', 'total_price', 'total_amount']);
    final estado = getVal(['estado', 'status']);

    // Cliente puede venir como objeto o string
    String clienteName = 'Cliente';
    final cliente = getVal(['cliente', 'user', 'customer']);
    if (cliente is Map) {
      clienteName =
          cliente['nombre'] ??
          cliente['name'] ??
          cliente['username'] ??
          'Cliente';
    } else if (cliente is String) {
      clienteName = cliente;
    } else {
      // Intentar claves directas
      clienteName =
          getVal([
            'cliente_nombre',
            'nombre_cliente',
            'customer_name',
          ])?.toString() ??
          'Cliente';
    }

    return Order(
      idVenta: int.tryParse(id.toString()) ?? 0,
      fechaVenta: DateTime.tryParse(fecha?.toString() ?? '') ?? DateTime.now(),
      total: double.tryParse(total?.toString() ?? '0') ?? 0.0,
      estado: estado?.toString() ?? 'Desconocido',
      clienteNombre: clienteName,
      detalles:
          (getVal(['detalles', 'details', 'items', 'products', 'productos'])
                  as List<dynamic>?)
              ?.map((item) => OrderDetail.fromJson(item))
              .toList() ??
          [],
    );
  }

  String get formattedTotal => NumberFormat.currency(
    locale: 'es',
    symbol: 'S/',
    decimalDigits: 2,
  ).format(total);

  String get formattedDate => DateFormat('dd/MM/yyyy HH:mm').format(fechaVenta);
}

class OrderDetail {
  final int idProducto;
  final String nombreProducto;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  OrderDetail({
    required this.idProducto,
    required this.nombreProducto,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      idProducto: int.tryParse(json['id_producto'].toString()) ?? 0,
      nombreProducto:
          json['nombre_producto']?.toString() ??
          json['producto']?['nombre']?.toString() ??
          'Producto',
      cantidad: int.tryParse(json['cantidad'].toString()) ?? 0,
      precioUnitario:
          double.tryParse(json['precio_unitario'].toString()) ?? 0.0,
      subtotal:
          double.tryParse(json['subtotal']?.toString() ?? '') ??
          ((double.tryParse(json['cantidad'].toString()) ?? 0) *
              (double.tryParse(json['precio_unitario'].toString()) ?? 0.0)),
    );
  }

  String get formattedPrice => NumberFormat.currency(
    locale: 'es',
    symbol: 'S/',
    decimalDigits: 2,
  ).format(precioUnitario);

  String get formattedSubtotal => NumberFormat.currency(
    locale: 'es',
    symbol: 'S/',
    decimalDigits: 2,
  ).format(subtotal);
}
