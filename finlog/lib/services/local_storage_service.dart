import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // Keys untuk penyimpanan
  static const String _darkModeKey = "isDarkMode";
  static const String _themeColorKey = "themeColor";
  
  // Tambahkan keys untuk user data
  static const String _usersKey = "registeredUsers";
  static const String _currentUserKey = "currentUser";
  static const String _isLoggedInKey = "isLoggedIn";
  static const String _userPasswordKey = "userPasswords"; // Simpan password terpisah

  // Singleton instance
  static LocalStorageService? _instance;
  static SharedPreferences? _prefs;

  // Private constructor
  LocalStorageService._();

  // Factory constructor untuk singleton
  factory LocalStorageService() {
    _instance ??= LocalStorageService._();
    return _instance!;
  }

  // Initialize SharedPreferences - WAJIB dipanggil di main.dart
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    print('SharedPreferences initialized');
  }

  // Helper untuk memastikan prefs sudah diinisialisasi
  SharedPreferences _getPrefs() {
    if (_prefs == null) {
      throw Exception('SharedPreferences belum diinisialisasi. Panggil init() terlebih dahulu.');
    }
    return _prefs!;
  }

  // === DARK MODE ===
  Future<void> saveDarkMode(bool isDark) async {
    await _getPrefs().setBool(_darkModeKey, isDark);
  }

  bool getDarkModeSync() {
    return _getPrefs().getBool(_darkModeKey) ?? false;
  }

  Future<bool> getDarkMode() async {
    return _getPrefs().getBool(_darkModeKey) ?? false;
  }

  // === THEME COLOR ===
  Future<void> saveThemeColor(int index) async {
    await _getPrefs().setInt(_themeColorKey, index);
  }

  int getThemeColorIndexSync() {
    return _getPrefs().getInt(_themeColorKey) ?? 0;
  }

  Future<int> getThemeColor() async {
    return _getPrefs().getInt(_themeColorKey) ?? 0;
  }

  // === USER AUTHENTICATION ===
  
  // Simpan data user yang terdaftar
  Future<void> saveRegisteredUsers(Map<String, Map<String, dynamic>> users) async {
    try {
      // Pisahkan password dari data user
      final Map<String, Map<String, dynamic>> usersWithoutPassword = {};
      final Map<String, String> passwords = {};
      
      for (final entry in users.entries) {
        final email = entry.key;
        final userData = Map<String, dynamic>.from(entry.value);
        
        // Simpan password terpisah
        if (userData.containsKey('password')) {
          passwords[email] = userData['password'].toString();
          userData.remove('password');
        }
        
        usersWithoutPassword[email] = userData;
      }
      
      // Simpan user data tanpa password
      final usersJson = _mapToJson(usersWithoutPassword);
      await _getPrefs().setString(_usersKey, usersJson);
      
      // Simpan passwords terpisah
      final passwordsJson = _mapToJson(passwords);
      await _getPrefs().setString(_userPasswordKey, passwordsJson);
      
      print('Saved ${users.length} users to storage');
    } catch (e) {
      print('Error saving registered users: $e');
    }
  }

  // Ambil data user yang terdaftar
  Map<String, Map<String, dynamic>> getRegisteredUsersSync() {
    try {
      final usersJson = _getPrefs().getString(_usersKey);
      final passwordsJson = _getPrefs().getString(_userPasswordKey);
      
      if (usersJson == null || usersJson.isEmpty) {
        return {};
      }
      
      final users = _jsonToMap(usersJson);
      final passwords = passwordsJson != null && passwordsJson.isNotEmpty
          ? _jsonToMap(passwordsJson)
          : {};
      
      // Gabungkan kembali dengan password
      final Map<String, Map<String, dynamic>> completeUsers = {};
      
      for (final entry in users.entries) {
        final email = entry.key;
        final userData = Map<String, dynamic>.from(entry.value as Map);
        
        // Tambahkan password jika ada
        if (passwords.containsKey(email)) {
          userData['password'] = passwords[email];
        }
        
        completeUsers[email] = userData;
      }
      
      return completeUsers;
    } catch (e) {
      print('Error getting registered users: $e');
      return {};
    }
  }

  Future<Map<String, Map<String, dynamic>>> getRegisteredUsers() async {
    return getRegisteredUsersSync();
  }

  // Simpan user yang sedang login
  Future<void> saveCurrentUser(Map<String, dynamic> userData) async {
    try {
      // Buat salinan tanpa password untuk keamanan
      final safeUserData = Map<String, dynamic>.from(userData);
      if (safeUserData.containsKey('password')) {
        safeUserData.remove('password');
      }
      
      final userJson = _mapToJson(safeUserData);
      await _getPrefs().setString(_currentUserKey, userJson);
      await _getPrefs().setBool(_isLoggedInKey, true);
      
      print('Saved current user: ${userData['email']}');
    } catch (e) {
      print('Error saving current user: $e');
    }
  }

  // Ambil user yang sedang login
  Map<String, dynamic>? getCurrentUserSync() {
    try {
      final userJson = _getPrefs().getString(_currentUserKey);
      if (userJson == null || userJson.isEmpty) {
        return null;
      }
      
      final userData = _jsonToMap(userJson);
      print('Loaded current user: ${userData['email']}');
      return userData;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    return getCurrentUserSync();
  }

  // Cek apakah user sudah login
  bool isLoggedInSync() {
    try {
      return _getPrefs().getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    return isLoggedInSync();
  }

  // Logout - hapus data user yang login
  Future<void> logout() async {
    try {
      await _getPrefs().remove(_currentUserKey);
      await _getPrefs().setBool(_isLoggedInKey, false);
      print('User logged out');
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  // Clear semua data (untuk testing/reset)
  Future<void> clearAll() async {
    try {
      await _getPrefs().clear();
      print('All data cleared');
    } catch (e) {
      print('Error clearing all data: $e');
    }
  }

  // === HELPER METHODS ===
  
  // Convert Map to JSON string (sederhana tapi reliable)
  String _mapToJson(Map<String, dynamic> map) {
    try {
      final buffer = StringBuffer();
      buffer.write('{');
      
      final entries = map.entries.toList();
      for (int i = 0; i < entries.length; i++) {
        final entry = entries[i];
        buffer.write('"${entry.key}":');
        
        final value = entry.value;
        if (value is String) {
          buffer.write('"${_escapeString(value)}"');
        } else if (value is num) {
          buffer.write(value);
        } else if (value is bool) {
          buffer.write(value);
        } else if (value is Map) {
          buffer.write(_mapToJson(Map<String, dynamic>.from(value)));
        } else if (value == null) {
          buffer.write('null');
        } else {
          buffer.write('"${_escapeString(value.toString())}"');
        }
        
        if (i < entries.length - 1) {
          buffer.write(',');
        }
      }
      
      buffer.write('}');
      return buffer.toString();
    } catch (e) {
      print('Error converting map to JSON: $e');
      return '{}';
    }
  }

  // Convert JSON string to Map
  Map<String, dynamic> _jsonToMap(String json) {
    try {
      final Map<String, dynamic> result = {};
      String trimmed = json.trim();
      
      // Remove outer braces
      if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
        trimmed = trimmed.substring(1, trimmed.length - 1);
      }
      
      if (trimmed.isEmpty) {
        return result;
      }
      
      final List<String> pairs = [];
      StringBuffer currentPair = StringBuffer();
      bool inQuotes = false;
      
      // Parse pairs dengan memperhatikan nested objects
      for (int i = 0; i < trimmed.length; i++) {
        final char = trimmed[i];
        
        if (char == '"' && (i == 0 || trimmed[i - 1] != '\\')) {
          inQuotes = !inQuotes;
        }
        
        if (char == ',' && !inQuotes) {
          pairs.add(currentPair.toString().trim());
          currentPair.clear();
        } else {
          currentPair.write(char);
        }
      }
      
      if (currentPair.isNotEmpty) {
        pairs.add(currentPair.toString().trim());
      }
      
      // Parse each pair
      for (final pair in pairs) {
        final colonIndex = pair.indexOf(':');
        if (colonIndex == -1) continue;
        
        final key = pair.substring(0, colonIndex).trim();
        final value = pair.substring(colonIndex + 1).trim();
        
        // Remove quotes from key
        String cleanKey = key;
        if (cleanKey.startsWith('"') && cleanKey.endsWith('"')) {
          cleanKey = cleanKey.substring(1, cleanKey.length - 1);
        }
        
        // Parse value
        dynamic parsedValue;
        if (value.startsWith('"') && value.endsWith('"')) {
          // String
          parsedValue = value.substring(1, value.length - 1);
          parsedValue = _unescapeString(parsedValue.toString());
        } else if (value.startsWith('{')) {
          // Nested object
          parsedValue = _jsonToMap(value);
        } else if (value == 'true') {
          parsedValue = true;
        } else if (value == 'false') {
          parsedValue = false;
        } else if (value == 'null') {
          parsedValue = null;
        } else if (value.contains('.')) {
          // Try double
          parsedValue = double.tryParse(value);
          if (parsedValue == null) {
            parsedValue = value;
          }
        } else {
          // Try int
          parsedValue = int.tryParse(value);
          if (parsedValue == null) {
            parsedValue = value;
          }
        }
        
        result[cleanKey] = parsedValue;
      }
      
      return result;
    } catch (e) {
      print('Error converting JSON to map: $e');
      print('JSON string: $json');
      return {};
    }
  }

  // Escape special characters in string
  String _escapeString(String input) {
    return input
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }

  // Unescape special characters
  String _unescapeString(String input) {
    return input
        .replaceAll('\\\\', '\\')
        .replaceAll('\\"', '"')
        .replaceAll('\\n', '\n')
        .replaceAll('\\r', '\r')
        .replaceAll('\\t', '\t');
  }

  // Debug: Print semua data yang tersimpan
  void printAllStoredData() {
    try {
      print('=== STORED DATA DEBUG ===');
      print('isLoggedIn: ${_getPrefs().getBool(_isLoggedInKey)}');
      print('currentUser: ${_getPrefs().getString(_currentUserKey)}');
      print('registeredUsers: ${_getPrefs().getString(_usersKey)?.length ?? 0} chars');
      print('userPasswords: ${_getPrefs().getString(_userPasswordKey)?.length ?? 0} chars');
      print('isDarkMode: ${_getPrefs().getBool(_darkModeKey)}');
      print('themeColor: ${_getPrefs().getInt(_themeColorKey)}');
      print('=========================');
    } catch (e) {
      print('Error printing stored data: $e');
    }
  }
}