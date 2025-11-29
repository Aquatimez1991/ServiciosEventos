import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/order.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/formatters.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedPaymentMethod = 'credit';
  bool _isProcessing = false;

  late TextEditingController _nameController;
  late TextEditingController _lastnameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().authUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _lastnameController = TextEditingController(text: user?.lastname ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usamos watch solo para dibujar la UI (totales, items)
    final cartProvider = context.watch<CartProvider>();

    bool isFormFilled = _nameController.text.isNotEmpty &&
        _lastnameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _addressController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completar Pedido'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/cart'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          onChanged: () => setState(() {}),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Datos de Contacto y Entrega',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(labelText: 'Nombres *'),
                              validator: (v) => v!.isEmpty ? 'Requerido' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _lastnameController,
                              decoration: const InputDecoration(labelText: 'Apellidos *'),
                              validator: (v) => v!.isEmpty ? 'Requerido' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Celular *',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (v) => v!.isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Dirección del Evento *',
                          prefixIcon: Icon(Icons.location_on),
                          hintText: 'Av. Principal 123, Distrito...',
                        ),
                        validator: (v) => v!.isEmpty ? 'Requerido' : null,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Opacity(
                opacity: isFormFilled ? 1.0 : 0.5,
                child: IgnorePointer(
                  ignoring: !isFormFilled,
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Resumen', style: TextStyle(fontWeight: FontWeight.bold)),
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total a pagar:', style: TextStyle(fontSize: 16)),
                                  Text(
                                    Formatters.formatPrice(cartProvider.total),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF6B35),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Método de Pago',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: Column(
                          children: [
                            RadioListTile<String>(
                              title: const Text('Tarjeta de Crédito/Débito'),
                              secondary: const Icon(Icons.credit_card),
                              value: 'credit',
                              groupValue: _selectedPaymentMethod,
                              onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
                            ),
                            RadioListTile<String>(
                              title: const Text('Pago en Efectivo'),
                              secondary: const Icon(Icons.money),
                              value: 'cash',
                              groupValue: _selectedPaymentMethod,
                              onChanged: (v) => setState(() => _selectedPaymentMethod = v!),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _isProcessing ? null : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _isProcessing = true);
                              try {
                                // 1. Actualizar perfil
                                // Esto dispara la destrucción del CartProvider viejo
                                await context.read<AuthProvider>().updateProfile(
                                  _nameController.text,
                                  _lastnameController.text,
                                  _phoneController.text,
                                  _addressController.text,
                                );

                                if (!context.mounted) return;

                                // 2. ESPERA TÉCNICA (SOLUCIÓN AL ERROR)
                                // Damos 200ms para que el ProxyProvider termine de intercambiar
                                // la instancia vieja por la nueva.
                                await Future.delayed(const Duration(milliseconds: 200));

                                if (!context.mounted) return;

                                // 3. OBTENER NUEVA INSTANCIA
                                // Usamos Provider.of(listen: false) para obtener el objeto VIVO
                                final cartVivo = Provider.of<CartProvider>(context, listen: false);

                                // 4. Checkout con la instancia correcta
                                final Order newOrder = await cartVivo.checkout();

                                if (context.mounted) {
                                  context.go('/confirmation', extra: newOrder);
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                if (mounted) setState(() => _isProcessing = false);
                              }
                            }
                          },
                          child: _isProcessing
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('CONFIRMAR PEDIDO', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}