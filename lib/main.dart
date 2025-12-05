import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/admin_main_screen.dart';
import 'screens/client_main_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Makeup Base - E-commerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.pinkPrimary,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.greyLight,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.pinkPrimary,
          primary: AppColors.pinkPrimary,
          secondary: AppColors.pinkDark,
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

/// Widget que decide qué mostrar según autenticación y rol
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Verificar si hay sesión guardada al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      auth.checkAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    // Si está cargando, muestra indicador
    if (auth.loading && !auth.authenticated) {
      return Scaffold(
        backgroundColor: AppColors.greyLight,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.pinkLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.color_lens,
                  size: 60,
                  color: AppColors.pinkDark,
                ),
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.pinkDark),
              ),
              const SizedBox(height: 16),
              const Text(
                'Cargando...',
                style: TextStyle(color: AppColors.greyDark, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // Si no está autenticado, muestra login
    if (!auth.authenticated) {
      return const LoginScreen();
    }

    // Si está autenticado, redirige según el rol
    if (auth.role == 'admin') {
      return const AdminMainScreen();
    } else {
      // Para clientes y cualquier otro rol
      return const ClientMainScreen();
    }
  }
}
