import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  
  try {
    print('Sending request to /orders/ ...');
    final response = await dio.get('/orders/');
    print('Response status: ${response.statusCode}');
  } on DioException catch (e) {
    print('DioException: ${e.message}');
    print('Status code: ${e.response?.statusCode}');
  } catch (e) {
    print('Unknown error: $e');
  }
}
