import 'dart:convert';
import 'dart:html' as html;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoAuthService {
  /// 카카오 로그인 (웹용: 리다이렉트 방식)
  ///
  /// 웹 환경에서는 SDK를 사용하되, 실패 시 직접 URL을 열어 리다이렉트합니다.
  Future<String?> loginForWeb({required String redirectUri}) async {
    try {
      print('🌐 [카카오 웹 로그인] Redirect URI: $redirectUri');

      // 방법 1: SDK를 통한 인증 시도
      try {
        // SDK 초기화 확인
        final jsKey = const String.fromEnvironment(
          'KAKAO_JS_KEY',
          defaultValue: '',
        );

        if (jsKey.isEmpty || jsKey == 'YOUR_JAVASCRIPT_KEY') {
          throw Exception('JavaScript 키가 설정되지 않았습니다');
        }

        print('📱 [방법 1] SDK를 통한 인증 시도');

        // SDK를 통한 인증 (AuthCodeClient.instance는 싱글톤이므로 항상 존재)
        await AuthCodeClient.instance.authorize(
          redirectUri: redirectUri,
        );

        print('✅ [방법 1] SDK 인증 성공');
        return '인가코드는 Redirect URI에서 추출';
      } catch (sdkError) {
        print('⚠️ [방법 1] SDK 인증 실패: $sdkError');
        print('📱 [방법 2] 직접 URL 열기로 폴백');

        // 방법 2: 직접 URL 열기 (폴백)
        return await _loginWithDirectUrl(redirectUri: redirectUri);
      }
    } catch (error) {
      print('❌ 카카오 웹 로그인 실패: $error');
      print('   스택 트레이스: ${error.toString()}');
      return null;
    }
  }

  /// 직접 URL을 열어 카카오 로그인 (폴백 메커니즘)
  Future<String?> _loginWithDirectUrl({required String redirectUri}) async {
    try {
      final jsKey = const String.fromEnvironment(
        'KAKAO_JS_KEY',
        defaultValue: '',
      );

      if (jsKey.isEmpty || jsKey == 'YOUR_JAVASCRIPT_KEY') {
        throw Exception('JavaScript 키가 설정되지 않아 직접 URL을 열 수 없습니다');
      }

      // 카카오 인증 URL 생성
      final authUrl = Uri.https(
        'kauth.kakao.com',
        '/oauth/authorize',
        {
          'client_id': jsKey,
          'redirect_uri': redirectUri,
          'response_type': 'code',
        },
      );

      print('🔗 [방법 2] 카카오 인증 URL: $authUrl');

      // 브라우저에서 URL 열기
      html.window.location.href = authUrl.toString();

      // 리다이렉트되므로 이 코드는 실행되지 않음
      return '리다이렉트됨';
    } catch (error) {
      print('❌ 직접 URL 열기 실패: $error');
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

  /// 인가 코드로 카카오 Access Token 받기
  ///
  /// 인가 코드를 사용하여 카카오 Access Token을 발급받습니다.
  Future<String?> getAccessTokenFromCode(String authCode, String redirectUri) async {
    try {
      final jsKey = const String.fromEnvironment(
        'KAKAO_JS_KEY',
        defaultValue: '',
      );

      if (jsKey.isEmpty || jsKey == 'YOUR_JAVASCRIPT_KEY') {
        throw Exception('JavaScript 키가 설정되지 않았습니다');
      }

      print('🔑 [카카오] 인가 코드로 Access Token 요청 중...');

      // 카카오 토큰 요청
      final tokenUrl = Uri.https('kauth.kakao.com', '/oauth/token');
      
      final response = await html.HttpRequest.request(
        tokenUrl.toString(),
        method: 'POST',
        requestHeaders: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        sendData: Uri(queryParameters: {
          'grant_type': 'authorization_code',
          'client_id': jsKey,
          'redirect_uri': redirectUri,
          'code': authCode,
        }).query,
      );

      if (response.status == 200) {
        final data = jsonDecode(response.responseText!);
        final accessToken = data['access_token'] as String?;
        
        if (accessToken != null) {
          print('✅ [카카오] Access Token 받음');
          return accessToken;
        } else {
          throw Exception('Access Token을 받을 수 없습니다');
        }
      } else {
        throw Exception('카카오 토큰 요청 실패: ${response.status}');
      }
    } catch (error) {
      print('❌ 카카오 Access Token 받기 실패: $error');
      return null;
    }
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
