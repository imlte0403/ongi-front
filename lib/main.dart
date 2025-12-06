import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;
import 'package:intl/date_symbol_data_local.dart';
import 'package:ongi_front/core/app_theme.dart';
import 'package:ongi_front/core/app_colors.dart';
import 'package:ongi_front/core/app_text_styles.dart';
import 'package:ongi_front/core/app_spacing.dart';
import 'package:ongi_front/core/constants.dart';
import 'package:ongi_front/utils/app_logger.dart';
import 'package:ongi_front/viewmodels/personality_test_viewmodel.dart';
import 'package:ongi_front/viewmodels/auth_viewmodel.dart';
import 'package:ongi_front/views/pages/onboarding/personality_test_page.dart';
import 'package:ongi_front/views/pages/onboarding/club_recommendation_page.dart';
import 'package:ongi_front/views/pages/auth/kakao_login_page.dart';
import 'package:ongi_front/views/pages/auth/kakao_callback_page.dart';
import 'package:ongi_front/views/pages/profile/profile_setup_page.dart';
import 'package:ongi_front/views/pages/profile/profile_complete_page.dart';

void main() async {
  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 한국어 로케일 데이터 초기화
  await initializeDateFormatting('ko_KR', null);

  // 카카오 SDK 초기화 (웹 환경)
  final jsKey = const String.fromEnvironment(
    'KAKAO_JS_KEY',
    defaultValue: 'YOUR_JAVASCRIPT_KEY',
  );

  // JavaScript 키 검증
  if (jsKey == 'YOUR_JAVASCRIPT_KEY' || jsKey.isEmpty) {
    AppLogger.warning('[카카오 SDK] JavaScript 키가 설정되지 않았습니다.');
    AppLogger.debug(
        '   launch.json에서 --dart-define=KAKAO_JS_KEY=your_key 설정을 확인하세요.');
  } else {
    AppLogger.success('[카카오 SDK] JavaScript 키 로드 완료 (길이: ${jsKey.length})');
  }

  try {
    KakaoSdk.init(
      javaScriptAppKey: jsKey,
    );
    AppLogger.success('[카카오 SDK] 초기화 완료');
  } catch (e) {
    AppLogger.error('[카카오 SDK] 초기화 실패: $e');
  }

  runApp(const OngiApp());
}

class OngiApp extends StatelessWidget {
  const OngiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PersonalityTestViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        initialRoute: _getInitialRoute(),
        routes: {
          '/': (context) => _getInitialPage(),
          '/login': (context) => const KakaoLoginPage(),
          '/auth/kakao/callback': (context) => const KakaoCallbackPage(),
          '/club-recommendation': (context) => const ClubRecommendationPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  /// 현재 URL 경로를 기반으로 초기 라우트 결정
  /// 카카오 콜백 리다이렉트를 처리하기 위함
  String _getInitialRoute() {
    final currentPath = html.window.location.pathname ?? '/';
    final queryString = html.window.location.search ?? '';

    AppLogger.search('[라우팅] 현재 경로: $currentPath');
    AppLogger.search('[라우팅] 쿼리: $queryString');

    // 카카오 콜백 경로 확인
    if (currentPath.contains('/auth/kakao/callback') ||
        queryString.contains('code=')) {
      AppLogger.success('[라우팅] 카카오 콜백 감지! → /auth/kakao/callback');
      return '/auth/kakao/callback';
    }

    // 기본 라우트
    return '/';
  }

  /// 개발 모드에 따라 초기 페이지 결정
  Widget _getInitialPage() {
    // SKIP_TO_PROFILE_COMPLETE=true: 프로필 완료 페이지로 (Sprint 5 개발용)
    if (AppConstants.skipToProfileComplete) {
      return const ProfileCompletePage(
        nickname: '달려라 사자',
        bio: '밴드 좋아하는 20대 중반 남자입니다. 주말마다 한강에서 러닝하는 것을 좋아해요.',
        profileImageUrl: null,
      );
    }
    // SKIP_TO_PROFILE=true: 프로필 설정 페이지로 (개발용)
    if (AppConstants.skipToProfile) {
      return const ProfileSetupPage(
        nickname: '달려라 사자',
        email: 'test@kakao.com',
        profileImageUrl: null,
      );
    }
    // SKIP_TO_RESULT=true: 바로 결과 페이지로 (개발용)
    if (AppConstants.skipToResult) {
      return const ClubRecommendationPage();
    }
    // SKIP_ONBOARDING=true: 테스트 페이지로 (온보딩 스킵)
    if (AppConstants.skipOnboarding) {
      return const PersonalityTestPage();
    }
    // 기본: 환영 페이지
    return const WelcomePage();
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 로고
              Text(
                AppConstants.appName,
                style: AppTextStyles.display.copyWith(
                  fontSize: 64,
                  color: AppColors.primary,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 설명
              Text(
                '성향 기반 취미 매칭 플랫폼',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.textTertiary,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 80),

              // 시작 버튼
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PersonalityTestPage(),
                      ),
                    );
                  },
                  child: const Text('테스트 시작하기'),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // 버전 정보
              Text(
                'v${AppConstants.appVersion} | Sprint 1',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textDisabled,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
