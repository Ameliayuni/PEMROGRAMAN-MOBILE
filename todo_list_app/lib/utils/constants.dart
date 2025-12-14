import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'My Blue Todo';
  static const String storageKey = 'todos';
  
  // Filter types
  static const String filterAll = 'all';
  static const String filterDone = 'done';
  static const String filterNotDone = 'notyet';
  
  // Messages
  static const String emptyTodoMessage = 'Yay! Tidak ada tugas~';
  static const String addTodoTitle = 'Buat Tugas Baru ✨';
  static const String editTodoTitle = 'Edit Tugas ✏️';
  static const String cancelText = 'Batal';
  static const String saveText = 'Simpan';
  static const String deleteText = 'Hapus';
  static const String confirmDeleteTitle = 'Hapus Tugas?';
  static const String confirmDeleteMessage = 'Tugas ini akan dihapus permanen!';
}

class AppColors {
  static const primaryColor = Color.fromARGB(255, 64, 144, 236);
  static const primaryLight = Color.fromARGB(255, 119, 162, 255);
  static const primaryDark = Color.fromARGB(255, 0, 108, 180);
  static const accentColor = Color.fromARGB(255, 128, 168, 255);
  static const dangerColor = Color.fromARGB(255, 82, 192, 255);
  static const successColor = Color.fromARGB(255, 105, 168, 240);
  static const backgroundColor = Color.fromARGB(255, 213, 223, 238);
  static const cardColor = Colors.white;
  static const textColor = Color.fromARGB(255, 147, 191, 250);
}

class AppGradients {
  static const primaryGradient = LinearGradient(
    colors: [Color.fromARGB(255, 64, 138, 236), Color.fromARGB(255, 68, 182, 235)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const appBarGradient = LinearGradient(
    colors: [Color.fromARGB(255, 64, 133, 236), Color.fromARGB(255, 98, 148, 240)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}