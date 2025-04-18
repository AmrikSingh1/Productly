import 'package:flutter/material.dart';

class SplashProvider extends ChangeNotifier {
  bool _showSplash = true;
  bool get showSplash => _showSplash;

  void hideSplash() {
    _showSplash = false;
    notifyListeners();
  }
} 