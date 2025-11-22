import 'service.dart';

class CartItem {
  final Service service;
  final int quantity;
  final String providerId;
  final String providerName;

  CartItem({
    required this.service,
    required this.quantity,
    required this.providerId,
    required this.providerName,
  });

  double get total => service.price * quantity;

  CartItem copyWith({
    Service? service,
    int? quantity,
    String? providerId,
    String? providerName,
  }) {
    return CartItem(
      service: service ?? this.service,
      quantity: quantity ?? this.quantity,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
    );
  }
}

