import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final String _key = 'isDark';
  bool _isDark = false;
  double _textScale = 1.0;
  double get textScale => _textScale;
  Locale _locale = const Locale('es');
  Locale get locale => _locale;

  bool get isDark => _isDark;
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _loadFromPrefs();
  }

  void setTextScale(double value) {
    _textScale = value;
    notifyListeners();
  }

  void setLocale(Locale loc) {
    if (_locale == loc) return;
    _locale = loc;
    notifyListeners();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_key) ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, _isDark);
    notifyListeners();
  }
}

class UsuarioProvider extends ChangeNotifier {
  double _peso = 0.0;
  double _altura = 0.0;

  double get peso => _peso;
  double get altura => _altura;

  UsuarioProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _peso = prefs.getDouble('peso') ?? 0.0;
    _altura = prefs.getDouble('altura') ?? 0.0;
    notifyListeners();
  }

  Future<void> guardarDatos(double nuevoPeso, double nuevaAltura) async {
    final prefs = await SharedPreferences.getInstance();
    _peso = nuevoPeso;
    _altura = nuevaAltura;

    await prefs.setDouble('peso', _peso);
    await prefs.setDouble('altura', _altura);
    notifyListeners();
  }
}
