import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  // Getter para calcular el subtotal del item
  double get subtotal => product.precioVenta * quantity;

  // Getter para formatear el subtotal
  String get formattedSubtotal => '\$${subtotal.toStringAsFixed(2)}';
}
