import 'package:dio/dio.dart';
import 'package:ongi_front/core/constants.dart';
import 'package:ongi_front/models/services/storage_service.dart';
import 'package:ongi_front/utils/app_logger.dart';

class ApiClient {
  late Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      contentType: 'application/json',
    ));

    // 요청 인터셉터 (로깅 + JWT 토큰 자동 추가)
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // JWT 토큰 자동 추가
        final token = await StorageService.getAccessToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        AppLogger.launch('[요청] ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        AppLogger.success(
            '[응답] ${response.statusCode} ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        AppLogger.error('[에러] ${e.message}');

        // 401 에러 시 토큰 만료 처리 (선택사항)
        if (e.response?.statusCode == 401) {
          AppLogger.warning('[인증] 토큰 만료 또는 인증 실패');
        }

        return handler.next(e);
      },
    ));
  }

  Dio get dio => _dio;
}

// 싱글톤 인스턴스
final apiClient = ApiClient();
