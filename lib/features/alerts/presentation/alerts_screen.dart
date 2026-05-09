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
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: AppTheme.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader('Today', context),
          const SizedBox(height: 16),
          _AlertCard(
            title: 'Class Rescheduled',
            description: 'Mathematics class has been moved to 10:00 AM in Room 302.',
            time: '2 hours ago',
            icon: Iconsax.calendar_edit,
            iconColor: const Color(0xFFF59E0B), // Warning/Orange
          ).animate().fadeIn().moveX(begin: -20),
          const SizedBox(height: 12),
          _AlertCard(
            title: 'System Update',
            description: 'The timetable system was updated successfully.',
            time: '5 hours ago',
            icon: Iconsax.info_circle,
            iconColor: AppTheme.primary, // Info/Blue
          ).animate().fadeIn(delay: 100.ms).moveX(begin: -20),
          
          const SizedBox(height: 32),
          _buildSectionHeader('Yesterday', context),
          const SizedBox(height: 16),
          
          _AlertCard(
            title: 'Class Cancelled',
            description: 'Physics Lab has been cancelled due to instructor illness.',
            time: 'Yesterday, 9:00 AM',
            icon: Iconsax.close_circle,
            iconColor: AppTheme.error, // Error/Red
          ).animate().fadeIn(delay: 200.ms).moveX(begin: -20),
          const SizedBox(height: 12),
          _AlertCard(
            title: 'Assignment Reminder',
            description: 'Don\'t forget to submit your Data Structures assignment.',
            time: 'Yesterday, 2:30 PM',
            icon: Iconsax.task_square,
            iconColor: const Color(0xFF10B981), // Success/Green
          ).animate().fadeIn(delay: 300.ms).moveX(begin: -20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color iconColor;

  const _AlertCard({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    height: 1.4,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
