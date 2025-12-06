import 'package:flutter/material.dart';

/// 온기 앱의 색상 시스템
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF28B16E);
  static const Color secondary = Color(0xFFD9F7E8);

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F5);

  // Status Colors
  static const Color error = Color(0xFFFF7033);
  static const Color success = Color(0xFF208E58);

  // Text Colors
  static const Color textPrimary = Color(0xFF2E2E2E);
  static const Color textSecondary = Color(0xFF616161); // gray700
  static const Color textTertiary = Color(0xFFBEBFC0);
  static const Color textDisabled = Color(0xFF929292);

  // Primary Light (연한 초록)
  static const Color primaryLight = Color(0xFFE8F7F0);

  // Gray Scale
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  // Border & Divider
  static const Color border = Color(0xFFE0E0E0); // gray300
  static const Color divider = Color(0xFFEEEEEE); // gray200

  // Private 생성자 - 인스턴스 생성 방지
  AppColors._();
}
