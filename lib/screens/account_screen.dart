import 'package:flutter/material.dart';
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
  bool _isSendingHelp = false; // Estado para el indicador de carga del robot

  @override
  void initState() {
    super.initState();
    // Auto-login trigger
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (!authProvider.isLoggedIn) {
        authProvider.signInWithGoogle();
      }
    });
  }

  // --- LÓGICA DEL BOTÓN DE AYUDA (ROBOT) ---
  Future<void> _handleHelpRequest(int userId) async {
    setState(() => _isSendingHelp = true);
    final api = context.read<ApiService>();

    try {
      await api.triggerHelpBot(userId); // Llama al backend -> n8n -> WhatsApp
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🤖 ¡Asistente activado! Te escribiremos a tu WhatsApp.'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al contactar asistente: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSendingHelp = false);
    }
  }

  // --- Formulario para editar perfil ---
  void _showEditProfileSheet(BuildContext context) {
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16, right: 16, top: 16,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Editar Perfil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Nombres', prefixIcon: Icon(Icons.person)),
                      validator: (v) => v!.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: lastnameCtrl,
                      decoration: const InputDecoration(labelText: 'Apellidos', prefixIcon: Icon(Icons.person_outline)),
                      validator: (v) => v!.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Celular', prefixIcon: Icon(Icons.phone)),
                      validator: (v) => v!.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: addressCtrl,
                      decoration: const InputDecoration(labelText: 'Dirección Principal', prefixIcon: Icon(Icons.home)),
                      validator: (v) => v!.isEmpty ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B35), foregroundColor: Colors.white),
                        onPressed: isSaving ? null : () async {
                          if (formKey.currentState!.validate()) {
                            setModalState(() => isSaving = true);
                            try {
                              await authProvider.updateProfile(
                                  nameCtrl.text, lastnameCtrl.text, phoneCtrl.text, addressCtrl.text
                              );
                              if (context.mounted) Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil actualizado')));
                            } catch (e) {
                              setModalState(() => isSaving = false);
                            }
                          }
                        },
                        child: isSaving ? const Text('Guardando...') : const Text('Guardar Cambios'),
                      ),
                    ),
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

    final String initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Cuenta'),
        automaticallyImplyLeading: false,
        // --- LOGOUT MOVIDO AQUÍ ---
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'Cerrar Sesión',
            onPressed: () async {
              await authProvider.logout();
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Header de Usuario
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: const Color(0xFFFF6B35),
                child: Text(initial, style: const TextStyle(fontSize: 24, color: Colors.white)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${user.name} ${user.lastname}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(user.email, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                    if (user.phone.isNotEmpty)
                      Text(user.phone, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // --- BOTONES DE ACCIÓN ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 1. Botón Pedidos
              _buildActionButton(context, Icons.receipt_long, 'Mis Pedidos', () {
                setState(() => _showOrders = !_showOrders);
              }),

              // 2. Botón Editar Perfil
              _buildActionButton(context, Icons.edit, 'Editar Perfil', () {
                _showEditProfileSheet(context);
              }),

              // 3. Botón AYUDA AI (Reemplaza a Cerrar Sesión)
              _isSendingHelp
                  ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                    width: 24, height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2)
                ),
              )
                  : _buildActionButton(
                context,
                Icons.smart_toy, // Icono de Robot
                'Ayuda AI',
                    () => _handleHelpRequest(user.id),
                iconColor: const Color(0xFFFF6B35), // Color destacado
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Sección de Pedidos
          if (_showOrders) _buildOrdersSection(context, user.id),
        ],
      ),
    );
  }

  // Método actualizado para aceptar iconColor opcional
  Widget _buildActionButton(BuildContext context, IconData icon, String label, VoidCallback onPressed, {Color iconColor = Colors.black87}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersSection(BuildContext context, int userId) {
    final apiService = context.read<ApiService>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Historial de Pedidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        FutureBuilder<List<Order>>(
          future: apiService.getOrders(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()));
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error al cargar historial', style: TextStyle(color: Colors.red[300])));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                child: const Row(children: [Icon(Icons.info_outline, color: Colors.grey), SizedBox(width: 12), Expanded(child: Text('Aún no has realizado ningún pedido.'))]),
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

                String serviceName = "Servicio desconocido";
                if (order.items.isNotEmpty) {
                  serviceName = order.items.first.service.name;
                  if (order.items.length > 1) {
                    serviceName += " y ${order.items.length - 1} más...";
                  }
                }

                return _buildOrderItem(
                  title: 'Pedido #${order.id}',
                  description: serviceName,
                  cantidad: '${order.items.length} servicio(s)',
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

  Widget _buildOrderItem({required String title, required String description, required String cantidad, required double price, required String date, String status = ''}) {
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
                if (status.isNotEmpty) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)), child: Text(statusText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor))),
              ],
            ),
            const SizedBox(height: 4),
            Text(description, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
            Text(cantidad, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Formatters.formatPrice(price), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF6B35), fontSize: 16)),
                Text(date, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}