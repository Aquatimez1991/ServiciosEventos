// lib/providers/service_provider.dart

import 'package.flutter/material.dart';
import '../models/service.dart';
import '../services/api_service.dart';

class ServiceProvider extends ChangeNotifier {
  final ApiService _apiService; // El "Mensajero" que habla con la API

  List<Service> _services = [];
  List<Service> get services => _services;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // El constructor recibe el ApiService para poder usarlo.
  ServiceProvider(this._apiService) {
    // Tan pronto como se crea, le pedimos que cargue los servicios.
    fetchServicesFromApi();
  }

  /// Pide los servicios al ApiService y notifica a la UI cuando están listos.
  Future<void> fetchServicesFromApi() async {
    _isLoading = true;
    notifyListeners(); // Avisa a la UI: "Estoy cargando"

    try {
      _services = await _apiService.fetchServices();
      print('¡Éxito! Se obtuvieron ${_services.length} servicios del backend.');
    } catch (e) {
      print('¡Error! No se pudieron obtener los servicios: $e');
      _services = []; // Si hay un error, la lista queda vacía.
    } finally {
      _isLoading = false;
      notifyListeners(); // Avisa a la UI: "Ya terminé de cargar"
    }
  }
}