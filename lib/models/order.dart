// lib/models/order.dart

class Order {
  final int id;
  final double totalSoles;
  final String status;
  final DateTime createdAt;

  // Constructor
  Order({
    required this.id,
    required this.totalSoles,
    required this.status,
    required this.createdAt,
  });

  /// Factory que convierte un JSON en un objeto Order.
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      totalSoles: (json['totalSoles'] as num).toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  /// Convierte un objeto Order a JSON (útil para enviar al backend).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalSoles': totalSoles,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}