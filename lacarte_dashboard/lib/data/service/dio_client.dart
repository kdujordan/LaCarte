import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'api_client.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  late Dio dio;
  late ApiClient apiClient;
  late Logger logger;

  static const String baseUrl = "http://your-backend-url.com/api";
  static const String tokenKey = "access_token";
  static const String refreshTokenKey = "refresh_token";

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    logger = Logger();
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );

    // Add interceptors
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );

    apiClient = ApiClient(dio);
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    logger.i('REQUEST[${options.method}] => PATH: ${options.path}');
    logger.i('HEADERS: ${options.headers}');
    logger.i('BODY: ${options.data}');

    // Get the token from secure storage
    final token = await _getToken();

    if (token != null) {
      // Check if token is expired
      if (JwtDecoder.isExpired(token)) {
        // Try to refresh token
        final newToken = await _refreshToken();
        if (newToken != null) {
          options.headers['Authorization'] = 'Bearer $newToken';
        } else {
          // Token refresh failed, need to re-login
          // Trigger logout event
        }
      } else {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    return handler.next(options);
  }

  Future<void> _onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    logger.i(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    logger.i('RESPONSE BODY: ${response.data}');

    return handler.next(response);
  }

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    logger.e(
      'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
    );
    logger.e('ERROR MESSAGE: ${error.message}');

    if (error.response?.statusCode == 401) {
      // Unauthorized - token might be invalid
      logger.w('Unauthorized request - attempting token refresh');
      final newToken = await _refreshToken();

      if (newToken != null) {
        // Retry the request with new token
        final options = error.requestOptions;
        options.headers['Authorization'] = 'Bearer $newToken';

        try {
          final response = await dio.request(
            options.path,
            options: Options(method: options.method, headers: options.headers),
            data: options.data,
            queryParameters: options.queryParameters,
          );
          return handler.resolve(response);
        } catch (e) {
          return handler.next(error);
        }
      } else {
        // Token refresh failed - logout user
        // Trigger logout event
        return handler.next(error);
      }
    }

    return handler.next(error);
  }

  Future<String?> _getToken() async {
    try {
      const storage = FlutterSecureStorage();
      return await storage.read(key: tokenKey);
    } catch (e) {
      logger.e('Error reading token: $e');
      return null;
    }
  }

  Future<String?> _refreshToken() async {
    try {
      const storage = FlutterSecureStorage();
      final refreshToken = await storage.read(key: refreshTokenKey);

      if (refreshToken == null) {
        return null;
      }

      final response = await dio.post(
        '/token/refresh/',
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access'];
        await storage.write(key: tokenKey, value: newAccessToken);
        return newAccessToken;
      }
    } catch (e) {
      logger.e('Error refreshing token: $e');
    }
    return null;
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    try {
      const storage = FlutterSecureStorage();
      await storage.write(key: tokenKey, value: accessToken);
      await storage.write(key: refreshTokenKey, value: refreshToken);
    } catch (e) {
      logger.e('Error saving tokens: $e');
    }
  }

  Future<void> clearTokens() async {
    try {
      const storage = FlutterSecureStorage();
      await storage.delete(key: tokenKey);
      await storage.delete(key: refreshTokenKey);
    } catch (e) {
      logger.e('Error clearing tokens: $e');
    }
  }
}
