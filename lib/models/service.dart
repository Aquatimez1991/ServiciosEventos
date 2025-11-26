// lib/models/service.dart

class Service {
  final int? id;
  final String name;        // Mapeado desde el campo 'title' del backend
  final String description;
  final double price;       // Mapeado desde el campo 'priceSoles' del backend
  final String image;       // Mapeado desde el campo 'imageUrl' del backend
  final String category;
  final String address;
  final String district;

  Service({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.address,
    required this.district,
  });

  /// Crea una instancia de Service a partir de un mapa JSON de la API.
  /// ¡ESTA ES LA PARTE CLAVE QUE HEMOS CORREGIDO!
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      // El 'name' de la app viene del campo 'title' del JSON
      name: json['title'] ?? 'Servicio sin nombre',
      description: json['description'] ?? 'Sin descripción.',
      // El 'price' de la app viene del campo 'priceSoles' del JSON
      price: (json['priceSoles'] as num? ?? 0.0).toDouble(),
      // La 'image' de la app viene del campo 'imageUrl' del JSON
      image: json['imageUrl'] ?? 'https://via.placeholder.com/300.png?text=Error',
      category: json['category'] ?? 'General',
      address: json['address'] ?? 'Dirección no especificada',
      district: json['district'] ?? 'Distrito no especificado',
    );
  }

  /// Convierte la instancia a un mapa JSON para enviarlo a la API.
  Map<String, dynamic> toJson() {
    return {
      'title': name,
      'description': description,
      'priceSoles': price,
      'imageUrl': image,
      'category': category,
      'address': address,
      'district': district,
    };
  }
}