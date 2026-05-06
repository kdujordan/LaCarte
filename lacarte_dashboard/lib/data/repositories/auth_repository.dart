import 'package:lacarte_dashboard/data/service/api_client.dart';
import 'package:lacarte_dashboard/data/service/dio_client.dart';

class AuthRepository {
  final DioClient _dioClient = DioClient();

  Future<TokenResponse> login(String email, String password) async {
    final response = await _dioClient.apiClient.login(
      LoginRequest(email: email, password: password),
    );
    
    // Save tokens
    await _dioClient.saveTokens(response.access, response.refresh);
    
    return response;
  }

  Future<UserResponse> signup(SignupRequest request) async {
    return await _dioClient.apiClient.signup(request);
  }

  Future<void> logout() async {
    await _dioClient.clearTokens();
  }
}
