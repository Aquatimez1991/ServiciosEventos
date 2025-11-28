// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Asegúrate de tener este import
import '../models/auth_user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  AuthUser? _authUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthProvider(this._apiService);

  AuthUser? get authUser => _authUser;
  bool get isLoggedIn => _authUser != null;

  // --- NUEVO: MÉTODO PARA AUTO-LOGIN ---
  // Verifica si ya existe una sesión de Google activa sin abrir el popup
  Future<bool> tryAutoLogin() async {
    try {
      // signInSilently intenta loguear sin interacción del usuario
      final GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();

      if (googleUser != null) {
        print('AuthProvider: Sesión recuperada silenciosamente para ${googleUser.email}');

        // Sincronizamos con tu backend para obtener el ID real
        _authUser = await _apiService.loginOrRegisterWithGoogle(
          name: googleUser.displayName ?? 'Usuario',
          email: googleUser.email,
        );

        notifyListeners();
        return true; // Éxito
      }
    } catch (e) {
      print('AuthProvider: Falló el auto-login: $e');
    }
    return false; // No había sesión o falló
  }
  // -------------------------------------

  Future<void> signInWithGoogle() async {
    // ... (Tu código actual de signInWithGoogle está bien)
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // ... resto del código ...
    } catch (e, stackTrace) {
      // ... manejo de errores ...
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    _authUser = null;
    notifyListeners();
  }
}