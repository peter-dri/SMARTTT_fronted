import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/schedule/presentation/schedule_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

// Dev bypass: auto-redirect from login to home in debug mode
const bool kDevBypassAuth = kDebugMode;

final appRouter = GoRouter(
  initialLocation: '/register',
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
  ],
  redirect: (context, state) {
    // Get auth state from context
    final container = ProviderScope.containerOf(context, listen: false);
    final authState = container.read(authProvider);
    final isAuthenticated = authState.user != null;

    // List of protected routes (only for authenticated users)
    final protectedRoutes = ['/home', '/schedule', '/profile', '/edit-profile'];
    
    // List of auth routes (only for unauthenticated users)
    final authRoutes = ['/login', '/register', '/forgot-password'];

    final currentLocation = state.matchedLocation;

    // If user is not authenticated and trying to access protected routes
    if (!isAuthenticated && protectedRoutes.contains(currentLocation)) {
      return '/register';
    }

    // If user is authenticated and trying to access auth routes
    if (isAuthenticated && authRoutes.contains(currentLocation)) {
      return '/home';
    }

    // No redirection needed
    return null;
  },
);
