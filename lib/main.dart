import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'providers/app_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/provider_provider.dart';
import 'screens/loader_screen.dart';
// import 'screens/login_screen.dart'; // Removida - autenticación automática con Google
import 'screens/register_customer_screen.dart';
import 'screens/register_provider_screen.dart';
import 'screens/home_screen.dart';
import 'screens/provider_detail_screen.dart';
import 'screens/cart_screen.dart';
// import 'screens/auth_info_screen.dart'; // Removida - información ya disponible desde Google
import 'screens/payment_screen.dart';
import 'screens/confirmation_screen.dart';
import 'screens/provider_dashboard_screen.dart';
import 'screens/add_service_screen.dart';
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
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProviderProvider()),
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

final GoRouter _router = GoRouter(
  initialLocation: '/loader',
  redirect: (context, state) {
    // Si se intenta acceder a una ruta que no existe, redirigir a home
    // Esto previene el error de stack vacío
    return null;
  },
  routes: [
    GoRoute(
      path: '/loader',
      builder: (context, state) => const LoaderScreen(),
    ),
    // Login screen removida - autenticación automática con Google
    // GoRoute(
    //   path: '/login',
    //   builder: (context, state) => const LoginScreen(),
    // ),
    GoRoute(
      path: '/register-customer',
      builder: (context, state) => const RegisterCustomerScreen(),
    ),
    GoRoute(
      path: '/register-provider',
      builder: (context, state) => const RegisterProviderScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/provider/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProviderDetailScreen(providerId: id);
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    // Auth-info screen removida - información ya disponible desde Google
    // GoRoute(
    //   path: '/auth-info',
    //   builder: (context, state) => const AuthInfoScreen(),
    // ),
    GoRoute(
      path: '/payment',
      builder: (context, state) => const PaymentScreen(),
    ),
    GoRoute(
      path: '/confirmation',
      builder: (context, state) => const ConfirmationScreen(),
    ),
    GoRoute(
      path: '/provider-dashboard',
      builder: (context, state) => const ProviderDashboardScreen(),
    ),
    GoRoute(
      path: '/add-service',
      builder: (context, state) => const AddServiceScreen(),
    ),
  ],
);

