import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';
import '../../domain/models/user_model.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

String _extractErrorMessage(Object e) {
  // Repository already converts DioException → Exception with a clean message.
  // But handle raw DioException as a fallback just in case.
  if (e is DioException) {
    final data = e.response?.data;
    if (data is Map) {
      return data['detail']?.toString() ??
          data['message']?.toString() ??
          data.values.first.toString();
    }
    return e.message ?? 'Network error. Please try again.';
  }
  // Strip the "Exception: " prefix added by Dart's Exception.toString()
  final msg = e.toString();
  return msg.startsWith('Exception: ') ? msg.substring(11) : msg;
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    Future.microtask(() => checkAuth());
    return AuthState();
  }

  Future<void> checkAuth() async {
    final repository = ref.read(authRepositoryProvider);
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await repository.fetchProfile();
      state = AuthState(user: user, isLoading: false);
    } catch (e) {
      state = AuthState(isLoading: false);
    }
  }

  Future<void> login(String email, String password) async {
    final repository = ref.read(authRepositoryProvider);
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await repository.login(email, password);
      state = AuthState(user: user, isLoading: false);
    } catch (e) {
      state = AuthState(isLoading: false, error: _extractErrorMessage(e));
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String admissionNumber,
    required String course,
    required String department,
    required int yearOfStudy,
  }) async {
    final repository = ref.read(authRepositoryProvider);
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await repository.register(
        fullName: fullName,
        email: email,
        password: password,
        admissionNumber: admissionNumber,
        course: course,
        department: department,
        yearOfStudy: yearOfStudy,
      );
      state = AuthState(user: user, isLoading: false);
    } catch (e) {
      state = AuthState(isLoading: false, error: _extractErrorMessage(e));
    }
  }

  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.logout();
    state = AuthState();
  }

  Future<void> updateProfile({
    required String fullName,
    required String admissionNumber,
    required String course,
    required String department,
    required int yearOfStudy,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.updateProfile(
        fullName: fullName,
        admissionNumber: admissionNumber,
        course: course,
        department: department,
        yearOfStudy: yearOfStudy,
      );
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: _extractErrorMessage(e), isLoading: false);
    }
  }
}

final authRepositoryProvider = Provider((ref) => AuthRepository());

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
