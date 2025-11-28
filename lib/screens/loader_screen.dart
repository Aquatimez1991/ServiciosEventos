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

class _LoaderScreenState extends State<LoaderScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late AnimationController _dotsController;

  @override
  void initState() {
    super.initState();

    // Animaciones visuales (sin cambios)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _logoScale = Tween(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    // Iniciar verificación
    _initializeApp();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    final authProvider = context.read<AuthProvider>();

    // CAMBIO IMPORTANTE: Usamos tryAutoLogin() en lugar de signInWithGoogle()
    // Esto verifica si hay sesión sin abrir ventanas emergentes.
    await authProvider.tryAutoLogin();

    // Pequeña espera para disfrutar la animación :)
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // Ya sea que se haya logueado o no, vamos al Home.
      // Si se logueó, el Home mostrará la foto del usuario.
      // Si no, mostrará la opción de ingresar.
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double emojiSize = MediaQuery.of(context).size.width * 0.20;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFA726), Color(0xFFFFD95B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _logoScale,
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Text("🎉", style: TextStyle(fontSize: emojiSize)),
              ),
            ),
            const SizedBox(height: 35),
            const Text(
              "PartyApp",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            const Text(
              "Organizando el evento perfecto...",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 30),
            AnimatedBuilder(
              animation: _dotsController,
              builder: (_, __) {
                int activeDot = ((_dotsController.value * 3) % 3).floor();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    bool isActive = i == activeDot;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: isActive ? 12 : 8,
                      height: isActive ? 12 : 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(isActive ? 1.0 : 0.5),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}