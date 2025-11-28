import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _showOrders = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuenta'),
        automaticallyImplyLeading: false, // Oculta el botón de retroceso
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- Sección de Perfil ---
          Row(
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundColor: Colors.grey,
                child: Text(
                  'ES',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Elias S.', // Placeholder
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Editar perfil >',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
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
                'Pedidos',
                    () {
                  setState(() {
                    _showOrders = !_showOrders;
                  });
                },
              ),
              _buildActionButton(context, Icons.help_outline, 'Ayuda', () {}),
              _buildActionButton(context, Icons.payment, 'Método de pago', () {}),
            ],
          ),
          const SizedBox(height: 32),

          // --- Sección de Pedidos (condicional) ---
          if (_showOrders) _buildOrdersSection(context),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.grey[200], // ✅ correcto
            elevation: 0,
          ),
          child: Icon(icon, color: Colors.black87, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildOrdersSection(BuildContext context) {
    // Placeholder para la lista de pedidos.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Últimos pedidos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // Ejemplo de pedidos
        _buildOrderItem(
          context: context,
          title: 'Decoración con Globos Premium',
          description: 'Arco de globos, centro de mesa y decoración completa.',
          price: 85000.0,
          date: '25 de Noviembre, 2023',
        ),
        _buildOrderItem(
          context: context,
          title: 'Torta Personalizada',
          description: 'Torta de 2 pisos con decoración temática.',
          price: 45000.0,
          date: '12 de Octubre, 2023',
        ),
      ],
    );
  }

  Widget _buildOrderItem({
    required BuildContext context,
    required String title,
    required String description,
    required double price,
    required String date,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(description, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'S/${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B35),
                  ),
                ),
                Text(date,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}