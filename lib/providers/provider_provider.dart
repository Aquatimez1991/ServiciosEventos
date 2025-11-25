import 'package:flutter/material.dart';
import '../models/provider_model.dart';
import '../models/service.dart';
import '../services/api_service.dart';

class ProviderProvider extends ChangeNotifier {
  final List<ProviderModel> _providers = [];
  final ApiService _apiService = ApiService();

  List<ProviderModel> get providers => _providers;

  ProviderProvider() {
    // Para desarrollo, cargamos los datos mock.
    // En producción, probablemente llamarías a loadProviders() desde tu UI inicial.
    _loadMockProviders();
  }

  void _loadMockProviders() {
    _providers.clear(); // Limpiamos para evitar duplicados si se llama de nuevo
    _providers.addAll(_getMockProviders());
    notifyListeners();
  }

  // CAMBIO: Lógica para cargar proveedores desde la API (cuando esté lista)
  //Future<void> loadProviders({String? category, String? search}) async {
  //  try {
  //   final fetchedProviders = await _apiService.fetchProviders(category: category, search: search);
  //  _providers.clear();
  //   _providers.addAll(fetchedProviders);
//  notifyListeners();
  // } catch (e) {
      // Manejar el error, por ejemplo, mostrando un mensaje al usuario.
//   debugPrint("Error al cargar proveedores: $e");
//  }
  // }

