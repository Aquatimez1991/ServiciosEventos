// TODO: Integrar con backend
// Este servicio contiene los métodos comentados para integración con el backend
// Descomentar y configurar cuando el backend esté listo

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_user.dart';
import '../models/provider_model.dart';
import '../models/service.dart';
import '../models/cart_item.dart';
import '../models/user.dart';

class ApiService {
  // TODO: Configurar la URL base del backend
  static const String baseUrl = 'https://api.partyapp.com'; // Cambiar por la URL real

  // ============================================
  // AUTH ENDPOINTS
  // ============================================

  /*
  /// Login de usuario
  /// POST /api/auth/login
  /// Body: { "username": string, "password": string, "role": "customer" | "provider" }
  /// Returns: AuthUser
  */
  Future<AuthUser?> login(String username, String password, String role) async {
    // TODO: Descomentar cuando el backend esté listo
    /*
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 200) {
        return AuthUser.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Error en login: $e');
      return null;
    }
    */
    return null; // Mock por ahora
  }

  /*
  /// Registro de cliente
  /// POST /api/auth/register/customer
  /// Body: { "username": string, "password": string, "name": string, "email": string, "phone": string, "address": string }
  /// Returns: AuthUser
  */
  Future<AuthUser?> registerCustomer({
    required String username,
    required String password,
    required String name,
    required String email,
    required String phone,
    required String address,
  }) async {
    // TODO: Descomentar cuando el backend esté listo
    /*
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register/customer'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'name': name,
          'email': email,
          'phone': phone,
          'address': address,
        }),
      );

      if (response.statusCode == 201) {
        return AuthUser.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Error en registro cliente: $e');
      return null;
    }
    */
    return null; // Mock por ahora
  }

  /*
  /// Registro de proveedor
  /// POST /api/auth/register/provider
  /// Body: { "username": string, "password": string, "name": string, "email": string, "phone": string, "businessName": string, "location": string, "description": string }
  /// Returns: AuthUser
  */
  Future<AuthUser?> registerProvider({
    required String username,
    required String password,
    required String name,
    required String email,
    required String phone,
    required String businessName,
    required String location,
    required String description,
  }) async {
    // TODO: Descomentar cuando el backend esté listo
    /*
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register/provider'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'name': name,
          'email': email,
          'phone': phone,
          'businessName': businessName,
          'location': location,
          'description': description,
        }),
      );

      if (response.statusCode == 201) {
        return AuthUser.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Error en registro proveedor: $e');
      return null;
    }
    */
    return null; // Mock por ahora
  }

  // ============================================
  // PROVIDER ENDPOINTS
  // ============================================

  /*
  /// Obtener todos los proveedores
  /// GET /api/providers
  /// Query params: ?category=string&search=string
  /// Returns: List<ProviderModel>
  */
  Future<List<ProviderModel>> getProviders({
    String? category,
    String? search,
  }) async {
    // TODO: Descomentar cuando el backend esté listo
    /*
    try {
      String url = '$baseUrl/api/providers';
      if (category != null && category.isNotEmpty) {
        url += '?category=$category';
      }
      if (search != null && search.isNotEmpty) {
        url += category != null ? '&search=$search' : '?search=$search';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ProviderModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error obteniendo proveedores: $e');
      return [];
    }
    */
    return []; // Mock por ahora
  }

  /*
  /// Obtener un proveedor por ID
  /// GET /api/providers/:id
  /// Returns: ProviderModel
  */
  Future<ProviderModel?> getProviderById(String id) async {
    // TODO: Descomentar cuando el backend esté listo
    /*
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/providers/$id'));

      if (response.statusCode == 200) {
        return ProviderModel.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Error obteniendo proveedor: $e');
      return null;
    }
    */
    return null; // Mock por ahora
  }

  // ============================================
  // SERVICE ENDPOINTS
  // ============================================

  /*
  /// Crear un nuevo servicio (solo para proveedores)
  /// POST /api/services
  /// Headers: { "Authorization": "Bearer token" }
  /// Body: { "name": string, "description": string, "price": number, "image": string, "category": string, "duration": string }
  /// Returns: Service
  */
  Future<Service?> createService({
    required String name,
    required String description,
    required double price,
    required String image,
    required String category,
    String? duration,
    required String token,
  }) async {
    // TODO: Descomentar cuando el backend esté listo
    /*
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/services'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'price': price,
          'image': image,
          'category': category,
          'duration': duration,
        }),
      );

      if (response.statusCode == 201) {
        return Service.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Error creando servicio: $e');
      return null;
    }
    */
    return null; // Mock por ahora
  }

  /*
  /// Actualizar un servicio (solo para proveedores)
  /// PUT /api/services/:id
  /// Headers: { "Authorization": "Bearer token" }
  /// Body: { "name": string, "description": string, "price": number, "image": string, "category": string, "duration": string }
  /// Returns: Service
  */
  Future<Service?> updateService({
    required String id,
    required String name,
    required String description,
    required double price,
    required String image,
    required String category,
    String? duration,
    required String token,
  }) async {
    // TODO: Descomentar cuando el backend esté listo
    /*
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/services/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'price': price,
          'image': image,
          'category': category,
          'duration': duration,
        }),
      );

      if (response.statusCode == 200) {
        return Service.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Error actualizando servicio: $e');
      return null;
    }
    */
    return null; // Mock por ahora
  }

  /*
  /// Eliminar un servicio (solo para proveedores)
  /// DELETE /api/services/:id
  /// Headers: { "Authorization": "Bearer token" }
  /// Returns: bool
  */
  Future<bool> deleteService(String id, String token) async {
    // TODO: Descomentar cuando el backend esté listo
    /*
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/services/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error eliminando servicio: $e');
      return false;
    }
    */
    return false; // Mock por ahora
  }

  // ============================================
  // ORDER ENDPOINTS
  // ============================================

  /*
  /// Crear una orden
  /// POST /api/orders
  /// Headers: { "Authorization": "Bearer token" }
  /// Body: { "items": CartItem[], "user": User, "paymentMethod": string }
  /// Returns: { "orderId": string, "total": number }
  */
  Future<Map<String, dynamic>?> createOrder({
    required List<CartItem> items,
    required User user,
    required String paymentMethod,
    required String token,
  }) async {
    // TODO: Descomentar cuando el backend esté listo
    /*
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'items': items.map((item) => {
            'serviceId': item.service.id,
            'quantity': item.quantity,
            'providerId': item.providerId,
          }).toList(),
          'user': user.toJson(),
          'paymentMethod': paymentMethod,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error creando orden: $e');
      return null;
    }
    */
    return null; // Mock por ahora
  }

  /*
  /// Obtener órdenes del usuario
  /// GET /api/orders
  /// Headers: { "Authorization": "Bearer token" }
  /// Returns: List<Order>
  */
  Future<List<Map<String, dynamic>>> getUserOrders(String token) async {
    // TODO: Descomentar cuando el backend esté listo
    /*
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/orders'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Error obteniendo órdenes: $e');
      return [];
    }
    */
    return []; // Mock por ahora
  }
}

