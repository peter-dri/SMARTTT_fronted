import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_repository.dart';
import '../../domain/models/user_model.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({UserModel? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    Future.microtask(() => checkAuth());
    return AuthState();
  }

  Future<void> checkAuth() async {
    final repository = ref.read(authRepositoryProvider);
    state = state.copyWith(isLoading: true);
    try {
      final user = await repository.fetchProfile();
      state = AuthState(user: user, isLoading: false);
    } catch (e) {
      state = AuthState(isLoading: false);
    }
  }

  Future<void> login(String email, String password) async {
    final repository = ref.read(authRepositoryProvider);
    state = state.copyWith(isLoading: true);
    try {
      final user = await repository.login(email, password);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      final msg = e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString();
      state = state.copyWith(error: msg, isLoading: false);
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
    state = state.copyWith(isLoading: true);
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
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
        final msg = e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString();
        state = state.copyWith(error: msg, isLoading: false);
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
    state = state.copyWith(isLoading: true);
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
        final msg = e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString();
        state = state.copyWith(error: msg, isLoading: false);
    }
  }
}

final authRepositoryProvider = Provider((ref) => AuthRepository());

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
