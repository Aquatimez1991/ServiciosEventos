import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/service.dart';
import '../models/provider_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get total => _items.fold(0.0, (sum, item) => sum + item.total);

  void addToCart(Service service, ProviderModel provider) {
    final existingIndex = _items.indexWhere(
      (item) => item.service.id == service.id && item.providerId == provider.id,
    );

    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + 1,
      );
    } else {
      _items.add(CartItem(
        service: service,
        quantity: 1,
        providerId: provider.id,
        providerName: provider.name,
      ));
    }
    notifyListeners();
  }

  void updateQuantity(String serviceId, String providerId, int quantity) {
    if (quantity <= 0) {
      removeItem(serviceId, providerId);
      return;
    }

    final index = _items.indexWhere(
      (item) => item.service.id == serviceId && item.providerId == providerId,
    );

    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      notifyListeners();
    }
  }

  void removeItem(String serviceId, String providerId) {
    _items.removeWhere(
      (item) => item.service.id == serviceId && item.providerId == providerId,
    );
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

