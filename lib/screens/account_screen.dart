import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../models/order.dart';
import '../utils/formatters.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _showOrders = false;
  bool _isSendingHelp = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (!authProvider.isLoggedIn) {
        authProvider.signInWithGoogle();
      }
    });
  }

  // Lógica Bot (Solo Cliente)
  Future<void> _handleHelpRequest(int userId) async {
    setState(() => _isSendingHelp = true);
    final api = context.read<ApiService>();
    try {
      await api.triggerHelpBot(userId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('🤖 ¡Asistente activado! Te escribiremos a tu WhatsApp.'), backgroundColor: Colors.green)
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isSendingHelp = false);
    }
  }

  // Formulario de Edición (Híbrido)
  void _showEditProfileSheet(BuildContext context, bool isSupplier) {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.authUser!;
    final nameCtrl = TextEditingController(text: user.name);
    final lastnameCtrl = TextEditingController(text: user.lastname);
    final phoneCtrl = TextEditingController(text: user.phone);
    final addressCtrl = TextEditingController(text: user.address);
    final formKey = GlobalKey<FormState>();
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(isSupplier ? 'Configuración de Empresa' : 'Editar Perfil', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextFormField(controller: nameCtrl, decoration: InputDecoration(labelText: isSupplier ? 'Nombre de Empresa' : 'Nombres', prefixIcon: const Icon(Icons.store)), validator: (v) => v!.isEmpty ? 'Requerido' : null),
                    const SizedBox(height: 10),
                    if (!isSupplier) ...[
                      TextFormField(controller: lastnameCtrl, decoration: const InputDecoration(labelText: 'Apellidos', prefixIcon: Icon(Icons.person_outline)), validator: (v) => v!.isEmpty ? 'Requerido' : null),
                      const SizedBox(height: 10),
                    ],
                    TextFormField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Celular de Contacto', prefixIcon: Icon(Icons.phone)), validator: (v) => v!.isEmpty ? 'Requerido' : null),
                    const SizedBox(height: 10),
                    TextFormField(controller: addressCtrl, decoration: const InputDecoration(labelText: 'Dirección Principal', prefixIcon: Icon(Icons.location_on)), validator: (v) => v!.isEmpty ? 'Requerido' : null),
                    const SizedBox(height: 20),
                    SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B35), foregroundColor: Colors.white), onPressed: isSaving ? null : () async {
                      if (formKey.currentState!.validate()) {
                        setModalState(() => isSaving = true);
                        try {
                          await authProvider.updateProfile(nameCtrl.text, lastnameCtrl.text, phoneCtrl.text, addressCtrl.text);
                          if (context.mounted) Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Datos actualizados')));
                        } catch (e) {
                          setModalState(() => isSaving = false);
                        }
                      }
                    }, child: isSaving ? const Text('Guardando...') : const Text('Guardar Cambios'))),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.authUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mi Cuenta')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_circle_outlined, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Inicia sesión para ver tu perfil', style: TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B35), foregroundColor: Colors.white),
                icon: const Icon(Icons.login),
                label: const Text('Iniciar con Google'),
                onPressed: () => authProvider.signInWithGoogle(),
              ),
            ],
          ),
        ),
      );
    }

    final isSupplier = user.role == 'supplier';
    final String initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

    return Scaffold(
      appBar: AppBar(
        title: Text(isSupplier ? 'Mi Negocio' : 'Mi Cuenta'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.logout, color: Colors.red), onPressed: () async { await authProvider.logout(); })
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Row(
            children: [
              CircleAvatar(radius: 32, backgroundColor: const Color(0xFFFF6B35), child: Text(initial, style: const TextStyle(fontSize: 24, color: Colors.white))),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(user.email, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: isSupplier ? Colors.purple[100] : Colors.blue[100], borderRadius: BorderRadius.circular(4)),
                      child: Text(isSupplier ? 'PROVEEDOR' : 'CLIENTE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isSupplier ? Colors.purple : Colors.blue)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // --- BOTONES DE ACCIÓN ADAPTADOS ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (isSupplier)
                _buildActionButton(context, Icons.bar_chart, 'Reporte Ventas', () {
                  // NAVEGACIÓN A LA NUEVA PANTALLA
                  context.push('/sales-dashboard');
                })
              else
                _buildActionButton(context, Icons.receipt_long, 'Mis Pedidos', () { setState(() => _showOrders = !_showOrders); }),

              _buildActionButton(context, isSupplier ? Icons.store_mall_directory : Icons.edit, isSupplier ? 'Datos Empresa' : 'Editar Perfil', () {
                _showEditProfileSheet(context, isSupplier);
              }),

              if (isSupplier)
                _buildActionButton(context, Icons.support_agent, 'Soporte', () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contactando soporte...'))); })
              else
                _isSendingHelp
                    ? const Padding(padding: EdgeInsets.all(12), child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)))
                    : _buildActionButton(context, Icons.smart_toy, 'Ayuda AI', () => _handleHelpRequest(user.id), iconColor: const Color(0xFFFF6B35)),
            ],
          ),
          const SizedBox(height: 32),

          if (!isSupplier && _showOrders) _buildOrdersSection(context, user.id),

          if (isSupplier)
            const Card(
              color: Color(0xFFF3E5F5),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(children: [Icon(Icons.info_outline, color: Colors.purple), SizedBox(width: 12), Expanded(child: Text("Utiliza el 'Panel' y 'Reportes' en la barra inferior para gestionar tu negocio.", style: TextStyle(color: Colors.purple)))]),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, VoidCallback onPressed, {Color iconColor = Colors.black87}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle), child: Icon(icon, color: iconColor, size: 28)),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersSection(BuildContext context, int userId) {
    final api = context.read<ApiService>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Historial de Pedidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        FutureBuilder<List<Order>>(
          future: api.getOrders(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("No hay pedidos"));
            final orders = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final dateStr = order.createdAt.toString().split(' ')[0];
                String serviceName = "Servicio";
                if (order.items.isNotEmpty) serviceName = order.items.first.service.name;

                return _buildOrderItem(title: 'Pedido #${order.id}', description: serviceName, price: order.total, date: dateStr, status: order.status);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildOrderItem({required String title, required String description, required double price, required String date, String status = ''}) {
    final isPending = status == 'PENDING';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$description\n$date'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(Formatters.formatPrice(price), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6B35))),
            Text(isPending ? 'Pendiente' : 'Confirmado', style: TextStyle(color: isPending ? Colors.orange : Colors.green, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}