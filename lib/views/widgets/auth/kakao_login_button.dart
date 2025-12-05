import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/auth_viewmodel.dart';

class KakaoLoginButton extends StatelessWidget {
  const KakaoLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, _) {
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: authViewModel.isLoading
                ? null
                : () async {
                    // 카카오 로그인 시작 (리다이렉트)
                    await authViewModel.startKakaoLogin();
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFEE500), // 카카오 노란색
              foregroundColor: Colors.black87,
              elevation: 0,
              disabledBackgroundColor: const Color(0xFFFEE500).withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: authViewModel.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 카카오톡 아이콘
                      Icon(
                        Icons.chat_bubble,
                        size: 24,
                        color: Colors.black87,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '카카오톡으로 간편하게 로그인하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
