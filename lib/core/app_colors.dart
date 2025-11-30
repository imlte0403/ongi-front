import 'package:flutter/material.dart';

/// 온기 앱의 색상 시스템
/// 피그마 디자인 가이드를 기반으로 구성
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
  static const Color textTertiary = Color(0xFFBEBFC0);
  static const Color textDisabled = Color(0xFF929292);

  // Border & Divider
  static const Color border = Color(0xFFBEBFC0);
  static const Color divider = Color(0xFFBEBFC0);

  // Private 생성자 - 인스턴스 생성 방지
  AppColors._();
}
