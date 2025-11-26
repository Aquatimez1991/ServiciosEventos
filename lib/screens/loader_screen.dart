// lib/screens/loader_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../providers/auth_provider.dart';

class LoaderScreen extends StatefulWidget {
  const LoaderScreen({super.key});

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// Esta es la función clave que inicia todo.
  Future<void> _initializeApp() async {
    // Usamos context.read porque estamos en initState y solo necesitamos el provider una vez.
    final authProvider = context.read<AuthProvider>();

    // 1. ¡LA LLAMADA CRUCIAL!
    // Le decimos al AuthProvider que inicie el proceso de login.
    // Esto mostrará el diálogo de Google para elegir la cuenta.
    await authProvider.signInWithGoogle();

    // 2. Una pequeña pausa para mejorar la experiencia de usuario.
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      // 3. Después de que el login termine (con éxito o no), navegamos a la pantalla de inicio.
      context.go('/home');
    }
  }

  // La UI de esta pantalla no necesita cambios, solo muestra la animación de carga.
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Iniciando sesión...'),
          ],
        ),
      ),
    );
  }
}