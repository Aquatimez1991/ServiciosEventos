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

  Future<void> _initializeApp() async {
    // Usamos context.read porque estamos en initState
    final authProvider = context.read<AuthProvider>();

    // 1. Inicia el flujo de login/sincronización con el backend
    await authProvider.signInWithGoogle();

    // 2. Pequeña demora para una mejor experiencia de usuario
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      // 3. Después del login, navega a la pantalla de inicio
      // La app siempre irá a /home, y desde allí se podrá navegar a otras partes.
      context.go('/home');
    }
  }

  // El build method no necesita cambios
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... tu código de UI ...
    );
  }
}