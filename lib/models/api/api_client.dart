import 'package:dio/dio.dart';
import '../../core/constants.dart';

class ApiClient {
  late Dio _dio;
  
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      contentType: 'application/json',
    ));
    
    // 요청 인터셉터 (로깅)
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('🚀 [요청] ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ [응답] ${response.statusCode} ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('❌ [에러] ${e.message}');
        return handler.next(e);
      },
    ));
  }
  
  Dio get dio => _dio;
}

// 싱글톤 인스턴스
final apiClient = ApiClient();
