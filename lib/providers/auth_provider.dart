// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/auth_user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  AuthUser? _authUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthProvider(this._apiService);

  AuthUser? get authUser => _authUser;
  bool get isLoggedIn => _authUser != null;

  // --- NUEVO: AUTO-LOGIN SILENCIOSO ---
  Future<bool> tryAutoLogin() async {
    try {
      // Intenta iniciar sesión silenciosamente (sin popup)
      final GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();

      if (googleUser != null) {
        print('AuthProvider: Sesión recuperada para ${googleUser.email}');

        // Sincroniza con el backend
        _authUser = await _apiService.loginOrRegisterWithGoogle(
          name: googleUser.displayName ?? 'Usuario Recuperado',
          email: googleUser.email,
        );

        notifyListeners();
        return true; // Éxito: Usuario logueado
      }
    } catch (e) {
      print('AuthProvider: No se pudo recuperar sesión previa: $e');
    }
    return false; // Fallo: No había sesión
  }
  // ------------------------------------

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('AuthProvider: Cancelado por el usuario.');
        return;
      }

      _authUser = await _apiService.loginOrRegisterWithGoogle(
        name: googleUser.displayName ?? 'Usuario Anónimo',
        email: googleUser.email,
      );

      print('AuthProvider: Login Exitoso. ID: ${_authUser!.id}');
      notifyListeners();
    } catch (e, stackTrace) {
      print('--- ERROR LOGIN GOOGLE ---');
      print('Error: $e');
      print('Stack: $stackTrace');
      await logout();
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    _authUser = null;
    notifyListeners();
  }

  Future<void> updateProfile(String name, String lastname, String phone, String address) async {
    if (_authUser == null) return;
    try {
      // 1. Llamar a la API
      final updatedUser = await _apiService.updateUserProfile(
        userId: _authUser!.id,
        name: name,
        lastname: lastname,
        phone: phone,
        address: address,
      );

      // 2. Actualizar estado local manteniendo el token
      _authUser = updatedUser;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}