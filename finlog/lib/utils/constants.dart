import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF4CAF50);
  static const Color income = Color(0xFF4CAF50); // Green
  static const Color expense = Color(0xFFF44336); // Red
  static const Color background = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
}

class AppTextStyle {
  static const TextStyle header = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle title = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle amount = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle small = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}