import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sidebarx/sidebarx.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'products/catalog_screen.dart';

/// Pantalla principal para administradores (con sidebar)
class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          SidebarX(
            controller: _controller,
            theme: SidebarXTheme(
              decoration: BoxDecoration(color: AppColors.pinkPrimary),
              textStyle: const TextStyle(color: AppColors.white),
              selectedTextStyle: const TextStyle(color: AppColors.white),
              itemDecoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
              ),
              selectedItemDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.pinkDark,
              ),
              iconTheme: const IconThemeData(color: AppColors.white, size: 20),
            ),
            extendedTheme: const SidebarXTheme(width: 220),
            headerBuilder: (context, extended) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.color_lens,
                      size: extended ? 50 : 30,
                      color: AppColors.white,
                    ),
                    if (extended) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Makeup Base',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Panel Admin',
                        style: TextStyle(color: AppColors.white, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              );
            },
            items: const [
              SidebarXItem(icon: Icons.dashboard, label: 'Dashboard'),
              SidebarXItem(icon: Icons.inventory, label: 'Productos'),
              SidebarXItem(icon: Icons.shopping_cart, label: 'Ventas'),
              SidebarXItem(icon: Icons.people, label: 'Clientes'),
              SidebarXItem(icon: Icons.category, label: 'Categorías'),
              SidebarXItem(icon: Icons.receipt_long, label: 'Pedidos'),
              SidebarXItem(icon: Icons.store, label: 'Proveedores'),
              SidebarXItem(icon: Icons.shopping_bag, label: 'Compras'),
            ],
          ),

          // Contenido principal
          Expanded(
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (auth.name != null)
                          Text(
                            'Hola, ${auth.name!}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        if (auth.role != null) ...[
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(
                              auth.role!.toUpperCase(),
                              style: const TextStyle(fontSize: 10),
                            ),
                            backgroundColor: AppColors.pinkLight,
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                        const SizedBox(width: 16),
                        IconButton(
                          tooltip: 'Cerrar sesión',
                          onPressed: auth.loading
                              ? null
                              : () async {
                                  await auth.logout();
                                },
                          icon: const Icon(Icons.logout),
                          color: AppColors.pinkDark,
                        ),
                      ],
                    ),
                  ),

                  // Contenido
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return _getScreenForIndex(_controller.selectedIndex);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const CatalogScreen(); // Productos
      case 2:
        return const SalesScreen(); // Ventas
      case 3:
        return const ClientsScreen(); // Clientes
      case 4:
        return const CategoriesScreen(); // Categorías
      case 5:
        return const OrdersScreen(); // Pedidos
      case 6:
        return const SuppliersScreen(); // Proveedores
      case 7:
        return const PurchasesScreen(); // Compras
      default:
        return const DashboardScreen();
    }
  }
}

// ============================================================================
// PANTALLAS TEMPORALES (TODO: Implementar cada una)
// ============================================================================

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard, size: 80, color: AppColors.pinkDark),
            const SizedBox(height: 16),
            const Text(
              'Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Pantalla en desarrollo'),
          ],
        ),
      ),
    );
  }
}

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart, size: 80, color: AppColors.pinkDark),
            const SizedBox(height: 16),
            const Text(
              'Ventas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Pantalla en desarrollo'),
          ],
        ),
      ),
    );
  }
}

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, size: 80, color: AppColors.pinkDark),
            const SizedBox(height: 16),
            const Text(
              'Clientes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Pantalla en desarrollo'),
          ],
        ),
      ),
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category, size: 80, color: AppColors.pinkDark),
            const SizedBox(height: 16),
            const Text(
              'Categorías',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Pantalla en desarrollo'),
          ],
        ),
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 80, color: AppColors.pinkDark),
            const SizedBox(height: 16),
            const Text(
              'Pedidos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Pantalla en desarrollo'),
          ],
        ),
      ),
    );
  }
}

class SuppliersScreen extends StatelessWidget {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store, size: 80, color: AppColors.pinkDark),
            const SizedBox(height: 16),
            const Text(
              'Proveedores',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Pantalla en desarrollo'),
          ],
        ),
      ),
    );
  }
}

class PurchasesScreen extends StatelessWidget {
  const PurchasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag, size: 80, color: AppColors.pinkDark),
            const SizedBox(height: 16),
            const Text(
              'Compras',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Pantalla en desarrollo'),
          ],
        ),
      ),
    );
  }
}
