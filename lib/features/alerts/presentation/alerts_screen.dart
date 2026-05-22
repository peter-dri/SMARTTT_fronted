import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_theme.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getBackground(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_2, color: AppTheme.getTextPrimary(context)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: AppTheme.getTextPrimary(context),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.notification,
                  size: 56,
                  color: AppTheme.primary,
                ),
              ).animate().scale(delay: 100.ms),
              const SizedBox(height: 28),
              Text(
                'Notifications Coming Soon',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms).moveY(begin: 10),
              const SizedBox(height: 12),
              Text(
                'Push notifications and timetable change alerts will appear here once enabled by your institution.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms).moveY(begin: 10),
            ],
          ),
        ),
      ),
    );
  }
}
