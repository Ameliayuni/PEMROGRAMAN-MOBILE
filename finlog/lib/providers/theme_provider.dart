import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  String _languageCode = 'id';
  final LocalStorageService _storage = LocalStorageService();

  ThemeProvider() {
    _loadFromStorage();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  String get languageCode => _languageCode;

  Color get primaryColor => _themeMode == ThemeMode.dark ? Colors.black87 : Colors.blue;

  Future<void> _loadFromStorage() async {
    try {
      await _storage.init();
      final isDark = await _storage.getDarkMode();
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      // load language if stored (not implemented in storage library yet)
      notifyListeners();
    } catch (e) {
      // ignore errors
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    await _storage.saveDarkMode(isDark);
    notifyListeners();
  }

  void setLanguage(String code) {
    _languageCode = code;
    notifyListeners();
  }
}