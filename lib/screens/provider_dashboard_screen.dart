import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../models/service.dart';
import '../models/order.dart';
import '../utils/formatters.dart';
import 'invoice_detail_screen.dart';

class ProviderDashboardScreen extends StatefulWidget {
  const ProviderDashboardScreen({super.key});

  @override
  State<ProviderDashboardScreen> createState() => _ProviderDashboardScreenState();
}

class _ProviderDashboardScreenState extends State<ProviderDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().authUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, ${user?.name ?? 'Proveedor'} 👋'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFFF6B35),
          labelColor: const Color(0xFFFF6B35),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.analytics), text: 'Resumen'),
            Tab(icon: Icon(Icons.list_alt), text: 'Servicios'),
            Tab(icon: Icon(Icons.receipt), text: 'Facturas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _StatsTab(),
          _ServicesTab(),
          _InvoicesTab(),
        ],
      ),
    );
  }
}

class _StatsTab extends StatelessWidget {
  const _StatsTab();
  final String _googleSheetUrl = "https://docs.google.com/spreadsheets/d/1M1zWNCpnEnq2nKA0MTnpmuqNDD8GBYZx-qBzwExOZ-A/edit?usp=sharing";

  @override
  Widget build(BuildContext context) {
    final api = context.read<ApiService>();
    return FutureBuilder<Map<String, dynamic>>(
      future: api.getDashboardStats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
        final stats = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildStatCard('Ingresos Totales', 'S/ ${stats['totalIncome']}', Icons.attach_money, Colors.green),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _buildStatCard('Pedidos', '${stats['totalOrders']}', Icons.shopping_bag, Colors.blue)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Servicios Activos', '${stats['activeServices']}', Icons.star, Colors.orange)),
            ]),
            const SizedBox(height: 32),
            const Text('Reportes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              color: const Color(0xFFE8F5E9),
              child: ListTile(
                leading: const Icon(Icons.table_view, color: Color(0xFF1D6F42), size: 32),
                title: const Text('Ver Reporte Detallado en Vivo'),
                subtitle: const Text('Abre Google Sheets para filtrar por fechas.'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () async {
                  final url = Uri.parse(_googleSheetUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}

class _ServicesTab extends StatefulWidget {
  const _ServicesTab();
  @override
  State<_ServicesTab> createState() => _ServicesTabState();
}

class _ServicesTabState extends State<_ServicesTab> {
  @override
  Widget build(BuildContext context) {
    final api = context.read<ApiService>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF6B35),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {},
      ),
      body: FutureBuilder<List<Service>>(
        future: api.fetchServices(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final services = snapshot.data!;
          return ListView.builder(
            itemCount: services.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final service = services[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: ClipRRect(borderRadius: BorderRadius.circular(4), child: Image.network(service.image, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.image))),
                  title: Text(service.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(Formatters.formatPrice(service.price)),
                  trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () async { await api.deleteService(service.id!); setState(() {}); }),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _InvoicesTab extends StatelessWidget {
  const _InvoicesTab();
  @override
  Widget build(BuildContext context) {
    final api = context.read<ApiService>();
    return FutureBuilder<List<Order>>(
      future: api.getAllOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("No hay pedidos"));
        final orders = snapshot.data!;
        return ListView.builder(
          itemCount: orders.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.grey[200], child: const Icon(Icons.receipt, color: Colors.black87)),
                title: Text('Pedido #${order.id} - ${order.user?.name ?? "Cliente"}'),
                subtitle: Text('${Formatters.formatDate(order.createdAt)} • ${order.status}'),
                trailing: Text(Formatters.formatPrice(order.total), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6B35))),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InvoiceDetailScreen(order: order))),
              ),
            );
          },
        );
      },
    );
  }
}