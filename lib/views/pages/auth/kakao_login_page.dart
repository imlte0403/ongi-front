import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_text_styles.dart';
import '../../../core/app_spacing.dart';
import '../../../core/constants.dart';
import '../../widgets/auth/kakao_login_button.dart';

class KakaoLoginPage extends StatelessWidget {
  const KakaoLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 로고
              Text(
                AppConstants.appName,
                style: AppTextStyles.display.copyWith(
                  fontSize: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 안내 문구
              Text(
                '환영합니다!',
                style: AppTextStyles.pageTitle,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '모임에 참여하려면\n로그인이 필요합니다',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),

              const SizedBox(height: AppSpacing.xl * 2),

              // 일러스트
              Icon(
                Icons.people_alt_rounded,
                size: 120,
                color: AppColors.primary.withOpacity(0.3),
              ),

              const SizedBox(height: AppSpacing.xl * 2),

              // 카카오 로그인 버튼
              const KakaoLoginButton(),

              const SizedBox(height: AppSpacing.lg),

              // 나중에 하기
              TextButton(
                onPressed: () {
                  // 비회원으로 홈 화면 진입
                  Navigator.of(context).pushReplacementNamed('/');
                },
                child: Text(
                  '나중에 할게요',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
