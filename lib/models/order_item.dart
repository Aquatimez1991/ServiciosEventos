// lib/models/order_item.dart
import 'service.dart';

class OrderItem {
  final int id;
  final Service service;
  final double price;
  final int quantity;

  OrderItem({
    required this.id,
    required this.service,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      // El backend envía el objeto "service" completo dentro del item
      service: Service.fromJson(json['service']),
      // Mapeamos 'priceSoles' del backend a 'price'
      price: (json['priceSoles'] as num).toDouble(),
      quantity: json['quantity'],
    );
  }
}