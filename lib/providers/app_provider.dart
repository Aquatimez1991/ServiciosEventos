import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  String _currentScreen = 'loader';
  String get currentScreen => _currentScreen;

  void setCurrentScreen(String screen) {
    _currentScreen = screen;
    notifyListeners();
  }
}

