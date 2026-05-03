import 'package:flutter/material.dart';
import 'package:lacarte/data/model/models.dart';
import 'package:lacarte/data/services/auth_serivce.dart';
// import 'package:lacarte/data/services/api_client.dart

class AuthViewModel extends ChangeNotifier {
  // final ApiClient _apiClient = ApiClient();
  final AuthService _authService = AuthService();

  OrderSession? _session;
  bool isLoading = false;
  String? errorMessage;

  OrderSession? get session => _session;

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
