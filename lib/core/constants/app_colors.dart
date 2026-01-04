import 'package:flutter/material.dart';

class AppColors {
  // Primary brand color
  static const Color primary = Color(0xFF7A4B3A);
  
  // Background colors
  static const Color background = Colors.white;
  static const Color cardBackground = Colors.white;
  
  // Text colors
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
  static const Color textHint = Color(0xFF9E9E9E);
  
  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53E3E);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Shadow and border colors
  static const Color shadow = Color(0x1A000000);
  static const Color border = Color(0xFFE0E0E0);
  
  // Opacity variants of primary color
  static Color primaryLight = primary.withValues(alpha: 0.1);
  static Color primaryMedium = primary.withValues(alpha: 0.3);
  static Color primaryDark = primary.withValues(alpha: 0.8);
}