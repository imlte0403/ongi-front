import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_spacing.dart';
import '../profile/profile_setup_page.dart';

class KakaoCallbackPage extends StatefulWidget {
  const KakaoCallbackPage({super.key});

  @override
  State<KakaoCallbackPage> createState() => _KakaoCallbackPageState();
}

class _KakaoCallbackPageState extends State<KakaoCallbackPage> {
  @override
  void initState() {
    super.initState();
    _handleCallback();
  }

  Future<void> _handleCallback() async {
    // 현재 URL에서 인가 코드 추출
    final currentUrl = html.window.location.href;
    final uri = Uri.parse(currentUrl);

    final code = uri.queryParameters['code'];
    final error = uri.queryParameters['error'];

    if (error != null) {
      // 에러 처리
      print('❌ 카카오 로그인 에러: $error');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('카카오 로그인 실패: $error')),
      );

      Navigator.of(context).pushReplacementNamed('/');
      return;
    }

    if (code == null) {
      // 인가 코드 없음
      print('❌ 인가 코드 없음');
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/');
      return;
    }

    // 인가 코드를 백엔드로 전달
    print('✅ 인가 코드 받음: ${code.substring(0, 10)}...');

    if (!mounted) return;
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    try {
      // 백엔드로 인가 코드 전달하여 JWT 토큰 받기
      await authViewModel.loginWithKakaoAuthCode(code);

      if (!mounted) return;

      // 로그인 성공 시 프로필 설정 페이지로 이동
      if (authViewModel.error == null && authViewModel.currentUser != null) {
        final user = authViewModel.currentUser!;

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
      } else {
        // 로그인 실패
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authViewModel.error ?? '로그인 실패')),
        );
        Navigator.of(context).pushReplacementNamed('/');
      }
    } catch (e) {
      print('❌ 백엔드 인증 실패: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 처리 중 오류가 발생했습니다')),
      );
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.primary,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              '카카오 로그인 처리 중...',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
