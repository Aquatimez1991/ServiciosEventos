// lib/providers/service_provider.dart

import 'package:flutter/material.dart';
import '../models/service.dart';
import '../models/provider.dart';
import '../services/api_service.dart';

class ServiceProvider extends ChangeNotifier {
  final ApiService _apiService;

  List<Service> _services = [];
  List<Service> get services => _services;

  List<Provider> _providers = [];
  List<Provider> get providers => _providers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ServiceProvider(this._apiService) {
    fetchServicesFromApi();
  }

  Future<void> fetchServicesFromApi() async {
    _isLoading = true;
    notifyListeners();

    try {
      _services = await _apiService.fetchServices();
      _groupServicesIntoProviders();
      print('¡Éxito! Se obtuvieron ${_services.length} servicios y se agruparon en ${_providers.length} proveedores.');
    } catch (e) {
      print('¡Error! No se pudieron obtener los servicios: $e');
      _services = [];
      _providers = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _groupServicesIntoProviders() {
    // Definimos las categorías que queremos usar para agrupar, similar a la UI original.
    const categoryMapping = {
      'birthday': {'name': 'Cumpleaños', 'icon': '🎂'},
      'kids': {'name': 'Infantiles', 'icon': '🧸'},
      'decoration': {'name': 'Decoración', 'icon': '🎈'},
      'catering': {'name': 'Catering', 'icon': '🍰'},
      'entertainment': {'name': 'Animación', 'icon': '🎭'},
      'music': {'name': 'Música', 'icon': '🎵'},
      'photography': {'name': 'Fotografía', 'icon': '📸'},
      'venue': {'name': 'Locales', 'icon': '🏢'},
      'services': {'name': 'Servicios', 'icon': '⚙️'},
    };

    final Map<String, List<Service>> servicesByCategory = {};
    for (final service in _services) {
      final categoryKey = service.category.toLowerCase();
      if (categoryMapping.containsKey(categoryKey)) {
        if (servicesByCategory[categoryKey] == null) {
          servicesByCategory[categoryKey] = [];
        }
        servicesByCategory[categoryKey]!.add(service);
      }
    }

    _providers = servicesByCategory.entries.map((entry) {
      final categoryKey = entry.key;
      final categoryInfo = categoryMapping[categoryKey]!;
      final servicesInBuffer = entry.value;

      return Provider(
        id: categoryKey,
        name: categoryInfo['name']!,
        icon: categoryInfo['icon']!,
        services: servicesInBuffer,
      );
    }).toList();
  }
}
