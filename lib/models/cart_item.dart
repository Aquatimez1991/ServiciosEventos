// lib/models/cart_item.dart

import 'service.dart'; // Necesitamos el modelo Service para el item anidado

class CartItem {
  final int id;
  final Service service; // Un CartItem contiene un objeto Service completo
  final int quantity;

  // Constructor
  CartItem({
    required this.id,
    required this.service,
    required this.quantity,
  });

  // El total se puede calcular en el frontend
  double get total => service.price * quantity;

  /// ¡LA CLAVE!
  /// Este factory sabe cómo "leer" el JSON que viene de tu backend.
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      // El JSON del backend incluye un objeto 'service' anidado.
      // Usamos Service.fromJson para convertir ese objeto también.
      service: Service.fromJson(json['service']),
      quantity: json['quantity'],
    );
  }
}