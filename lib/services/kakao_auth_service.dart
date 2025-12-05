import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoAuthService {
  /// 카카오 로그인 (웹용: 리다이렉트 방식)
  ///
  /// 웹 환경에서는 authorizeWithKakaoAccount()를 사용하여
  /// 카카오계정 로그인 페이지로 리다이렉트합니다.
  Future<String?> loginForWeb({required String redirectUri}) async {
    try {
      print('🌐 [카카오 웹 로그인] Redirect URI: $redirectUri');

      // 카카오계정으로 로그인 (웹)
      await AuthCodeClient.instance.authorize(
        redirectUri: redirectUri,
      );

      // 리다이렉트 후 돌아오면 URL에서 인가 코드 추출
      return '인가코드는 Redirect URI에서 추출';
    } catch (error) {
      print('❌ 카카오 웹 로그인 실패: $error');
      return null;
    }
  }

  /// 인가 코드 처리 (콜백 페이지에서 호출)
  ///
  /// Redirect URI로 돌아온 후 URL에서 인가 코드를 추출합니다.
  String? extractAuthCode(String callbackUrl) {
    final uri = Uri.parse(callbackUrl);
    final code = uri.queryParameters['code'];
    final error = uri.queryParameters['error'];

    if (error != null) {
      print('❌ 카카오 인증 에러: $error');
      return null;
    }

    if (code != null) {
      print('✅ 인가 코드 받음: $code');
      return code;
    }

    return null;
  }

  /// 카카오톡 설치 여부 확인
  Future<bool> isKakaoTalkAvailable() async {
    return await isKakaoTalkInstalled();
  }

  /// 로그아웃
  Future<void> logout() async {
    try {
      await UserApi.instance.logout();
      print('✅ 카카오 로그아웃 성공');
    } catch (error) {
      print('❌ 카카오 로그아웃 실패: $error');
    }
  }

  /// 연결 해제 (회원 탈퇴)
  Future<void> unlink() async {
    try {
      await UserApi.instance.unlink();
      print('✅ 카카오 연결 해제 성공');
    } catch (error) {
      print('❌ 카카오 연결 해제 실패: $error');
    }
  }
}

final kakaoAuthService = KakaoAuthService();
