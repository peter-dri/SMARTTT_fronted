import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../widgets/premium_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_auth_buttons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              // App Logo/Brand
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Iconsax.calendar_tick,
                    size: 40,
                    color: AppTheme.primary,
                  ),
                ),
              ).animate().fadeIn().scale().moveY(begin: 20, end: 0),
              
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ).animate().fadeIn(delay: 200.ms).moveY(begin: 10),
              
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Sign in to your Smart Timetable',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ).animate().fadeIn(delay: 300.ms).moveY(begin: 10),
              
              const SizedBox(height: 40),
              
              // Form fields
              const AuthTextField(
                hintText: 'Student ID or Email',
                icon: Iconsax.user,
              ).animate().fadeIn(delay: 400.ms).moveY(begin: 10),
              
              const SizedBox(height: 20),
              
              const AuthTextField(
                hintText: 'Password',
                icon: Iconsax.lock,
                isPassword: true,
              ).animate().fadeIn(delay: 500.ms).moveY(begin: 10),
              
              const SizedBox(height: 12),
              
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.pushNamed('forgot-password'),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms),
              
              const SizedBox(height: 32),
              
              PremiumButton(
                text: 'Sign In',
                onPressed: () {},
              ).animate().fadeIn(delay: 700.ms).scale(),
              
              const SizedBox(height: 40),
              
              Row(
                children: [
                  Expanded(child: Divider(color: AppTheme.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR CONTINUE WITH',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppTheme.border)),
                ],
              ).animate().fadeIn(delay: 800.ms),
              
              const SizedBox(height: 32),
              
              const SocialAuthButtons().animate().fadeIn(delay: 900.ms).moveY(begin: 10),
              
              const SizedBox(height: 40),
              
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                    TextButton(
                      onPressed: () => context.pushNamed('register'),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 1000.ms),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
