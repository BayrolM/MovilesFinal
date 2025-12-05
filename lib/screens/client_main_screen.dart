import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import 'products/catalog_screen.dart';
import 'cart/cart_screen.dart';

/// Pantalla principal para clientes (sin sidebar)
class ClientMainScreen extends StatefulWidget {
  const ClientMainScreen({super.key});

  @override
  State<ClientMainScreen> createState() => _ClientMainScreenState();
}

class _ClientMainScreenState extends State<ClientMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const CatalogScreen(),
    const CartScreen(),
    const ProfileScreen(), // TODO: Crear pantalla de perfil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppColors.pinkDark,
        unselectedItemColor: AppColors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (context, cart, child) {
                return Badge(
                  label: Text('${cart.itemCount}'),
                  isLabelVisible: cart.itemCount > 0,
                  child: const Icon(Icons.shopping_cart),
                );
              },
            ),
            label: 'Carrito',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

/// Pantalla de perfil temporal
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: AppColors.pinkPrimary,
        foregroundColor: AppColors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.pinkLight,
              child: Icon(Icons.person, size: 50, color: AppColors.pinkDark),
            ),
          ),

          const SizedBox(height: 16),

          // Nombre
          if (auth.name != null)
            Center(
              child: Text(
                auth.name!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          const SizedBox(height: 8),

          // Rol
          if (auth.role != null)
            Center(
              child: Chip(
                label: Text(auth.role!.toUpperCase()),
                backgroundColor: AppColors.pinkLight,
              ),
            ),

          const SizedBox(height: 32),

          // Opciones
          Card(
            child: ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Mis Pedidos'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Navegar a historial de pedidos
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Historial de pedidos en desarrollo'),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          Card(
            child: ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Navegar a configuración
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Configuración en desarrollo')),
                );
              },
            ),
          ),

          const SizedBox(height: 32),

          // Botón Cerrar Sesión
          ElevatedButton.icon(
            onPressed: auth.loading
                ? null
                : () async {
                    await auth.logout();
                  },
            icon: const Icon(Icons.logout),
            label: const Text('CERRAR SESIÓN'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
