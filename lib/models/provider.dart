// lib/models/provider.dart
import 'service.dart';

class Provider {
  final String id;
  final String name;
  final String icon;
  final List<Service> services;

  Provider({
    required this.id,
    required this.name,
    required this.icon,
    required this.services,
  });

  // Helpers to provide data for the UI card, taken from the first service
  // or as placeholders.
  String get image {
    if (services.isNotEmpty && services.first.image.isNotEmpty) {
      return services.first.image;
    }
    // A default placeholder image
    return 'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXJ0eSUyMHBsYW5uaW5nfGVufDF8fHx8MTc1NTY0MTU0MHww&ixlib=rb-4.0.3&q=80&w=1080';
  }

  String get location => services.isNotEmpty ? services.first.district : 'Varios';
  
  int get serviceCount => services.length;

  // Placeholder data to match the design.
  // In the future, this could come from the backend.
  double get rating {
    // Simple logic: generate a rating based on service count
    if (serviceCount == 0) return 0.0;
    return (4.0 + (id.hashCode % 10) / 10.0).clamp(4.0, 5.0);
  }

  int get reviewCount {
    if (serviceCount == 0) return 0;
    return 50 + (id.hashCode % 150);
  }
  
  String get deliveryTime {
     if (serviceCount == 0) return 'N/A';
     final times = ['30-45 min', '45-60 min', '60-75 min', '90-120 min'];
     return times[id.hashCode % times.length];
  }
}
