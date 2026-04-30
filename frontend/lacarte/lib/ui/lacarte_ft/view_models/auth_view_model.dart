import 'package:flutter/material.dart';
import 'package:lacarte/data/services/auth_serivce.dart';
// import 'package:lacarte/data/services/api_client.dart

class AuthViewModel extends ChangeNotifier {
  // final ApiClient _apiClient = ApiClient();
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> guestEnter(String qrCodeId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _authService.scanTable(qrCodeId);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;

      errorMessage = e.toString().replaceAll('Exeception: ', '');
      notifyListeners();
      return false;
    }
  }
}
