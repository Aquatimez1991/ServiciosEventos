import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/auth_user.dart';
import '../services/api_service.dart';

// lib/providers/auth_provider.dart

class AuthProvider extends ChangeNotifier {
  AuthUser? _authUser;
  final ApiService _apiService = ApiService();

  AuthUser? get authUser => _authUser;
  bool get isLoggedIn => _authUser != null;

  Future<void> signInWithGoogle() async {
    try {
      // 1. Lógica existente para iniciar sesión con Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // El usuario canceló el login
        return;
      }

      // 2. LLAMADA AL BACKEND PARA SINCRONIZAR
      _authUser = await _apiService.loginOrRegisterWithGoogle(
        name: googleUser.displayName ?? 'Usuario Google',
        email: googleUser.email,
      );

      // 3. Notifica a la app que el login fue exitoso y ya tenemos el ID
      notifyListeners();
    } catch (e) {
      print('Error en signInWithGoogle: $e');
      // Manejar el error, quizás mostrar un mensaje al usuario
    }
  }

// ... resto de tu AuthProvider (logout, etc.)
}
