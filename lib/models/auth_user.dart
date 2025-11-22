enum UserRole { customer, provider }

class AuthUser {
  final String username;
  final UserRole role;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? businessName;
  final String? providerId;

  AuthUser({
    required this.username,
    required this.role,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.businessName,
    this.providerId,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      username: json['username'] as String,
      role: json['role'] == 'provider' ? UserRole.provider : UserRole.customer,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      businessName: json['businessName'] as String?,
      providerId: json['providerId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'role': role == UserRole.provider ? 'provider' : 'customer',
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'businessName': businessName,
      'providerId': providerId,
    };
  }
}

