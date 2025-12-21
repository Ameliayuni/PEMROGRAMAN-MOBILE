import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class SettingsProvider with ChangeNotifier {
  final LocalStorageService _storageService = LocalStorageService();

  final List<MaterialColor> _availableColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
  ];

  MaterialColor _primaryColor = Colors.blue;
  bool _isDarkMode = false;

  SettingsProvider() {
    _loadPreferences();
  }

  List<MaterialColor> get availableColors => _availableColors;
  MaterialColor get primaryColor => _primaryColor;
  bool get isDarkMode => _isDarkMode;

  Future<void> _loadPreferences() async {
    await _storageService.init();

    final colorIndex = await _storageService.getThemeColor();
    _primaryColor = _availableColors[
        colorIndex.clamp(0, _availableColors.length - 1)];

    _isDarkMode = await _storageService.getDarkMode();
    notifyListeners();
  }

  void setThemeColor(int index) {
    _primaryColor = _availableColors[index];
    _storageService.saveThemeColor(index);
    notifyListeners();
  }

  void toggleTheme(bool value) {
    _isDarkMode = value;
    _storageService.saveDarkMode(value);
    notifyListeners();
  }
}