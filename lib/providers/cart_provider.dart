// lib/providers/cart_provider.dart

import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/service.dart';
import '../providers/auth_provider.dart'; // Dependencia necesaria
import '../services/api_service.dart';     // Dependencia necesaria
import '../models/order.dart';

class CartProvider extends ChangeNotifier {
  final ApiService _apiService;
  final AuthProvider _authProvider;

  List<CartItem> _items = [];
  bool _isLoading = false;

  // Constructor que recibe las dependencias
  CartProvider(this._authProvider, this._apiService) {
    // Si el usuario ya está logueado cuando se crea el provider,
    // cargamos su carrito inmediatamente.
    if (_authProvider.isLoggedIn) {
      fetchCart();
    }
  }

  // --- GETTERS PÚBLICOS ---
  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get total => _items.fold(0.0, (sum, item) => sum + item.total);

  // --- MÉTODOS QUE INTERACTÚAN CON LA API ---

  /// Obtiene el carrito del usuario desde el backend y actualiza el estado.
  Future<void> fetchCart() async {
    if (!_authProvider.isLoggedIn) {
      _items = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final userId = _authProvider.authUser!.id;

      // Usamos directamente el método getCart del ApiService.
      _items = await _apiService.getCart(userId);

      print('¡Carrito cargado desde el backend! Items: ${_items.length}');
    } catch (e) {
      print('Error al obtener el carrito: $e');
      _items = []; // En caso de error, el carrito se muestra vacío.
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Añade un servicio al carrito del usuario en el backend.
  Future<void> addToCart(Service service) async {
    if (!_authProvider.isLoggedIn || service.id == null) return;

    try {
      final userId = _authProvider.authUser!.id;
      final serviceId = service.id!;

      await _apiService.addToCart(userId: userId, serviceId: serviceId);

      // Después de modificar el backend, recargamos el carrito
      await fetchCart();
    } catch (e) {
      print('Error al añadir al carrito: $e');
      rethrow;
    }
  }

  /// Actualiza la cantidad de un item.
  /// Llama al endpoint `PUT /cart/update` en tu backend.
  Future<void> updateQuantity(int serviceId, int quantity) async {
    if (!_authProvider.isLoggedIn) return;
    final userId = _authProvider.authUser!.id;

    if (quantity <= 0) {
      await removeItem(serviceId);
      return;
    }

    try {
      // LLAMADA REAL A LA API
      await _apiService.updateCartItem(
        userId: userId,
        serviceId: serviceId,
        quantity: quantity,
      );
      await fetchCart(); // Refrescar el estado desde la fuente de verdad
    } catch (e) {
      print('Error al actualizar cantidad: $e');
      throw Exception('No se pudo actualizar la cantidad.');
    }
  }

  /// Remueve un item del carrito.
  /// Llama al endpoint `DELETE /cart/remove` en tu backend.
  Future<void> removeItem(int serviceId) async {
    if (!_authProvider.isLoggedIn) return;
    final userId = _authProvider.authUser!.id;

    try {
      // LLAMADA REAL A LA API
      await _apiService.removeCartItem(
        userId: userId,
        serviceId: serviceId,
      );
      await fetchCart(); // Refrescar el estado desde la fuente de verdad
    } catch (e) {
      print('Error al remover item: $e');
      throw Exception('No se pudo eliminar el servicio del carrito.');
    }
  }

  /// Limpia todo el carrito del usuario en el backend.
  Future<void> clear() async {
    if (!_authProvider.isLoggedIn) return;

    try {
      final userId = _authProvider.authUser!.id;
      await _apiService.clearCart(userId);

      _items = []; // Actualizamos la UI inmediatamente.
      notifyListeners();
    } catch (e) {
      print('Error al limpiar el carrito: $e');
      rethrow;
    }
  }

  /// Procesa el checkout y devuelve la orden creada.
  Future<Order> checkout() async {
    if (!_authProvider.isLoggedIn) {
      throw Exception('Usuario no autenticado.');
    }

    try {
      final userId = _authProvider.authUser!.id;

      // Llamamos al ApiService para procesar el checkout
      final createdOrder = await _apiService.checkout(userId);

      // Después de un checkout exitoso, limpiamos el carrito local
      _items = [];
      notifyListeners();

      return createdOrder;
    } catch (e) {
      print('Error durante el checkout: $e');
      rethrow;
    }
  }
}