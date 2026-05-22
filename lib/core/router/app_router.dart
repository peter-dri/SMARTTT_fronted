import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/schedule/presentation/schedule_screen.dart';
import '../../features/alerts/presentation/alerts_screen.dart';

/// A [ChangeNotifier] that listens to [AuthNotifier] and triggers
/// GoRouter to re-evaluate redirects whenever auth state changes.
class AuthRouterNotifier extends ChangeNotifier {
  AuthRouterNotifier(this.ref) {
    ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }

  final Ref ref;
}

/// Provider for the router notifier so we can pass Ref to it.
final authRouterNotifierProvider = Provider((ref) => AuthRouterNotifier(ref));

GoRouter createRouter(Ref ref) {
  final notifier = ref.read(authRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: notifier,
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/schedule',
        name: 'schedule',
        builder: (context, state) => const ScheduleScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/alerts',
        name: 'alerts',
        builder: (context, state) => const AlertsScreen(),
      ),
    ],
    redirect: (context, state) async {
      final authState = ref.read(authProvider);
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password';

      // Still initializing (loading with no user yet)
      if (authState.isLoading) return null;

      final isAuthenticated = authState.user != null;

      if (!isAuthenticated) {
        // Fallback: also check SharedPreferences token
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token == null && !isLoggingIn) return '/login';
        return null;
      } else {
        if (isLoggingIn) return '/home';
      }
      return null;
    },
  );
}

// A simple global router for compatibility; replaced by createRouter in app.
final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/schedule',
      name: 'schedule',
      builder: (context, state) => const ScheduleScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      name: 'edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/alerts',
      name: 'alerts',
      builder: (context, state) => const AlertsScreen(),
    ),
  ],
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final isLoggingIn = state.matchedLocation == '/login' ||
        state.matchedLocation == '/register' ||
        state.matchedLocation == '/forgot-password';

    if (token == null) {
      if (!isLoggingIn) return '/login';
    } else {
      if (isLoggingIn) return '/home';
    }
    return null;
  },
);
