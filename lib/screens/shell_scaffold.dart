import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ShellScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ShellScaffold({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    // Detectamos si es proveedor para cambiar el menú
    final isSupplier = authProvider.authUser?.role == 'supplier';

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        indicatorColor: const Color(0xFFFF6B35).withOpacity(0.2),
        // MENÚ DINÁMICO
        destinations: isSupplier
            ? const [
          // --- MENÚ PROVEEDOR ---
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Color(0xFFFF6B35)),
            label: 'Panel',
          ),
          NavigationDestination(
            // Reutilizamos la posición del carrito para "Reportes"
            icon: Icon(Icons.table_chart_outlined),
            selectedIcon: Icon(Icons.table_chart, color: Color(0xFFFF6B35)),
            label: 'Reportes',
          ),
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            selectedIcon: Icon(Icons.store, color: Color(0xFFFF6B35)),
            label: 'Mi Negocio', // Reemplaza a "Cuenta"
          ),
        ]
            : const [
          // --- MENÚ CLIENTE ---
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Color(0xFFFF6B35)),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart, color: Color(0xFFFF6B35)),
            label: 'Carrito',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFFFF6B35)),
            label: 'Cuenta',
          ),
        ],
      ),
    );
  }
}