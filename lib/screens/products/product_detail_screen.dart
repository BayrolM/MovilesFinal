import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_theme.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? _product;
  bool _isLoading = true;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _fetchProductDetail();
  }

  Future<void> _fetchProductDetail() async {
    try {
      final product = await ProductService().obtenerProductoPorId(
        widget.productId,
      );
      setState(() {
        _product = product;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _addToCart() {
    if (_product == null) return;

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addItem(_product!, _quantity);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ ${_product!.nombre} (x$_quantity) añadido al carrito',
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.pinkDark,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_product?.nombre ?? 'Detalle del Producto'),
        backgroundColor: AppColors.pinkPrimary,
        foregroundColor: AppColors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _product == null
          ? const Center(child: Text('Producto no disponible.'))
          : _buildProductDetails(context),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen placeholder estilizada
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 250,
              width: double.infinity,
              color: AppColors.pinkLight,
              child: const Icon(
                Icons.brush,
                size: 80,
                color: AppColors.pinkDark,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Nombre y SKU
          Text(
            _product!.nombre,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          Text(
            'SKU: ${_product!.sku}',
            style: const TextStyle(color: AppColors.greyDark, fontSize: 16),
          ),

          const SizedBox(height: 15),

          // Precio
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Precio Venta:',
                style: TextStyle(fontSize: 18, color: AppColors.black),
              ),
              Text(
                _product!.formattedPrice,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.pinkDark,
                ),
              ),
            ],
          ),

          const Divider(height: 30, color: AppColors.grey),

          // Descripción
          const Text(
            'Descripción',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _product!.descripcion ??
                'Este producto no tiene una descripción detallada.',
            style: const TextStyle(fontSize: 16, color: AppColors.black),
          ),

          const Divider(height: 30, color: AppColors.grey),

          // Stock
          Text(
            'Stock Disponible: ${_product!.stockActual}',
            style: TextStyle(
              color: _product!.stockActual > 0
                  ? Colors.green.shade700
                  : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 30),

          //Control de Cantidad y Boton de Añadir al Carrito
          Row(
            children: [
              // Botones de Cantidad
              Container(
                decoration: BoxDecoration(
                  color: AppColors.pinkLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: AppColors.black),
                      onPressed: _quantity > 1
                          ? () => setState(() => _quantity--)
                          : null,
                    ),
                    Text(
                      '$_quantity',
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: AppColors.black),
                      onPressed: _quantity < _product!.stockActual
                          ? () => setState(() => _quantity++)
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),

              // Botón Añadir al Carrito
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: const Text('AÑADIR AL CARRITO'),
                  onPressed: _product!.stockActual > 0 ? _addToCart : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pinkDark,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
