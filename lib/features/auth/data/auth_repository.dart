import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';
import '../domain/models/user_model.dart';

class AuthRepository {
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post('auth/login/', data: {
        'email': email,
        'password': password,
      });

      final token = response.data['token'];
      final userData = response.data['user'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

      return UserModel.fromJson(userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
    required String admissionNumber,
    required String course,
    required String department,
    required int yearOfStudy,
  }) async {
    try {
      final response = await apiClient.dio.post('auth/register/', data: {
        'full_name': fullName,
        'email': email,
        'password': password,
        'admission_number': admissionNumber,
        'course': course,
        'department': department,
        'year_of_study': yearOfStudy,
      });

      final token = response.data['token'];
      final userData = response.data['user'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

      return UserModel.fromJson(userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await apiClient.dio.post('auth/password/reset/', data: {'email': email});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
