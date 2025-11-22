import 'package:flutter/material.dart';
import '../models/provider_model.dart';
import '../models/service.dart';
import '../services/api_service.dart';
import 'dart:math';

class ProviderProvider extends ChangeNotifier {
  final List<ProviderModel> _providers = [];
  final ApiService _apiService = ApiService();

  List<ProviderModel> get providers => _providers;

  ProviderProvider() {
    _loadMockProviders();
  }

  void _loadMockProviders() {
    // Mock data - TODO: Reemplazar con llamada al backend
    _providers.addAll(_getMockProviders());
    notifyListeners();
  }

  // TODO: Reemplazar con llamada real al backend
  Future<void> loadProviders({String? category, String? search}) async {
    // TODO: Descomentar cuando el backend esté listo
    /*
    final providers = await _apiService.getProviders(
      category: category,
      search: search,
    );
    _providers.clear();
    _providers.addAll(providers);
    notifyListeners();
    */
  }

  ProviderModel? getProviderById(String id) {
    try {
      return _providers.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addService(String providerId, Service service) async {
    // TODO: Integrar con backend cuando esté listo
    /*
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.authUser?.providerId == providerId) {
      await _apiService.createService(
        name: service.name,
        description: service.description,
        price: service.price,
        image: service.image,
        category: service.category,
        duration: service.duration,
        token: authProvider.authUser!.token, // Asumiendo que AuthUser tiene token
      );
      await loadProviders();
    }
    */

    // Mock por ahora
    final index = _providers.indexWhere((p) => p.id == providerId);
    if (index >= 0) {
      final provider = _providers[index];
      final updatedServices = [...provider.services, service];
      _providers[index] = ProviderModel(
        id: provider.id,
        name: provider.name,
        image: provider.image,
        rating: provider.rating,
        reviewCount: provider.reviewCount,
        deliveryTime: provider.deliveryTime,
        location: provider.location,
        services: updatedServices,
      );
      notifyListeners();
    }
  }

  List<ProviderModel> _getMockProviders() {
    // Mock data completo - igual que en la app React
    return [
      ProviderModel(
        id: '1',
        name: 'Fiesta Mágica',
        image: 'https://images.unsplash.com/photo-1654851364032-ca4d7a47341c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxiaXJ0aGRheSUyMHBhcnR5JTIwZGVjb3JhdGlvbiUyMGJhbGxvb25zfGVufDF8fHx8MTc1NTUzMzM0NXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
        rating: 4.8,
        reviewCount: 234,
        deliveryTime: '45-60 min',
        location: 'Providencia',
        services: [
          Service(
            id: 's1',
            name: 'Decoración con Globos Premium',
            description: 'Arco de globos, centro de mesa y decoración completa',
            price: 85000,
            image: 'https://images.unsplash.com/photo-1654851364032-ca4d7a47341c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxiaXJ0aGRheSUyMHBhcnR5JTIwZGVjb3JhdGlvbiUyMGJhbGxvb25zfGVufDF8fHx8MTc1NTUzMzM0NXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'decoration',
            duration: '3 horas',
          ),
          Service(
            id: 's2',
            name: 'Alquiler de Local',
            description: 'Salón completamente equipado para 50 personas',
            price: 120000,
            image: 'https://images.unsplash.com/photo-1600854109241-46990389fb97?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHZlbnVlJTIwcmVudGFsJTIwc3BhY2V8ZW58MXx8fHwxNzU1NTMzMzQ3fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'venue',
            duration: '4 horas',
          ),
          Service(
            id: 's15',
            name: 'Globos con Helio',
            description: 'Paquete de 50 globos con helio en colores temáticos',
            price: 25000,
            image: 'https://images.unsplash.com/photo-1729798997904-d50ef609ac00?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxoZWxpdW0lMjBiYWxsb29ucyUyMHBhcnR5JTIwZGVjb3JhdGlvbnxlbnwxfHx8fDE3NTU2MzA1ODJ8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'decoration',
            duration: '1 día',
          ),
          Service(
            id: 's16',
            name: 'Iluminación LED',
            description: 'Sistema de luces LED multicolor para ambientar el evento',
            price: 45000,
            image: 'https://images.unsplash.com/photo-1573524793986-ba272ecb60fa?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMGxpZ2h0aW5nJTIwZGlzY28lMjBsaWdodHN8ZW58MXx8fHwxNzU1NjMwNTc0fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'services',
            duration: '4 horas',
          ),
          Service(
            id: 's17',
            name: 'Arreglos Florales',
            description: 'Centros de mesa y decoración floral personalizada',
            price: 75000,
            image: 'https://images.unsplash.com/photo-1748546639062-3d804e66f325?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx3ZWRkaW5nJTIwZmxvd2VycyUyMGJvdXF1ZXQlMjBjZW50ZXJwaWVjZXxlbnwxfHx8fDE3NTU2MzA1NzN8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'decoration',
            duration: '1 día',
          ),
        ],
      ),
      ProviderModel(
        id: '2',
        name: 'Diversión Total',
        image: 'https://images.unsplash.com/photo-1537627856721-321efceec2a2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjaGlsZHJlbiUyMHBhcnR5JTIwZW50ZXJ0YWlubWVudCUyMGNsb3dufGVufDF8fHx8MTc1NTUzMzM0NXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
        rating: 4.6,
        reviewCount: 189,
        deliveryTime: '30-45 min',
        location: 'Las Condes',
        services: [
          Service(
            id: 's3',
            name: 'Animador Profesional',
            description: 'Show de 2 horas con juegos, magia y payasito',
            price: 65000,
            image: 'https://images.unsplash.com/photo-1537627856721-321efceec2a2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjaGlsZHJlbiUyMHBhcnR5JTIwZW50ZXJ0YWlubWVudCUyMGNsb3dufGVufDF8fHx8MTc1NTUzMzM0NXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'entertainment',
            duration: '2 horas',
          ),
          Service(
            id: 's4',
            name: 'Equipo de Sonido',
            description: 'Parlantes, micrófono y música para toda la fiesta',
            price: 35000,
            image: 'https://images.unsplash.com/photo-1698602807831-81066d89ed41?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMG11c2ljJTIwZGolMjBlcXVpcG1lbnR8ZW58MXx8fHwxNzU1NTMzMzQ3fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'music',
            duration: '4 horas',
          ),
          Service(
            id: 's7',
            name: 'Juegos Inflables',
            description: 'Castillo inflable gigante para diversión sin límites',
            price: 95000,
            image: 'https://images.unsplash.com/photo-1635536392500-271b66664142?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxpbmZsYXRhYmxlJTIwYm91bmN5JTIwY2FzdGxlJTIwa2lkc3xlbnwxfHx8fDE3NTU2MzA1Njh8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'kids',
            duration: '4 horas',
          ),
          Service(
            id: 's8',
            name: 'Piñatas Temáticas',
            description: 'Piñatas personalizadas con dulces y sorpresas',
            price: 35000,
            image: 'https://images.unsplash.com/photo-1571584004609-3b9d08de5755?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwaW5hdGElMjBjaGlsZHJlbiUyMHBhcnR5JTIwY29sb3JmdWx8ZW58MXx8fHwxNzU1NjMwNTY4fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'kids',
            duration: '1 día',
          ),
          Service(
            id: 's9',
            name: 'Maquillaje Infantil',
            description: 'Pintacaritas y maquillaje artístico para niños',
            price: 40000,
            image: 'https://images.unsplash.com/photo-1643906748265-2e77049c0281?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxmYWNlJTIwcGFpbnRpbmclMjBjaGlsZHJlbiUyMG1ha2V1cHxlbnwxfHx8fDE3NTU2MzA1NzV8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'kids',
            duration: '3 horas',
          ),
          Service(
            id: 's10',
            name: 'Show de Burbujas',
            description: 'Espectáculo mágico con burbujas gigantes',
            price: 50000,
            image: 'https://images.unsplash.com/photo-1598455407664-a198955838f2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxidWJibGUlMjBzaG93JTIwcGVyZm9ybWFuY2UlMjBraWRzfGVufDF8fHx8MTc1NTYzMDU3Nnww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'entertainment',
            duration: '1 hora',
          ),
        ],
      ),
      ProviderModel(
        id: '3',
        name: 'Delicias & Sabores',
        image: 'https://images.unsplash.com/photo-1753532629345-e0ff1ff87a89?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxldmVudCUyMGNhdGVyaW5nJTIwZm9vZCUyMHBhcnR5fGVufDF8fHx8MTc1NTUzMzM0Nnww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
        rating: 4.9,
        reviewCount: 312,
        deliveryTime: '60-75 min',
        location: 'Ñuñoa',
        services: [
          Service(
            id: 's5',
            name: 'Torta Personalizada',
            description: 'Torta de 2 pisos con decoración temática',
            price: 45000,
            image: 'https://images.unsplash.com/photo-1553803867-48ac36024cba?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxraWRzJTIwYmlydGhkYXklMjBjYWtlJTIwY2VsZWJyYXRpb258ZW58MXx8fHwxNzU1NTMzMzQ4fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'catering',
            duration: '1 día',
          ),
          Service(
            id: 's6',
            name: 'Bocaditos para 30 personas',
            description: 'Variedad de bocaditos dulces y salados',
            price: 55000,
            image: 'https://images.unsplash.com/photo-1753532629345-e0ff1ff87a89?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxldmVudCUyMGNhdGVyaW5nJTIwZm9vZCUyMHBhcnR5fGVufDF8fHx8MTc1NTUzMzM0Nnww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'catering',
            duration: '1 día',
          ),
          Service(
            id: 's11',
            name: 'Candy Bar Completo',
            description: 'Mesa de dulces con decoración temática',
            price: 65000,
            image: 'https://images.unsplash.com/photo-1709549774212-17c34ebaedc1?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjYW5keSUyMGJhciUyMHN3ZWV0cyUyMGRlc3NlcnQlMjB0YWJsZXxlbnwxfHx8fDE3NTU2MzA1Njl8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'catering',
            duration: '1 día',
          ),
          Service(
            id: 's12',
            name: 'Servicio de Bartender',
            description: 'Bartender profesional con barra completa',
            price: 80000,
            image: 'https://images.unsplash.com/photo-1720108404259-2addc1cf223c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxiYXJ0ZW5kZXIlMjBjb2NrdGFpbHMlMjBwYXJ0eSUyMGRyaW5rc3xlbnwxfHx8fDE3NTU2MzA1Njd8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'services',
            duration: '4 horas',
          ),
        ],
      ),
      ProviderModel(
        id: '4',
        name: 'Producciones VIP',
        image: 'https://images.unsplash.com/photo-1627580158782-ecd7b8a16326?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHBob3RvZ3JhcGhlciUyMHdlZGRpbmclMjBldmVudHN8ZW58MXx8fHwxNzU1NjMwNTY2fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
        rating: 4.7,
        reviewCount: 156,
        deliveryTime: '90-120 min',
        location: 'Vitacura',
        services: [
          Service(
            id: 's13',
            name: 'Fotografía Profesional',
            description: 'Sesión fotográfica completa del evento',
            price: 120000,
            image: 'https://images.unsplash.com/photo-1627580158782-ecd7b8a16326?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHBob3RvZ3JhcGhlciUyMHdlZGRpbmclMjBldmVudHN8ZW58MXx8fHwxNzU1NjMwNTY2fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'photography',
            duration: '4 horas',
          ),
          Service(
            id: 's14',
            name: 'DJ Profesional',
            description: 'DJ con equipo completo y música personalizada',
            price: 90000,
            image: 'https://images.unsplash.com/photo-1675709341324-9c98573f9281?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxkaiUyMHR1cm50YWJsZXMlMjBwYXJ0eSUyMG11c2ljfGVufDF8fHx8MTc1NTYzMDU2Nnww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'music',
            duration: '5 horas',
          ),
          Service(
            id: 's18',
            name: 'Organización Completa',
            description: 'Planificación y coordinación total del evento',
            price: 200000,
            image: 'https://images.unsplash.com/photo-1712903276040-c99b32a057eb?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHBsYW5uaW5nJTIwb3JnYW5pemVyJTIwY2hlY2tsaXN0fGVufDF8fHx8MTc1NTYzMDU4Mnww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'services',
            duration: '1 semana',
          ),
        ],
      ),
      ProviderModel(
        id: '5',
        name: 'Eventos Outdoor',
        image: 'https://images.unsplash.com/photo-1694578345441-c8ebfb5258fc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHRlbnQlMjBvdXRkb29yJTIwZXZlbnR8ZW58MXx8fHwxNzU1NjMwNTc1fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
        rating: 4.5,
        reviewCount: 98,
        deliveryTime: '120-180 min',
        location: 'San Bernardo',
        services: [
          Service(
            id: 's19',
            name: 'Carpa para Eventos',
            description: 'Carpa grande para eventos al aire libre',
            price: 150000,
            image: 'https://images.unsplash.com/photo-1694578345441-c8ebfb5258fc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHRlbnQlMjBvdXRkb29yJTIwZXZlbnR8ZW58MXx8fHwxNzU1NjMwNTc1fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'venue',
            duration: '1 día',
          ),
          Service(
            id: 's20',
            name: 'Mesas y Sillas',
            description: 'Alquiler de mobiliario completo para 50 personas',
            price: 45000,
            image: 'https://images.unsplash.com/photo-1706611430592-6d3bb6e7456f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHRhYmxlcyUyMGNoYWlycyUyMHJlbnRhbHxlbnwxfHx8fDE3NTU2MzA1NzZ8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'venue',
            duration: '1 día',
          ),
        ],
      ),
      ProviderModel(
        id: '6',
        name: 'Servicios Especiales',
        image: 'https://images.unsplash.com/photo-1676265266086-aa863c7bd3cc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHRyYW5zcG9ydGF0aW9uJTIwYnVzJTIwbGltb3VzaW5lfGVufDF8fHx8MTc1NTYzMDU4MHww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
        rating: 4.4,
        reviewCount: 87,
        deliveryTime: '60-90 min',
        location: 'Maipú',
        services: [
          Service(
            id: 's21',
            name: 'Transporte VIP',
            description: 'Servicio de transporte para invitados',
            price: 100000,
            image: 'https://images.unsplash.com/photo-1676265266086-aa863c7bd3cc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHRyYW5zcG9ydGF0aW9uJTIwYnVzJTIwbGltb3VzaW5lfGVufDF8fHx8MTc1NTYzMDU4MHww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'services',
            duration: '4 horas',
          ),
          Service(
            id: 's22',
            name: 'Limpieza Post-Evento',
            description: 'Servicio completo de limpieza después del evento',
            price: 60000,
            image: 'https://images.unsplash.com/photo-1562050061-9f9c55b807e2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjbGVhbmluZyUyMHNlcnZpY2UlMjBwYXJ0eSUyMGNsZWFudXB8ZW58MXx8fHwxNzU1NjMwNTgxfDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'services',
            duration: '2 horas',
          ),
          Service(
            id: 's23',
            name: 'Seguridad Privada',
            description: 'Personal de seguridad para eventos grandes',
            price: 85000,
            image: 'https://images.unsplash.com/photo-1652148555073-4b1d2ecd664c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxldmVudCUyMHNlY3VyaXR5JTIwZ3VhcmQlMjBzZXJ2aWNlfGVufDF8fHx8MTc1NTYzMDU4MXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
            category: 'services',
            duration: '6 horas',
          ),
        ],
      ),
    ];
  }
}