  ProviderModel? getProviderById(String id) {
    try {
      return _providers.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // CAMBIO RADICAL: La función ahora interactúa con la API
  // Future<void> addService(String providerId, Service serviceWithoutId) async {
  // try {
      // 1. Llama al ApiService para crear el servicio en el backend.
      //    El backend lo guardará en la BD y le asignará un ID numérico.
      //    Luego, el backend nos devolverá el objeto Service completo.
  //  final newServiceWithId = await _apiService.createService(
  //   providerId: providerId,
  //  service: serviceWithoutId, token: '',
  // );

      // 2. Busca el proveedor en la lista local.
  //  final index = _providers.indexWhere((p) => p.id == providerId);
  //  if (index >= 0) {
        // 3. Agrega el servicio (devuelto por la API con su ID) a la lista de servicios del proveedor.
  //   final provider = _providers[index];
  //  provider.services.add(newServiceWithId);

        // 4. Notifica a los listeners para que la UI se actualice.
// notifyListeners();
// }
  //} catch (e) {
      // Es importante manejar errores de la API.
  // debugPrint("Error al añadir el servicio: $e");
      // Opcional: relanzar el error para que la UI pueda mostrar un mensaje.
//  throw Exception('No se pudo agregar el servicio. Inténtalo de nuevo.');
//  }
  // }

  // FUNCIÓN ACTUALIZADA CON IDs NUMÉRICOS (int) PARA LOS SERVICIOS
  List<ProviderModel> _getMockProviders() {
    return [
      ProviderModel(
        id: '1',
        name: 'Fiesta Mágica',
        image: 'https://images.unsplash.com/photo-1654851364032-ca4d7a47341c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxiaXJ0aGRheSUyMHBhcnR5JTIwZGVjb3JhdGlvbiUyMGJhbGxvb25zfGVufDF8fHx8MTc1NTUzMzM0NXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
        rating: 4.8,
        reviewCount: 234,
        deliveryTime: '45-60 min',
        location: 'Av. Larco 123, Miraflores, Lima, Perú',
        services: [
          Service(id: 1, name: 'Decoración con Globos Premium', description: 'Arco de globos, centro de mesa y decoración completa', price: 369.57, image: 'https://images.unsplash.com/photo-1654851364032-ca4d7a47341c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxiaXJ0aGRheSUyMHBhcnR5JTIwZGVjb3JhdGlvbiUyMGJhbGxvb25zfGVufDF8fHx8MTc1NTUzMzM0NXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'decoration', duration: '3 horas'),
          Service(id: 2, name: 'Alquiler de Local', description: 'Salón completamente equipado para 50 personas', price: 521.74, image: 'https://images.unsplash.com/photo-1600854109241-46990389fb97?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHZlbnVlJTIwcmVudGFsJTIwc3BhY2V8ZW58MXx8fHwxNzU1NTMzMzQ3fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'venue', duration: '4 horas'),
          Service(id: 3, name: 'Globos con Helio', description: 'Paquete de 50 globos con helio en colores temáticos', price: 108.70, image: 'https://images.unsplash.com/photo-1729798997904-d50ef609ac00?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxoZWxpdW0lMjBiYWxsb29ucyUyMHBhcnR5JTIwZGVjb3JhdGlvbnxlbnwxfHx8fDE3NTU2MzA1ODJ8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'decoration', duration: '1 día'),
          Service(id: 4, name: 'Iluminación LED', description: 'Sistema de luces LED multicolor para ambientar el evento', price: 195.65, image: 'https://images.unsplash.com/photo-1573524793986-ba272ecb60fa?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMGxpZ2h0aW5nJTIwZGlzY28lMjBsaWdodHN8ZW58MXx8fHwxNzU1NjMwNTc0fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'services', duration: '4 horas'),
          Service(id: 5, name: 'Arreglos Florales', description: 'Centros de mesa y decoración floral personalizada', price: 326.09, image: 'https://images.unsplash.com/photo-1748546639062-3d804e66f325?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx3ZWRkaW5nJTIwZmxvd2VycyUyMGJvdXF1ZXQlMjBjZW50ZXJwaWVjZXxlbnwxfHx8fDE3NTU2MzA1NzN8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'decoration', duration: '1 día'),
        ],
      ),
      ProviderModel(
        id: '2',
        name: 'Diversión Total',
        image: 'https://images.unsplash.com/photo-1537627856721-321efceec2a2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjaGlsZHJlbiUyMHBhcnR5JTIwZW50ZXJ0YWlubWVudCUyMGNsb3dufGVufDF8fHx8MTc1NTUzMzM0NXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
        rating: 4.6,
        reviewCount: 189,
        deliveryTime: '30-45 min',
        location: 'Jr. Arias Araguez 450, San Isidro, Lima, Perú',
        services: [
          Service(id: 6, name: 'Animador Profesional', description: 'Show de 2 horas con juegos, magia y payasito', price: 282.61, image: 'https://images.unsplash.com/photo-1537627856721-321efceec2a2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjaGlsZHJlbiUyMHBhcnR5JTIwZW50ZXJ0YWlubWVudCUyMGNsb3dufGVufDF8fHx8MTc1NTUzMzM0NXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'entertainment', duration: '2 horas'),
          Service(id: 7, name: 'Equipo de Sonido', description: 'Parlantes, micrófono y música para toda la fiesta', price: 152.17, image: 'https://images.unsplash.com/photo-1698602807831-81066d89ed41?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMG11c2ljJTIwZGolMjBlcXVpcG1lbnR8ZW58MXx8fHwxNzU1NTMzMzQ3fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'music', duration: '4 horas'),
          Service(id: 8, name: 'Juegos Inflables', description: 'Castillo inflable gigante para diversión sin límites', price: 413.04, image: 'https://images.unsplash.com/photo-1635536392500-271b66664142?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxpbmZsYXRhYmxlJTIwYm91bmN5JTIwY2FzdGxlJTIwa2lkc3xlbnwxfHx8fDE3NTU2MzA1Njh8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'kids', duration: '4 horas'),
          Service(id: 9, name: 'Piñatas Temáticas', description: 'Piñatas personalizadas con dulces y sorpresas', price: 152.17, image: 'https://images.unsplash.com/photo-1571584004609-3b9d08de5755?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwaW5hdGElMjBjaGlsZHJlbiUyMHBhcnR5JTIwY29sb3JmdWx8ZW58MXx8fHwxNzU1NjMwNTY4fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'kids', duration: '1 día'),
          Service(id: 10, name: 'Maquillaje Infantil', description: 'Pintacaritas y maquillaje artístico para niños', price: 173.91, image: 'https://images.unsplash.com/photo-1643906748265-2e77049c0281?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxmYWNlJTIwcGFpbnRpbmclMjBjaGlsZHJlbiUyMG1ha2V1cHxlbnwxfHx8fDE3NTU2MzA1NzV8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'kids', duration: '3 horas'),
          Service(id: 11, name: 'Show de Burbujas', description: 'Espectáculo mágico con burbujas gigantes', price: 217.39, image: 'https://images.unsplash.com/photo-1598455407664-a198955838f2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxidWJibGUlMjBzaG93JTIwcGVyZm9ybWFuY2UlMjBraWRzfGVufDF8fHx8MTc1NTYzMDU3Nnww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'entertainment', duration: '1 hora'),
        ],
      ),
      // ... El resto de tus ProviderModel con los services usando IDs numéricos
      // He omitido el resto por brevedad, pero la estructura es la misma
      ProviderModel(
        id: '3',
        name: 'Delicias & Sabores',
        image: 'https://images.unsplash.com/photo-1753532629345-e0ff1ff87a89?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxldmVudCUyMGNhdGVyaW5nJTIwZm9vZCUyMHBhcnR5fGVufDF8fHx8MTc1NTUzMzM0Nnww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
        rating: 4.9,
        reviewCount: 312,
        deliveryTime: '60-75 min',
        location: 'Calle San Martín 789, Barranco, Lima, Perú',
        services: [
          Service(id: 12, name: 'Torta Personalizada', description: 'Torta de 2 pisos con decoración temática', price: 195.65, image: 'https://images.unsplash.com/photo-1553803867-48ac36024cba?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxraWRzJTIwYmlydGhkYXklMjBjYWtlJTIwY2VsZWJyYXRpb258ZW58MXx8fHwxNzU1NTMzMzQ4fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'catering', duration: '1 día'),
          Service(id: 13, name: 'Bocaditos para 30 personas', description: 'Variedad de bocaditos dulces y salados', price: 239.13, image: 'https://images.unsplash.com/photo-1753532629345-e0ff1ff87a89?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxldmVudCUyMGNhdGVyaW5nJTIwZm9vZCUyMHBhcnR5fGVufDF8fHx8MTc1NTUzMzM0Nnww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'catering', duration: '1 día'),
          Service(id: 14, name: 'Candy Bar Completo', description: 'Mesa de dulces con decoración temática', price: 282.61, image: 'https://images.unsplash.com/photo-1709549774212-17c34ebaedc1?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjYW5keSUyMGJhciUyMHN3ZWV0cyUyMGRlc3NlcnQlMjB0YWJsZXxlbnwxfHx8fDE3NTU2MzA1Njl8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'catering', duration: '1 día'),
          Service(id: 15, name: 'Servicio de Bartender', description: 'Bartender profesional con barra completa', price: 347.83, image: 'https://images.unsplash.com/photo-1720108404259-2addc1cf223c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxiYXJ0ZW5kZXIlMjBjb2NrdGFpbHMlMjBwYXJ0eSUyMGRyaW5rc3xlbnwxfHx8fDE3NTU2MzA1Njd8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'services', duration: '4 horas'),
        ],
      ),
      ProviderModel(
        id: '4',
        name: 'Producciones VIP',
        image: 'https://images.unsplash.com/photo-1627580158782-ecd7b8a16326?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHBob3RvZ3JhcGhlciUyMHdlZGRpbmclMjBldmVudHN8ZW58MXx8fHwxNzU1NjMwNTY2fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
        rating: 4.7,
        reviewCount: 156,
        deliveryTime: '90-120 min',
        location: 'Jr. Ucayali 250, San Borja, Lima, Perú',
        services: [
          Service(id: 16, name: 'Fotografía Profesional', description: 'Sesión fotográfica completa del evento', price: 521.74, image: 'https://images.unsplash.com/photo-1627580158782-ecd7b8a16326?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHBob3RvZ3JhcGhlciUyMHdlZGRpbmclMjBldmVudHN8ZW58MXx8fHwxNzU1NjMwNTY2fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'photography', duration: '4 horas'),
          Service(id: 17, name: 'DJ Profesional', description: 'DJ con equipo completo y música personalizada', price: 391.30, image: 'https://images.unsplash.com/photo-1675709341324-9c98573f9281?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxkaiUyMHR1cm50YWJsZXMlMjBwYXJ0eSUyMG11c2ljfGVufDF8fHx8MTc1NTYzMDU2Nnww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'music', duration: '5 horas'),
          Service(id: 18, name: 'Organización Completa', description: 'Planificación y coordinación total del evento', price: 869.57, image: 'https://images.unsplash.com/photo-1712903276040-c99b32a057eb?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHBsYW5uaW5nJTIwb3JnYW5pemVyJTIwY2hlY2tsaXN0fGVufDF8fHx8MTc1NTYzMDU4Mnww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'services', duration: '1 semana'),
        ],
      ),
      ProviderModel(
        id: '5',
        name: 'Eventos Outdoor',
        image: 'https://images.unsplash.com/photo-1694578345441-c8ebfb5258fc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHRlbnQlMjBvdXRkb29yJTIwZXZlbnR8ZW58MXx8fHwxNzU1NjMwNTc1fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
        rating: 4.5,
        reviewCount: 98,
        deliveryTime: '120-180 min',
        location: 'Av. El Sol 400, Surco, Lima, Perú',
        services: [
          Service(id: 19, name: 'Carpa para Eventos', description: 'Carpa grande para eventos al aire libre', price: 652.17, image: 'https://images.unsplash.com/photo-1694578345441-c8ebfb5258fc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHRlbnQlMjBvdXRkb29yJTIwZXZlbnR8ZW58MXx8fHwxNzU1NjMwNTc1fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'venue', duration: '1 día'),
          Service(id: 20, name: 'Mesas y Sillas', description: 'Alquiler de mobiliario completo para 50 personas', price: 195.65, image: 'https://images.unsplash.com/photo-1706611430592-6d3bb6e7456f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHRhYmxlcyUyMGNoYWlycyUyMHJlbnRhbHxlbnwxfHx8fDE3NTU2MzA1NzZ8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'venue', duration: '1 día'),
        ],
      ),
      ProviderModel(
        id: '6',
        name: 'Servicios Especiales',
        image: 'https://images.unsplash.com/photo-1676265266086-aa863c7bd3cc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHRyYW5zcG9ydGF0aW9uJTIwYnVzJTIwbGltb3VzaW5lfGVufDF8fHx8MTc1NTYzMDU4MHww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
        rating: 4.4,
        reviewCount: 87,
        deliveryTime: '60-90 min',
        location: 'Calle Los Álamos 55, Surquillo, Lima, Perú',
        services: [
          Service(id: 21, name: 'Transporte VIP', description: 'Servicio de transporte para invitados', price: 434.78, image: 'https://images.unsplash.com/photo-1676265266086-aa863c7bd3cc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHRyYW5zcG9ydGF0aW9uJTIwYnVzJTIwbGltb3VzaW5lfGVufDF8fHx8MTc1NTYzMDU4MHww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'services', duration: '4 horas'),
          Service(id: 22, name: 'Limpieza Post-Evento', description: 'Servicio completo de limpieza después del evento', price: 260.87, image: 'https://images.unsplash.com/photo-1562050061-9f9c55b807e2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjbGVhbmluZyUyMHNlcnZpY2UlMjBwYXJ0eSUyMGNsZWFudXB8ZW58MXx8fHwxNzU1NjMwNTgxfDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'services', duration: '2 horas'),
          Service(id: 23, name: 'Seguridad Privada', description: 'Personal de seguridad para eventos grandes', price: 369.57, image: 'https://images.unsplash.com/photo-1652148555073-4b1d2ecd664c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxldmVudCUyMHNlY3VyaXR5JTIwZ3VhcmQlMjBzZXJ2aWNlfGVufDF8fHx8MTc1NTYzMDU4MXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral', category: 'services', duration: '6 horas'),
        ],
      ),
    ];
  }
}