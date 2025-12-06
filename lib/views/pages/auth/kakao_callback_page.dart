import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;
import 'package:ongi_front/viewmodels/auth_viewmodel.dart';
import 'package:ongi_front/core/app_colors.dart';
import 'package:ongi_front/core/app_spacing.dart';
import 'package:ongi_front/core/app_text_styles.dart';
import 'package:ongi_front/views/pages/profile/profile_setup_page.dart';
import 'package:ongi_front/utils/app_logger.dart';

/// 카카오 로그인 콜백 처리 페이지
class KakaoCallbackPage extends StatefulWidget {
  const KakaoCallbackPage({super.key});

  @override
  State<KakaoCallbackPage> createState() => _KakaoCallbackPageState();
}

class _KakaoCallbackPageState extends State<KakaoCallbackPage> {
  String _statusMessage = '카카오 로그인 처리 중...';
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _handleCallback();
  }

  Future<void> _handleCallback() async {
    try {
      // 현재 URL에서 인가 코드 추출
      final currentUrl = html.window.location.href;
      final uri = Uri.parse(currentUrl);

      final code = uri.queryParameters['code'];
      final error = uri.queryParameters['error'];
      final errorDescription = uri.queryParameters['error_description'];

      // 에러 파라미터 확인
      if (error != null) {
        _handleError('카카오 인증 실패: ${errorDescription ?? error}');
        return;
      }

      // 인가 코드 없음
      if (code == null || code.isEmpty) {
        _handleError('인가 코드를 받지 못했습니다. 다시 시도해주세요.');
        return;
      }

      setState(() {
        _statusMessage = '인증 정보 확인 중...';
      });

      AppLogger.success('인가 코드 받음: ${code.substring(0, 10)}...');

      if (!mounted) return;
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

      // 백엔드로 인가 코드 전달하여 JWT 토큰 받기
      setState(() {
        _statusMessage = '로그인 처리 중...';
      });

      await authViewModel.loginWithKakaoAuthCode(code);

      if (!mounted) return;

      // 로그인 결과 확인
      if (authViewModel.error != null) {
        _handleError(authViewModel.error!);
        return;
      }

      if (authViewModel.currentUser == null) {
        _handleError('사용자 정보를 가져오지 못했습니다.');
        return;
      }

      // 로그인 성공! 프로필 설정 페이지로 이동
      final user = authViewModel.currentUser!;
      AppLogger.success('로그인 성공: ${user.name}');

      setState(() {
        _statusMessage = '로그인 성공! 프로필 설정으로 이동합니다...';
      });

      // 잠시 대기 후 이동 (UX용)
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ProfileSetupPage(
            nickname: user.name,
            email: user.email,
            profileImageUrl: user.profileImageUrl,
          ),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('로그인 성공! 🎉 프로필을 설정해주세요.'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      AppLogger.error('콜백 처리 중 예외 발생: $e');
      _handleError('로그인 처리 중 오류가 발생했습니다: ${e.toString()}');
    }
  }

  void _handleError(String message) {
    AppLogger.error('로그인 에러: $message');
    if (!mounted) return;

    setState(() {
      _hasError = true;
      _errorMessage = message;
      _statusMessage = '로그인 실패';
    });
  }

  void _retryLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_hasError) ...[
                // 로딩 중
                const CircularProgressIndicator(
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  _statusMessage,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                // 에러 발생
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  '로그인 실패',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  _errorMessage ?? '알 수 없는 오류가 발생했습니다.',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                // 다시 시도 버튼
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _retryLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      '다시 로그인하기',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // 돌아가기 버튼
                TextButton(
                  onPressed: _goBack,
                  child: Text(
                    '이전 화면으로 돌아가기',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
