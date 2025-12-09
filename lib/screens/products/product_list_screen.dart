import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../theme/app_theme.dart';
import '../../models/product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;

    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: AppBar(
        title: const Text(
          'Gestión de Productos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              productProvider.fetchProducts(page: 1);
            },
          ),
        ],
      ),
      body: productProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.pinkDark),
              ),
            )
          : products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: AppColors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay productos disponibles',
                    style: TextStyle(fontSize: 18, color: AppColors.greyDark),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: AppColors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStateProperty.all(
                            AppColors.pinkLight.withValues(alpha: 0.5),
                          ),
                          dataRowColor: MaterialStateProperty.resolveWith((
                            states,
                          ) {
                            return Colors.white;
                          }),
                          columnSpacing: 20,
                          horizontalMargin: 20,
                          columns: const [
                            DataColumn(
                              label: Text(
                                'ID',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.pinkDark,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'SKU',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.pinkDark,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Producto',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.pinkDark,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Precio',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.pinkDark,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Stock',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.pinkDark,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Estado',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.pinkDark,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Acciones',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.pinkDark,
                                ),
                              ),
                            ),
                          ],
                          rows: products.map((product) {
                            return DataRow(
                              cells: [
                                DataCell(Text('#${product.idProducto}')),
                                DataCell(Text(product.sku)),
                                DataCell(
                                  Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: 150,
                                    ),
                                    child: Text(
                                      product.nombre,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    product.formattedPrice,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: product.stockActual > 5
                                          ? Colors.green.withValues(alpha: 0.1)
                                          : Colors.red.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${product.stockActual}',
                                      style: TextStyle(
                                        color: product.stockActual > 5
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: product.estado
                                          ? Colors.blue.withValues(alpha: 0.1)
                                          : Colors.grey.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      product.estado ? 'Activo' : 'Inactivo',
                                      style: TextStyle(
                                        color: product.estado
                                            ? Colors.blue
                                            : Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: AppColors.pinkDark,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          // Navegar a editar
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.redAccent,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          //Eliminar
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),

                  // Pagination controls
                  if (productProvider.totalPages > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 16),
                            onPressed: productProvider.currentPage > 1
                                ? () => productProvider.fetchProducts(
                                    page: productProvider.currentPage - 1,
                                  )
                                : null,
                          ),
                          Text(
                            'Página ${productProvider.currentPage} de ${productProvider.totalPages}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 16),
                            onPressed:
                                productProvider.currentPage <
                                    productProvider.totalPages
                                ? () => productProvider.fetchProducts(
                                    page: productProvider.currentPage + 1,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //  Navegar a crear producto
        },
        backgroundColor: AppColors.pinkPrimary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
