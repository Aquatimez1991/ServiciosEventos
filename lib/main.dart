import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// --- Imports de Providers y Servicios ---
import 'providers/app_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/service_provider.dart'; // CAMBIO: Usamos el nuevo ServiceProvider
import 'services/api_service.dart';

// --- Imports de Pantallas ---
import 'screens/loader_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/confirmation_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // NIVEL 1: Servicios base sin dependencias
        Provider<ApiService>(create: (_) => ApiService()),
        ChangeNotifierProvider(create: (_) => AppProvider()),

        // NIVEL 2: Providers que dependen de ApiService
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(context.read<ApiService>()),
        ),
        ChangeNotifierProvider<ServiceProvider>(
          create: (context) => ServiceProvider(context.read<ApiService>()),
        ),

        // NIVEL 3: Providers que dependen de otros Providers (como AuthProvider)
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (context) => CartProvider(
            context.read<AuthProvider>(),
            context.read<ApiService>(),
          ),
          update: (context, auth, previousCart) => CartProvider(
            auth,
            context.read<ApiService>(),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'PartyApp',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }
}

// El GoRouter ahora está limpio, con solo las rutas necesarias.
final GoRouter _router = GoRouter(
  initialLocation: '/loader',
  routes: [
    GoRoute(
      path: '/loader',
      builder: (context, state) => const LoaderScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) => const PaymentScreen(),
    ),
    GoRoute(
      path: '/confirmation',
      builder: (context, state) => const ConfirmationScreen(),
    ),
  ],
);