import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/product.dart';
import 'product_detail_screen.dart';
import '../cart/cart_screen.dart';
import '../../theme/app_theme.dart';

class CatalogScreen extends StatelessWidget {
  final bool showAppBar;

  const CatalogScreen({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    if (productProvider.products.isEmpty && !productProvider.isLoading) {
      Future.microtask(() => productProvider.fetchProducts());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Catálogo de Productos 💄',
          style: TextStyle(color: AppColors.black),
        ),
        backgroundColor: AppColors.pinkPrimary,
        elevation: 0,
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: AppColors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      );
                    },
                  ),
                  if (cart.itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.pinkDark,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.black),
            onPressed: () => productProvider.fetchProducts(page: 1),
          ),
        ],
      ),
      body: productProvider.isLoading && productProvider.products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _buildProductGrid(context, productProvider),
    );
  }

  Widget _buildProductGrid(BuildContext context, ProductProvider provider) {
    if (provider.products.isEmpty) {
      return const Center(child: Text('No se encontraron productos.'));
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: provider.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final producto = provider.products[index];
                return _ProductCard(producto: producto);
              },
            ),
          ),
          _buildPaginationControls(provider),
        ],
      ),
    );
  }

  Widget _buildPaginationControls(ProductProvider provider) {
    if (provider.totalPages <= 1 &&
        provider.products.length < (provider.currentPage * 10)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: provider.currentPage > 1 && !provider.isLoading
                ? () => provider.fetchProducts(page: provider.currentPage - 1)
                : null,
          ),
          Text('Pág. ${provider.currentPage} de ${provider.totalPages}'),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed:
                provider.currentPage < provider.totalPages &&
                    !provider.isLoading
                ? () => provider.fetchProducts(page: provider.currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product producto;

  const _ProductCard({required this.producto});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productId: producto.idProducto),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Placeholder de Imagen
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 90,
                  width: double.infinity,
                  color: AppColors.pinkLight,
                  child: const Icon(
                    Icons.color_lens,
                    size: 40,
                    color: AppColors.pinkDark,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              Expanded(
                child: Text(
                  producto.nombre,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                producto.formattedPrice,
                style: const TextStyle(
                  color: AppColors.pinkDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 6),

              // Botón Añadir
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pinkPrimary,
                    foregroundColor: AppColors.black,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: producto.stockActual > 0
                      ? () {
                          final cartProvider = Provider.of<CartProvider>(
                            context,
                            listen: false,
                          );
                          cartProvider.addItem(producto);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '✅ ${producto.nombre} añadido al carrito',
                              ),
                              duration: const Duration(seconds: 2),
                              backgroundColor: AppColors.pinkDark,
                            ),
                          );
                        }
                      : null,
                  child: const Text('Agregar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
