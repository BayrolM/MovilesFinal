import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  // Se usa un Map para guardar los items, usando el aid_producto como clave de acceso
  final Map<int, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();
  int get itemCount => _items.length;

  // Calcula el total del carrito
  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, item) {
      total += item.subtotal;
    });
    return total;
  }

  String get formattedTotalAmount => '\$${totalAmount.toStringAsFixed(2)}';

  void addItem(Product product, [int quantity = 1]) {
    if (_items.containsKey(product.idProducto)) {
      // Si el item ya existe solo se incrementa la cantidad
      _items.update(product.idProducto, (existingItem) {
        // para que no permita que la cantidad exceda el stock disponible
        int newQuantity = existingItem.quantity + quantity;
        if (newQuantity > product.stockActual) {
          newQuantity = product.stockActual;
        }
        return CartItem(product: existingItem.product, quantity: newQuantity);
      });
    } else {
      // aca se crea un nuevo item
      int effectiveQuantity = quantity;
      if (effectiveQuantity > product.stockActual) {
        effectiveQuantity = product.stockActual;
      }
      _items.putIfAbsent(
        product.idProducto,
        () => CartItem(product: product, quantity: effectiveQuantity),
      );
    }
    notifyListeners();
  }

  // Eliminar un producto del carrito
  void removeItem(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(int productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          product: existingItem.product,
          quantity: existingItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  // Limpiar el carrito
  void clear() {
    _items.clear();
    notifyListeners();
  }
}
