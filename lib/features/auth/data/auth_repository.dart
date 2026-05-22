import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';
import '../domain/models/user_model.dart';

class AuthRepository {
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post('accounts/auth/login/', data: {
        'email': email,
        'password': password,
      });

      final token = response.data['token'];
      final userData = _extractUserData(response.data);

      final prefs = await SharedPreferences.getInstance();
      if (token != null) {
        await prefs.setString('auth_token', token.toString());
      }

      return UserModel.fromJson(userData);
    } catch (e) {
      throw _handleError(e);
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
      final response = await apiClient.dio.post('accounts/auth/register/', data: {
        'full_name': fullName,
        'email': email,
        'password': password,
        'admission_number': admissionNumber,
        'course': course,
        'department': department,
        'year_of_study': yearOfStudy,
      });

      final token = response.data['token'];
      final userData = _extractUserData(response.data);

      final prefs = await SharedPreferences.getInstance();
      if (token != null) {
        await prefs.setString('auth_token', token.toString());
      }

      return UserModel.fromJson(userData);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await apiClient.dio.post('accounts/auth/password/reset/', data: {'email': email});
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<UserModel> fetchProfile() async {
    try {
      final response = await apiClient.dio.get('accounts/auth/profile/');
      return UserModel.fromJson(_extractUserData(response.data));
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> updateProfile({
    required String fullName,
    required String admissionNumber,
    required String course,
    required String department,
    required int yearOfStudy,
  }) async {
    try {
      final response = await apiClient.dio.patch('accounts/auth/profile/update/', data: {
        'full_name': fullName,
        'admission_number': admissionNumber,
        'course': course,
        'department': department,
        'year_of_study': yearOfStudy,
      });

      return UserModel.fromJson(_extractUserData(response.data));
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Extracts the user map from various response shapes:
  /// - `{ "token": "...", "user": { ... } }` → returns the inner user map
  /// - `{ "id": 1, "email": "...", ... }` → returns the map directly
  Map<String, dynamic> _extractUserData(dynamic data) {
    if (data is Map<String, dynamic>) {
      final user = data['user'];
      if (user is Map<String, dynamic>) return user;
      if (user is Map) return Map<String, dynamic>.from(user);
      if (data.containsKey('id') || data.containsKey('email') || data.containsKey('full_name')) {
        return data;
      }
    }

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final user = map['user'];
      if (user is Map) return Map<String, dynamic>.from(user);
      if (map.containsKey('id') || map.containsKey('email') || map.containsKey('full_name')) {
        return map;
      }
    }

    throw Exception('Invalid user response format');
  }

  /// Converts DioException server errors into readable Exception messages.
  Exception _handleError(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data.isNotEmpty) {
        if (data.containsKey('detail')) return Exception(data['detail'].toString());
        if (data.containsKey('message')) return Exception(data['message'].toString());
        final first = data.values.first;
        if (first is List && first.isNotEmpty) return Exception(first.first.toString());
        return Exception(data.toString());
      }
      return Exception(e.message ?? 'Network error. Please try again.');
    }
    if (e is Exception) return e;
    return Exception(e.toString());
  }
}
