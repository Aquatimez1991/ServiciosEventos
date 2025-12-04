// lib/models/order.dart

import 'order_item.dart';
import 'auth_user.dart';

class Order {
  final int id;
  final double total;
  final String status;
  final DateTime createdAt;
  final List<OrderItem> items;
  final AuthUser? user;

  Order({
    required this.id,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.items,
    this.user,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List? ?? [];
    List<OrderItem> itemsList = list.map((i) => OrderItem.fromJson(i)).toList();

    return Order(
      id: json['id'],
      // Mapeamos 'totalSoles' del backend a 'total'
      total: (json['totalSoles'] as num).toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      items: itemsList,
      // 2. Mapeamos el usuario si viene en el JSON
      user: json['user'] != null ? AuthUser.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalSoles': total,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}