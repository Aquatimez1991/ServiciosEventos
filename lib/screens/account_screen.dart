import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart'; // Necesario para llamar al backend
import '../models/order.dart';         // Necesario para el modelo Order
import '../utils/formatters.dart';     // Para formatear precios

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _showOrders = false;

  // --- NUEVO: TRIGGER AUTOMÁTICO ---
  @override
  void initState() {
    super.initState();
    // Ejecutamos esto después de que se dibuje el primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      // Si NO está logueado al entrar a esta pantalla, lanzamos el popup de Google
      if (!authProvider.isLoggedIn) {
        authProvider.signInWithGoogle();
      }
    });
  }
  // --------------------------------

  @override
  Widget build(BuildContext context) {
    // 1. Escuchamos al AuthProvider para obtener el usuario actual
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.authUser;

    // --- ESTADO NO LOGUEADO (Fallback) ---
    // Si el usuario cancela el login automático, verá esta pantalla con el botón
    // para intentarlo de nuevo manualmente.
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mi Cuenta')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_circle_outlined, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Inicia sesión para ver tu perfil',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    }

    // --- ESTADO LOGUEADO (Tu código original) ---
    // Lógica para obtener las iniciales del nombre
    final String initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Cuenta'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- Sección de Perfil ---
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: const Color(0xFFFF6B35),
                child: Text(
                  initial,
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.email,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rol: ${user.role == "customer" ? "Cliente" : "Proveedor"}',
                      style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // --- Botones de Acción ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(
                context,
                Icons.receipt_long,
                'Mis Pedidos',
                    () {
                  setState(() {
                    _showOrders = !_showOrders;
                  });
                },
              ),
              _buildActionButton(context, Icons.help_outline, 'Ayuda', () {}),
              _buildActionButton(
                context,
                Icons.logout,
                'Cerrar Sesión',
                    () async {
                  await authProvider.logout();
                  // Al hacer logout, la UI se reconstruye y muestra la pantalla de "No logueado"
                  // NO lanzamos el login automático aquí para evitar un bucle infinito
                },
              ),
            ],
          ),
          const SizedBox(height: 32),

          // --- Sección de Pedidos ---
          if (_showOrders) _buildOrdersSection(context, user.id),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.black87, size: 28),
            ),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  // INTEGRACIÓN DEL BACKEND
  Widget _buildOrdersSection(BuildContext context, int userId) {
    final apiService = context.read<ApiService>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Historial de Pedidos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        FutureBuilder<List<Order>>(
          future: apiService.getOrders(userId),
          builder: (context, snapshot) {
            // 1. Cargando
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ));
            }

            // 2. Error
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error al cargar historial.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red[300]),
                  ),
                ),
              );
            }

            // 3. Sin datos
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey),
                    SizedBox(width: 12),
                    Expanded(child: Text('Aún no has realizado ningún pedido.')),
                  ],
                ),
              );
            }

            final orders = snapshot.data!;

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                final dateStr = order.createdAt.toString().split(' ')[0];

                // CORRECCIÓN AQUÍ: Obtenemos el nombre del primer servicio de la lista de items
                String serviceName = "Servicio desconocido";
                if (order.items.isNotEmpty) {
                  // Tomamos el nombre del servicio del primer item
                  serviceName = order.items.first.service.name;

                  // Si hay más de uno, podemos agregar "+ X más"
                  if (order.items.length > 1) {
                    serviceName += " y ${order.items.length - 1} más...";
                  }
                }

                return _buildOrderItem(
                  title: 'Pedido #${order.id}',
                  description: serviceName, // Usamos el nombre real extraído
                  cantidad: '${order.items.length} servicio(s)', // Cantidad de items
                  price: order.total,
                  date: dateStr,
                  status: order.status,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildOrderItem({
    required String title,
    required String description,
    required String cantidad,
    required double price,
    required String date,
    String status = '',
  }) {
    final isPending = status == 'PENDING';
    final statusColor = isPending ? Colors.orange[800] : Colors.green[800];
    final statusBg = isPending ? Colors.orange[100] : Colors.green[100];
    final statusText = isPending ? 'Pendiente' : 'Confirmado';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                if (status.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(cantidad, style: TextStyle(color: Colors.grey[600])),
            Text(description, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Formatters.formatPrice(price),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B35),
                    fontSize: 16,
                  ),
                ),
                Text(date, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}