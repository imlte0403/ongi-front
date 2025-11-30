import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'core/app_colors.dart';
import 'core/app_text_styles.dart';
import 'core/app_spacing.dart';
import 'core/constants.dart';
import 'viewmodels/personality_test_viewmodel.dart';
import 'views/pages/onboarding/personality_test_page.dart';

void main() {
  runApp(const OngiApp());
}

class OngiApp extends StatelessWidget {
  const OngiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PersonalityTestViewModel()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        home: const WelcomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
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
