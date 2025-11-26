// lib/providers/service_provider.dart

import 'package:flutter/material.dart';
import '../models/service.dart';
import '../services/api_service.dart';

class ServiceProvider extends ChangeNotifier {
  final ApiService _apiService; // Campo para guardar el ApiService

  List<Service> _services = [];
  List<Service> get services => _services;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // --- IGUALMENTE AQUÍ, LA LÍNEA CLAVE ES EL CONSTRUCTOR. ---
  // Acepta un ApiService y lo usa para cargar los datos iniciales.
  ServiceProvider(this._apiService) {
    fetchServicesFromApi();
  }
  // ------------------------------------------------------------

  /// Pide los servicios al ApiService y notifica a la UI cuando están listos.
  Future<void> fetchServicesFromApi() async {
    _isLoading = true;
    notifyListeners();

    try {
      _services = await _apiService.fetchServices();
      print('¡Éxito! Se obtuvieron ${_services.length} servicios del backend.');
    } catch (e) {
      print('¡Error! No se pudieron obtener los servicios: $e');
      _services = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}