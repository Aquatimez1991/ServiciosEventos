import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// --- Imports de Providers y Servicios ---
import 'providers/app_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/service_provider.dart';
import 'services/api_service.dart';

// --- Imports de Pantallas ---
import 'screens/loader_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/account_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/confirmation_screen.dart';
import 'screens/service_list_screen.dart';
import 'screens/shell_scaffold.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(context.read<ApiService>()),
        ),
        ChangeNotifierProvider<ServiceProvider>(
          create: (context) => ServiceProvider(context.read<ApiService>()),
        ),
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

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/loader',
      builder: (context, state) => const LoaderScreen(),
    ),
    
    // --- Rutas DENTRO del Shell (con barra de navegación) ---
    // CORRECCIÓN: Usamos StatefulShellRoute.indexedStack
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // El builder nos da el navigationShell, que pasamos a nuestro scaffold personalizado
        return ShellScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Rama 0: Inicio
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Rama 1: Carrito
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cart',
              builder: (context, state) => const CartScreen(),
            ),
          ],
        ),
        // Rama 2: Cuenta
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/account',
              builder: (context, state) => const AccountScreen(),
            ),
          ],
        ),
      ],
    ),

    // --- Rutas que se abren ENCIMA del Shell ---
    GoRoute(
      path: '/payment',
       parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PaymentScreen(),
    ),
    GoRoute(
      path: '/confirmation',
       parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ConfirmationScreen(),
    ),
    GoRoute(
      path: '/category/:categoryId',
       parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final categoryId = state.pathParameters['categoryId'];
        if (categoryId == null) {
          return const Scaffold(
              body: Center(child: Text('Error: Categoría no encontrada')));
        }
        return ServiceListScreen(categoryId: categoryId);
      },
    ),
  ],
);