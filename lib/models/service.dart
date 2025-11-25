class Service {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final String? duration;
  final String? address;
  final String? district;


  Service({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.address,
    this.district,
    this.duration,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      category: json['category'] as String,
      duration: json['duration'] as String?,
      address: json['address'] as String,
      district: json['district'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'duration': duration,
      'address': address,
      'district': district,
    };
  }

  Service copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? image,
    String? category,
    String? duration,
    String? address,
    String? district,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      address: address ?? this.address,
      district: district ?? this.district,
    );
  }
}

