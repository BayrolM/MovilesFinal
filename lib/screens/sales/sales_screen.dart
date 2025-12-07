import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../theme/app_theme.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    });
  }

  Future<void> _showOrderDetails(int idVenta) async {
    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.pinkDark),
        ),
      ),
    );

    final provider = Provider.of<OrderProvider>(context, listen: false);
    final order = await provider.getOrderDetails(idVenta);

    if (!mounted) return;
    Navigator.pop(context); // Cerrar loading

    if (order != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Detalle de Venta #${order.idVenta}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Cliente:', order.clienteNombre),
                _buildDetailRow('Fecha:', order.formattedDate),
                _buildDetailRow('Estado:', order.estado),
                const Divider(),
                const Text(
                  'Productos:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (order.detalles.isEmpty)
                  const Text('Sin detalles disponibles'),
                ...order.detalles.map(
                  (d) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${d.cantidad}x ${d.nombreProducto}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        Text(
                          d.formattedSubtotal,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Total: ${order.formattedTotal}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.pinkDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
            TextButton(
              onPressed: () {
                // Feature "En desarrollo"
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función en desarrollo')),
                );
              },
              child: const Text('Imprimir'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo cargar el detalle de la venta'),
        ),
      );
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.greyDark,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: AppBar(
        title: const Text(
          'Gestión de Ventas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              orderProvider.fetchOrders(page: 1);
            },
          ),
        ],
      ),
      body: orderProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.pinkDark),
              ),
            )
          : orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: AppColors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay ventas registradas',
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
                          dataRowColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.white,
                          ),
                          columnSpacing: 20,
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
                                'Fecha',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.pinkDark,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Cliente',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.pinkDark,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Total',
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
                          rows: orders.map((order) {
                            return DataRow(
                              cells: [
                                DataCell(Text('#${order.idVenta}')),
                                DataCell(Text(order.formattedDate)),
                                DataCell(
                                  Container(
                                    constraints: const BoxConstraints(
                                      maxWidth: 150,
                                    ),
                                    child: Text(
                                      order.clienteNombre,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    order.formattedTotal,
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
                                      color:
                                          order.estado.toLowerCase() ==
                                                  'completado' ||
                                              order.estado == '1'
                                          ? Colors.green.withValues(alpha: 0.1)
                                          : Colors.orange.withValues(
                                              alpha: 0.1,
                                            ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      order.estado,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            order.estado.toLowerCase() ==
                                                    'completado' ||
                                                order.estado == '1'
                                            ? Colors.green
                                            : Colors.orange,
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
                                          Icons.visibility_outlined,
                                          color: AppColors.pinkDark,
                                        ),
                                        onPressed: () =>
                                            _showOrderDetails(order.idVenta),
                                        tooltip: 'Ver Detalle',
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: AppColors.grey,
                                        ),
                                        onPressed: () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Funcionalidad en desarrollo',
                                              ),
                                            ),
                                          );
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
                  if (orderProvider.totalPages > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 16),
                            onPressed: orderProvider.currentPage > 1
                                ? () => orderProvider.fetchOrders(
                                    page: orderProvider.currentPage - 1,
                                  )
                                : null,
                          ),
                          Text(
                            'Página ${orderProvider.currentPage} de ${orderProvider.totalPages}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, size: 16),
                            onPressed:
                                orderProvider.currentPage <
                                    orderProvider.totalPages
                                ? () => orderProvider.fetchOrders(
                                    page: orderProvider.currentPage + 1,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
