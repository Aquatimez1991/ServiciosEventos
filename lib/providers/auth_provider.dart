import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/auth_user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthUser? _authUser;
  final ApiService _apiService = ApiService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  AuthUser? get authUser => _authUser;
  bool get isAuthenticated => _authUser != null;
  bool get isProvider => _authUser?.role == UserRole.provider;

  // Autenticación automática con Google (Android)
  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      
      if (googleUser == null) {
        // Si no hay sesión silenciosa, intentar sign in interactivo
        final GoogleSignInAccount? account = await _googleSignIn.signIn();
        if (account == null) {
          return false; // Usuario canceló el login
        }
        return await _handleGoogleSignIn(account);
      }
      
      return await _handleGoogleSignIn(googleUser);
    } catch (e) {
      print('Error en Google Sign-In: $e');
      // Si falla Google Sign-In, crear usuario demo automático
      return await _createDemoUser();
    }
  }

  Future<bool> _handleGoogleSignIn(GoogleSignInAccount googleUser) async {
    try {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // TODO: Enviar token al backend para verificar/crear usuario
      // Por ahora, crear usuario desde datos de Google
      _authUser = AuthUser(
        username: googleUser.email.split('@')[0],
        role: UserRole.customer, // Por defecto cliente, se puede cambiar después
        name: googleUser.displayName ?? 'Usuario',
        email: googleUser.email,
        phone: null,
      );
      
      notifyListeners();
      return true;
    } catch (e) {
      print('Error procesando Google Sign-In: $e');
      return await _createDemoUser();
    }
  }

  // Crear usuario demo automático si Google Sign-In no está disponible
  Future<bool> _createDemoUser() async {
    _authUser = AuthUser(
      username: 'usuario_android',
      role: UserRole.customer,
      name: 'Usuario Android',
      email: 'usuario@android.com',
      phone: null,
    );
    notifyListeners();
    return true;
  }

  // Inicializar autenticación automática
  Future<void> initializeAuth() async {
    // Intentar autenticación silenciosa primero
    await signInWithGoogle();
  }

  // TODO: Integrar con backend cuando esté listo
  Future<bool> login(String username, String password, String role) async {
    // Por ahora, mock login
    if (username == 'persona' && password == '123') {
      _authUser = AuthUser(
        username: username,
        role: role == 'provider' ? UserRole.provider : UserRole.customer,
        name: role == 'provider' ? 'Proveedor Demo' : 'Usuario Demo',
        email: 'demo@partyapp.com',
        phone: '+56912345678',
        providerId: role == 'provider' ? '1' : null,
        businessName: role == 'provider' ? 'Fiesta Mágica' : null,
      );
      notifyListeners();
      return true;
    }

    // TODO: Descomentar cuando el backend esté listo
    /*
    final user = await _apiService.login(username, password, role);
    if (user != null) {
      _authUser = user;
      notifyListeners();
      return true;
    }
    */
    return false;
  }

  Future<bool> registerCustomer({
    required String username,
    required String password,
    required String name,
    required String email,
    required String phone,
    required String address,
  }) async {
    // TODO: Descomentar cuando el backend esté listo
    /*
    final user = await _apiService.registerCustomer(
      username: username,
      password: password,
      name: name,
      email: email,
      phone: phone,
      address: address,
    );
    if (user != null) {
      _authUser = user;
      notifyListeners();
      return true;
    }
    return false;
    */
    
    // Mock por ahora
    _authUser = AuthUser(
      username: username,
      role: UserRole.customer,
      name: name,
      email: email,
      phone: phone,
      address: address,
    );
    notifyListeners();
    return true;
  }

  Future<bool> registerProvider({
    required String username,
    required String password,
    required String name,
    required String email,
    required String phone,
    required String businessName,
    required String location,
    required String description,
  }) async {
    // TODO: Descomentar cuando el backend esté listo
    /*
    final user = await _apiService.registerProvider(
      username: username,
      password: password,
      name: name,
      email: email,
      phone: phone,
      businessName: businessName,
      location: location,
      description: description,
    );
    if (user != null) {
      _authUser = user;
      notifyListeners();
      return true;
    }
    return false;
    */
    
    // Mock por ahora
    _authUser = AuthUser(
      username: username,
      role: UserRole.provider,
      name: name,
      email: email,
      phone: phone,
      businessName: businessName,
      providerId: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    _authUser = null;
    notifyListeners();
  }
}

