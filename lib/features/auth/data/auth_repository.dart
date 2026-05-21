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

      final userData = _extractUserData(response.data);
      final token = response.data is Map ? response.data['token'] : null;

      final prefs = await SharedPreferences.getInstance();
      if (token != null) {
        await prefs.setString('auth_token', token.toString());
      }

      return UserModel.fromJson(userData);
    } catch (e) {
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map && data.isNotEmpty) {
          if (data.containsKey('detail')) throw Exception(data['detail'].toString());
          if (data.containsKey('message')) throw Exception(data['message'].toString());
          // Flatten field errors like {"email": ["..."]}
          final first = data.values.first;
          if (first is List && first.isNotEmpty) throw Exception(first.first.toString());
          throw Exception(data.toString());
        }
        throw Exception(e.message ?? 'Network error');
      }
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
      final response = await apiClient.dio.post('accounts/auth/register/', data: {
        'full_name': fullName,
        'email': email,
        'password': password,
        'admission_number': admissionNumber,
        'course': course,
        'department': department,
        'year_of_study': yearOfStudy,
      });

      final userData = _extractUserData(response.data);
      final token = response.data is Map ? response.data['token'] : null;

      final prefs = await SharedPreferences.getInstance();
      if (token != null) {
        await prefs.setString('auth_token', token.toString());
      }

      return UserModel.fromJson(userData);
    } catch (e) {
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map && data.isNotEmpty) {
          if (data.containsKey('detail')) throw Exception(data['detail'].toString());
          if (data.containsKey('message')) throw Exception(data['message'].toString());
          final first = data.values.first;
          if (first is List && first.isNotEmpty) throw Exception(first.first.toString());
          throw Exception(data.toString());
        }
        throw Exception(e.message ?? 'Network error');
      }
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await apiClient.dio.post('accounts/auth/password/reset/', data: {'email': email});
    } catch (e) {
      rethrow;
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
      rethrow;
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
      rethrow;
    }
  }

  Map<String, dynamic> _extractUserData(dynamic data) {
    if (data is Map<String, dynamic>) {
      final user = data['user'];
      if (user is Map<String, dynamic>) {
        return user;
      }

      if (data.containsKey('id') || data.containsKey('email') || data.containsKey('full_name')) {
        return data;
      }
    }

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final user = map['user'];
      if (user is Map) {
        return Map<String, dynamic>.from(user);
      }

      if (map.containsKey('id') || map.containsKey('email') || map.containsKey('full_name')) {
        return map;
      }
    }

    throw Exception('Invalid user response');
  }
}
