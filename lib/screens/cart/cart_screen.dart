import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi Carrito 🛒',
          style: TextStyle(color: AppColors.black),
        ),
        backgroundColor: AppColors.pinkPrimary,
        foregroundColor: AppColors.black,
        actions: [
          if (cartProvider.itemCount > 0)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                _showClearCartDialog(context, cartProvider);
              },
              tooltip: 'Vaciar carrito',
            ),
        ],
      ),
      body: cartProvider.itemCount == 0
          ? _buildEmptyCart()
          : _buildCartContent(context, cartProvider),
      bottomNavigationBar: cartProvider.itemCount > 0
          ? _buildCheckoutBar(context, cartProvider)
          : null,
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: AppColors.grey),
          const SizedBox(height: 20),
          const Text(
            'Tu carrito está vacío',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.greyDark,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '¡Agrega productos para comenzar!',
            style: TextStyle(color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartProvider cartProvider) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: cartProvider.items.length,
            itemBuilder: (context, index) {
              final cartItem = cartProvider.items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Imagen placeholder
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.pinkLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.color_lens,
                          color: AppColors.pinkDark,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Información del producto
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartItem.product.nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cartItem.product.formattedPrice,
                              style: const TextStyle(
                                color: AppColors.pinkDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Controles de cantidad
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    cartProvider.removeSingleItem(
                                      cartItem.product.idProducto,
                                    );
                                  },
                                  color: AppColors.pinkDark,
                                  iconSize: 24,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.pinkLight,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${cartItem.quantity}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed:
                                      cartItem.quantity <
                                          cartItem.product.stockActual
                                      ? () {
                                          cartProvider.addItem(
                                            cartItem.product,
                                            1,
                                          );
                                        }
                                      : null,
                                  color: AppColors.pinkDark,
                                  iconSize: 24,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Subtotal y eliminar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              cartProvider.removeItem(
                                cartItem.product.idProducto,
                              );
                            },
                            color: Colors.red,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cartItem.formattedSubtotal,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutBar(BuildContext context, CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  cartProvider.formattedTotalAmount,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pinkDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implementar proceso de checkout/venta
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('🚧 Proceso de compra en desarrollo'),
                      backgroundColor: AppColors.pinkDark,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pinkDark,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'PROCEDER AL PAGO',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vaciar Carrito'),
        content: const Text('¿Estás seguro de que deseas vaciar el carrito?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              cartProvider.clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Carrito vaciado'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Text('Vaciar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
