import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/formatters.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    // --- VISTA PARA PROVEEDOR ---
    if (authProvider.authUser?.role == 'supplier') {
      return _buildSupplierView(context);
    }

    // --- VISTA PARA CLIENTE ---
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Carrito'),
        automaticallyImplyLeading: false,
      ),
      body: cartProvider.items.isEmpty
          ? _EmptyCart()
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final item = cartProvider.items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: item.service.image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            // --- CORRECCIÓN AQUÍ ---
                            errorWidget: (context, url, error) => const Icon(Icons.image, size: 80, color: Colors.grey),
                            // -----------------------
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.service.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                item.service.district,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                Formatters.formatPrice(item.service.price),
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6B35)),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () async {
                                    await cartProvider.updateQuantity(item.service.id!, item.quantity - 1);
                                  },
                                ),
                                Text('${item.quantity}'),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () async {
                                    await cartProvider.updateQuantity(item.service.id!, item.quantity + 1);
                                  },
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await cartProvider.removeItem(item.service.id!);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(Formatters.formatPrice(cartProvider.total), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF6B35))),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => context.push('/payment'),
                    child: const Text('Continuar con el pedido'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierView(BuildContext context) {
    const googleSheetUrl = "https://docs.google.com/spreadsheets/d/1M1zWNCpnEnq2nKA0MTnpmuqNDD8GBYZx-qBzwExOZ-A/edit?usp=sharing";

    return Scaffold(
      appBar: AppBar(title: const Text('Centro de Reportes'), automaticallyImplyLeading: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.table_view_rounded, size: 100, color: Color(0xFF1D6F42)),
              const SizedBox(height: 24),
              const Text('Gestión de Reportes', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                'Accede a la base de datos completa de ventas, filtra por fechas y exporta tus ganancias desde Google Sheets.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1D6F42), foregroundColor: Colors.white),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('ABRIR GOOGLE SHEETS'),
                  onPressed: () async {
                    final url = Uri.parse(googleSheetUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined, size: 80, color: Color(0xFFFF6B35)),
          const SizedBox(height: 16),
          const Text('Tu carrito está vacío', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Agrega servicios para organizar tu evento perfecto', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            child: const Text('Explorar servicios'),
          ),
        ],
      ),
    );
  }
}