import 'service.dart';

class ProviderModel {
  final String id;
  final String name;
  final String image;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final String location;
  final List<Service> services;

  ProviderModel({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.location,
    required this.services,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      deliveryTime: json['deliveryTime'] as String,
      location: json['location'] as String,
      services: (json['services'] as List<dynamic>)
          .map((service) => Service.fromJson(service as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'rating': rating,
      'reviewCount': reviewCount,
      'deliveryTime': deliveryTime,
      'location': location,
      'services': services.map((service) => service.toJson()).toList(),
    };
  }
}

