enum UserRole { customer, provider }

// lib/models/auth_user.dart
class AuthUser {
  final int id; // ¡IMPORTANTE! El ID de tu base de datos
  final String name;
  final String email;
  final String role; // 'customer' o 'provider'
  final String? token;

  AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.token,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'], // Mapea el ID
      name: json['name'],
      email: json['email'],
      role: json['role'] ?? 'customer', // Asigna un rol por defecto si no viene
      token: json['token'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'token': token,

    };
  }
}

