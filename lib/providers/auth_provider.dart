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

  /// Usuario autenticado actualmente
  AuthUser? get authUser => _authUser;

  /// Estado de sesión
  bool get isLoggedIn => _authUser != null;

  /// Inicia sesión con Google y sincroniza con el backend.
  /// CAMBIO: Se ha mejorado el bloque catch para obtener más detalles del error.
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('AuthProvider: El usuario canceló el inicio de sesión de Google.');
        return;
      }

      print(
        'AuthProvider: Login de Google exitoso para ${googleUser.email}. '
            'Sincronizando con backend...',
      );

      _authUser = await _apiService.loginOrRegisterWithGoogle(
        name: googleUser.displayName ?? 'Usuario Anónimo',
        email: googleUser.email,
      );

      print('AuthProvider: ¡Usuario sincronizado! ID de backend: ${_authUser!.id}');
      notifyListeners();
    } catch (e, stackTrace) {
      // CAMBIO: Capturamos el error Y el stack trace.
      print('--- ERROR FATAL DURANTE EL LOGIN DE GOOGLE ---');
      print('TIPO DE ERROR: ${e.runtimeType}');
      print('MENSAJE: $e');
      print('STACK TRACE: $stackTrace');
      print('-------------------------------------------');

      await logout();
    }
  }

  /// Cierra sesión tanto en Google como en la app.
  Future<void> logout() async {
    await _googleSignIn.signOut();
    _authUser = null;
    notifyListeners();
  }
}