import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // Importa share_plus si lo agregaste
import '../models/order.dart';
import '../utils/formatters.dart';

class InvoiceDetailScreen extends StatelessWidget {
  final Order order;

  const InvoiceDetailScreen({super.key, required this.order});

  // Función para compartir texto (Lógica simple)
  void _shareInvoice(BuildContext context) {
    final String text =
        "Factura #${order.id}\n"
        "Cliente: ${order.user?.name ?? 'Cliente'}\n"
        "Fecha: ${Formatters.formatDate(order.createdAt)}\n"
        "Total: ${Formatters.formatPrice(order.total)}\n"
        "Estado: ${order.status}";

    // Si tienes share_plus instalado:
    Share.share(text, subject: 'Factura de Pedido #${order.id}');

    // Si NO lo tienes instalado aún, usa esto temporalmente:
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Compartiendo...')));
  }

  // Función para imprimir (Placeholder)
  void _printInvoice(BuildContext context) {
    // Aquí iría la lógica con el paquete 'printing' y 'pdf'
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generando PDF para imprimir...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = order.total / 1.18;
    final igv = order.total - subtotal;

    return Scaffold(
      appBar: AppBar(
        title: Text('Factura #${order.id}'),
        actions: [
          // Opción extra en la barra superior (opcional)
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareInvoice(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- CABECERA ---
            Center(
              child: Column(
                children: [
                  const Icon(Icons.store_mall_directory, size: 60, color: Colors.grey),
                  const SizedBox(height: 8),
                  const Text('PartyApp S.A.C.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text('RUC: 20555555551', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text('Fecha de Emisión: ${Formatters.formatDate(order.createdAt)}'),
                ],
              ),
            ),
            const Divider(height: 40, thickness: 1),

            // --- DATOS CLIENTE ---
            const Text('CLIENTE:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            Text(order.user?.name ?? 'Cliente Genérico', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),

            // --- DETALLE ---
            const Text('DETALLE:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            ...order.items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text('${item.service.name} (x${item.quantity})', style: const TextStyle(fontSize: 15)),
                  ),
                  Text(
                      Formatters.formatPrice(item.price * item.quantity),
                      style: const TextStyle(fontWeight: FontWeight.w500)
                  ),
                ],
              ),
            )),

            const Divider(height: 32),

            // --- TOTALES ---
            _buildTotalRow('Subtotal', subtotal),
            _buildTotalRow('IGV (18%)', igv),
            const SizedBox(height: 8),
            _buildTotalRow('TOTAL A PAGAR', order.total, isTotal: true),

            const SizedBox(height: 32),

            // ==========================================
            // NUEVOS BOTONES (Imprimir / Compartir)
            // ==========================================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botón Imprimir
                OutlinedButton.icon(
                  onPressed: () => _printInvoice(context),
                  icon: const Icon(Icons.print, color: Colors.black87),
                  label: const Text("Imprimir", style: TextStyle(color: Colors.black87)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),

                const SizedBox(width: 16), // Espacio entre botones

                // Botón Compartir
                ElevatedButton.icon(
                  onPressed: () => _shareInvoice(context),
                  icon: const Icon(Icons.share, size: 20),
                  label: const Text("Compartir"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
            // ==========================================

            const SizedBox(height: 40),

            // --- ESTADO ---
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: order.status == 'PENDING' ? Colors.orange : Colors.green,
                      width: 2
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status == 'PENDING' ? 'PENDIENTE' : 'PAGADO',
                  style: TextStyle(
                    color: order.status == 'PENDING' ? Colors.orange : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 18 : 14)),
          Text(Formatters.formatPrice(amount), style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 18 : 14)),
        ],
      ),
    );
  }
}