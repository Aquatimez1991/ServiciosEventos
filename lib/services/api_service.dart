// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_user.dart';
import '../models/cart_item.dart';
import '../models/service.dart';

class ApiService {
  // USA ESTA URL PARA EL EMULADOR DE ANDROID
  static const String baseUrl = "http://10.0.2.2:8080/api";

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
  // CART ENDPOINTS
  // Se conecta con tu CartController
  // ============================================

  // Obtiene el carrito de un usuario
  Future<List<CartItem>> getCart(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/cart/${userId.toString()}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        // Aquí necesitarás una forma de convertir el JSON del CartItem del backend
        // a tu modelo CartItem de Flutter. Asumiré que tienes un factory fromJson.
        // return data.map((json) => CartItem.fromJson(json)).toList();

        // --- TEMPORAL: Devuelve lista vacía hasta que implementes CartItem.fromJson ---
        print('Carrito obtenido del backend, necesitas implementar CartItem.fromJson');
        return [];
      } else {
        throw Exception('Error al obtener el carrito: ${response.statusCode}');
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
  // ORDER ENDPOINTS
  // Se conecta con tu OrderController
  // ============================================

  Future<void> checkout(int userId) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/orders/checkout/${userId.toString()}'),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al procesar el pedido: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en checkout: $e');
      throw Exception('No se pudo procesar el pedido.');
    }
  }
}