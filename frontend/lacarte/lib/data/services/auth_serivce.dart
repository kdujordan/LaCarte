import 'package:dio/dio.dart';
import 'package:lacarte/data/services/api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  // For Guests scanning the Qr Code

  Future<Map<String, dynamic>> scanTable(String qrCodeID) async {
    try {
      final response = await _apiClient.dio.post(
        'scan-table/',
        data: {'qr_code_id': qrCodeID},
      );

      await _apiClient.storage.write(
        key: 'access_token',
        value: response.data['access_token'],
      );
      await _apiClient.storage.write(
        key: 'session_id',
        value: response.data['session_id'],
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['error'] ?? 'Failed to scan table');
    }
  }
}
