import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  try {
    print('Sending request to http://127.0.0.1:8000/api/token/');
    final response = await dio.post(
      'http://127.0.0.1:8000/api/token/',
      data: {'email': 'test@example.com', 'password': 'password'},
    );
    print('Success: ' + response.data.toString());
  } on DioException catch (e) {
    print('Dio Error: ' + e.message.toString());
    if (e.response != null) {
      print('Response status: ' + e.response!.statusCode.toString());
      print('Response data: ' + e.response!.data.toString());
    } else {
      print('No response received.');
    }
  } catch (e) {
    print('Other Error: ' + e.toString());
  }
}
