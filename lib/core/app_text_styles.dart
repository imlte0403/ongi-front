import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 온기 앱의 타이포그래피 시스템
/// 피그마 디자인 가이드를 기반으로 구성
/// Font Family: Pretendard
class AppTextStyles {
  // 기본 폰트 패밀리
  static const String fontFamily = 'Pretendard';

  // Private 생성자 (인스턴스화 방지)
  AppTextStyles._();

  // ==========================================
  // 새로 추가된 스타일 (Personality Test용)
  // ==========================================

  // 1. 히어로 (Display) - 28pt Bold
  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  // 2. 페이지 타이틀 (Page Title) - 24pt Bold
  static const TextStyle pageTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  // 3. 섹션 타이틀 (Section Title) - 20pt Semibold
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // 4. 카드 타이틀 (Card Title) - 18pt Semibold
  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // 5. 중요 본문 (Body Large) - 17pt Regular
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textPrimary,
  );

  // 6. 기본 본문 (Body) - 16pt Regular
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  // 7. 작은 본문 (Body Small) - 15pt Regular
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  // 8. 탭 라벨 (Tab Label) - 14pt Semibold
  static const TextStyle tabLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // 9. 태그/힌트/시간 (Caption) - 12pt Regular
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // 10. CTA 버튼 (Button Primary) - 16pt Bold
  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.background,
  );

  // 11. 일반 버튼 (Button) - 15pt Semibold
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.textPrimary,
  );
}
