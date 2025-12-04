// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_user.dart';
import '../models/cart_item.dart';
import '../models/service.dart';
import '../models/order.dart';

class ApiService {
  // Asegúrate de que este puerto coincida con tu backend (8081)
  static const String baseUrl = "http://10.0.2.2:8081/api";

  // --- AUTH ---
  Future<AuthUser> loginOrRegisterWithGoogle({required String name, required String email}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login-or-register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email}),
      );

      if (response.statusCode == 200) {
        return AuthUser.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Error auth: ${response.body}');
      }
    } catch (e) {
      print('Error login: $e');
      throw Exception('No se pudo iniciar sesión.');
    }
  }

  Future<AuthUser> updateUserProfile({required int userId, required String name, required String lastname, required String phone, required String address}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'lastname': lastname, 'phone': phone, 'address': address}),
    );
    if (response.statusCode == 200) {
      return AuthUser.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Error updating profile');
    }
  }

  // --- SERVICIOS (Cliente) ---
  Future<List<Service>> fetchServices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/services'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((json) => Service.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar servicios');
      }
    } catch (e) {
      print('Error fetchServices: $e');
      throw Exception('Error de conexión.');
    }
  }

  Future<Service?> getServiceById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/services/$id'));
    if (response.statusCode == 200) {
      return Service.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    return null;
  }

  // --- GESTIÓN DE SERVICIOS (Proveedor - CRUD) ---
  Future<void> createService(Service service) async {
    await http.post(
      Uri.parse('$baseUrl/services'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(service.toJson()),
    );
  }

  Future<void> deleteService(int id) async {
    await http.delete(Uri.parse('$baseUrl/services/$id'));
  }

  // --- CARRITO ---
  Future<List<CartItem>> getCart(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/cart/$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => CartItem.fromJson(json)).toList();
    } else {
      throw Exception('Error loading cart');
    }
  }

  Future<void> addToCart({required int userId, required int serviceId, int quantity = 1}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'serviceId': serviceId, 'quantity': quantity}),
    );
    if (response.statusCode != 200) throw Exception('Error adding to cart');
  }

  Future<void> updateCartItem({required int userId, required int serviceId, required int quantity}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/cart/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'serviceId': serviceId, 'quantity': quantity}),
    );
    if (response.statusCode != 200) throw Exception('Error updating item');
  }

  Future<void> removeCartItem({required int userId, required int serviceId}) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cart/remove'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'serviceId': serviceId}),
    );
    if (response.statusCode != 200) throw Exception('Error removing item');
  }

  Future<void> clearCart(int userId) async {
    final response = await http.delete(Uri.parse('$baseUrl/cart/clear/$userId'));
    if (response.statusCode != 200) throw Exception('Error clearing cart');
  }

  // --- PEDIDOS (Cliente) ---
  Future<Order> checkout(int userId) async {
    final response = await http.post(Uri.parse('$baseUrl/orders/checkout/$userId'));
    if (response.statusCode == 200) {
      return Order.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Error checkout: ${response.statusCode}');
    }
  }

  Future<List<Order>> getOrders(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/orders/user/$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Error loading orders');
    }
  }

  // --- DASHBOARD (Proveedor - Nuevos Endpoints) ---

  // 1. Estadísticas para las tarjetas
  Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await http.get(Uri.parse('$baseUrl/dashboard/stats'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error loading stats');
    }
  }

  // 2. Obtener TODAS las órdenes para la pestaña Facturas
  Future<List<Order>> getAllOrders() async {
    final response = await http.get(Uri.parse('$baseUrl/orders/all'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Error loading all orders');
    }
  }

  // --- CHATBOT ---
  Future<void> triggerHelpBot(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/help/trigger'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );
      if (response.statusCode != 200) throw Exception('Error bot');
    } catch (e) {
      print('Error triggerHelpBot: $e');
      throw Exception('No se pudo solicitar ayuda.');
    }
  }
}