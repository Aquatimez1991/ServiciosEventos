// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_user.dart';
import '../models/cart_item.dart';
import '../models/service.dart';
import '../models/order.dart';


class ApiService {
  // USA ESTA URL PARA EL EMULADOR DE ANDROID
  static const String baseUrl = "http://10.0.2.2:8081/api";

  // ============================================
  // NUEVO MÉTODO
  Future<AuthUser> loginOrRegisterWithGoogle({
    required String name,
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login-or-register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email}),
      );

      if (response.statusCode == 200) {
        // El backend devuelve el usuario de la BD, lo convertimos a nuestro AuthUser
        return AuthUser.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Error al sincronizar con el backend: ${response.body}');
      }
    } catch (e) {
      print('Error en loginOrRegisterWithGoogle: $e');
      throw Exception('No se pudo comunicar con el servidor para iniciar sesión.');
    }
  }
  // ============================================

  // Obtiene la lista plana de todos los servicios
  Future<List<Service>> fetchServices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/services'));

      if (response.statusCode == 200) {
        // La respuesta del backend es UTF-8, decodifiquemos correctamente
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((json) => Service.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar los servicios: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en fetchServices: $e');
      throw Exception('No se pudieron obtener los servicios. Revisa tu conexión.');
    }
  }

  // Obtiene un servicio específico por su ID
  Future<Service?> getServiceById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/services/${id.toString()}'));

      if (response.statusCode == 200) {
        return Service.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Error al obtener el servicio: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en getServiceById: $e');
      throw Exception('No se pudo obtener el servicio.');
    }
  }

  // ============================================
  Future<void> updateCartItem({
    required int userId,
    required int serviceId,
    required int quantity,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/cart/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'serviceId': serviceId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar item');
    }
  }
  Future<void> removeCartItem({
    required int userId,
    required int serviceId,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cart/remove'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'serviceId': serviceId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar item');
    }
  }

  // ============================================


  /// Obtiene el carrito de un usuario desde el backend.
  Future<List<CartItem>> getCart(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cart/${userId.toString()}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data =
        jsonDecode(utf8.decode(response.bodyBytes));

        // CAMBIO: Ahora usamos el factory fromJson para convertir cada item.
        return data.map((json) => CartItem.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error al obtener el carrito: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error en getCart: $e');
      throw Exception('No se pudo obtener el carrito.');
    }
  }


  // Agrega un item al carrito
  Future<void> addToCart({required int userId, required int serviceId, int quantity = 1}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cart/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'serviceId': serviceId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode != 200) { // O 201 si tu API devuelve CREATED
        throw Exception('Error al agregar al carrito: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en addToCart: $e');
      throw Exception('No se pudo agregar el servicio al carrito.');
    }
  }

  // Limpia el carrito de un usuario
  Future<void> clearCart(int userId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/cart/clear/${userId.toString()}'));

      if (response.statusCode != 200) {
        throw Exception('Error al limpiar el carrito: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en clearCart: $e');
      throw Exception('No se pudo limpiar el carrito.');
    }
  }

  // ============================================
  // --- HISTORIAL DE PEDIDOS ---

  Future<List<Order>> getOrders(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders/user/${userId.toString()}'),
      );

      if (response.statusCode == 200) {
        // Decodificamos la lista JSON
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        // Convertimos cada elemento JSON en un objeto Order
        return data.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar pedidos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en getOrders: $e');
      throw Exception('No se pudo obtener el historial de pedidos.');
    }
  }
  // ============================================

  Future<Order> checkout(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders/checkout/${userId.toString()}'),
      );

      if (response.statusCode == 200) {
        // Decodificamos la respuesta y convertimos a Order usando el factory.
        return Order.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)),
        );
      } else {
        throw Exception(
          'Error al procesar el pedido: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error en checkout: $e');
      throw Exception('No se pudo procesar el pedido.');
    }
  }

  // Actualizar perfil de usuario
  Future<AuthUser> updateUserProfile({
    required int userId,
    required String name,
    required String lastname,
    required String phone,
    required String address,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/$userId'), // Asume que tienes este endpoint en Spring Boot
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'lastname': lastname,
          'phone': phone,
          'address': address,
        }),
      );

      if (response.statusCode == 200) {
        return AuthUser.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Error al actualizar perfil: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión al actualizar perfil');
    }
  }

  // --- AYUDA / CHATBOT ---
  Future<void> triggerHelpBot(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/help/trigger'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al conectar con el asistente.');
      }
    } catch (e) {
      print('Error triggerHelpBot: $e');
      throw Exception('No se pudo solicitar ayuda.');
    }
  }

}