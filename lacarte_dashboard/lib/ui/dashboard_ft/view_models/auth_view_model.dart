import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:lacarte_dashboard/data/repositories/auth_repository.dart';
import 'package:lacarte_dashboard/data/service/api_client.dart';

enum AuthStatus { idle, loading, authenticated, unauthenticated, error }

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  AuthStatus _status = AuthStatus.idle;
  String? _errorMessage;
  UserResponse? _currentUser;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  UserResponse? get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    _setStatus(AuthStatus.loading);
    print('DEBUG: Attempting to login with email: $email');
    try {
      final response = await _authRepository.login(email, password);
      _currentUser = response.user;
      _setStatus(AuthStatus.authenticated);
      print('DEBUG: Login successful!');
      return true;
    } on DioException catch (e) {
      print('DEBUG: DioException caught: ${e.message}');
      print('DEBUG: Response status: ${e.response?.statusCode}');
      print('DEBUG: Response data: ${e.response?.data}');
      _setError('Login failed: ${e.response?.data?['detail'] ?? e.message}');
      return false;
    } catch (e) {
      print('DEBUG: General exception caught: $e');
      _setError('An error occurred: $e');
      return false;
    }
  }

  Future<bool> signup(String email, String firstName, String lastName, String password, String role) async {
    _setStatus(AuthStatus.loading);
    try {
      final request = SignupRequest(
        email: email,
        firstName: firstName,
        lastName: lastName,
        password: password,
        role: role,
      );
      await _authRepository.signup(request);
      _setStatus(AuthStatus.unauthenticated);
      return true;
    } on DioException catch (e) {
      if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data.containsKey('detail')) {
           _setError('Signup failed: ${data['detail']}');
        } else {
           final errorStrings = data.values.expand((v) => v is List ? v : [v]).join('\n');
           _setError('Signup failed:\n$errorStrings');
        }
      } else {
        _setError('Signup failed: ${e.message}');
      }
      return false;
    } catch (e) {
      _setError('An error occurred: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _currentUser = null;
    _setStatus(AuthStatus.unauthenticated);
  }

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _status = AuthStatus.error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
        _status = _currentUser != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    }
    notifyListeners();
  }
}
