class AuthUser {
  final int id;
  final String name;
  final String email;
  final String token;
  final String role;
  // Nuevos campos
  final String lastname;
  final String phone;
  final String address;

  AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.role,
    this.lastname = '',
    this.phone = '',
    this.address = '',
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      role: json['role'] ?? 'customer',
      // Mapeo seguro de los nuevos campos
      lastname: json['lastname'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }

  // Método para crear una copia con datos actualizados
  AuthUser copyWith({
    String? name,
    String? lastname,
    String? phone,
    String? address,
  }) {
    return AuthUser(
      id: id,
      name: name ?? this.name,
      email: email,
      token: token,
      role: role,
      lastname: lastname ?? this.lastname,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }
}