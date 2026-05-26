import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8000/api/v1/', // Pointing to local Django server (run 'adb reverse tcp:8000 tcp:8000' for physical devices)
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  ApiClient() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
    // Add logging for requests and responses to aid debugging (can be removed in production)
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, requestHeader: false, responseHeader: false));
  }
}

final apiClient = ApiClient();
