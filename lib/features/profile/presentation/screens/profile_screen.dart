import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final themeMode = ref.watch(themeProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppTheme.getBackground(context),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Iconsax.arrow_left_2),
        ),
        title: const Text('My Profile'),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed('edit-profile'),
            icon: const Icon(Iconsax.edit, color: AppTheme.primary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primary.withValues(alpha: 0.1),
                          border: Border.all(color: AppTheme.primary, width: 2),
                        ),
                        child: const Icon(Iconsax.user, size: 50, color: AppTheme.primary),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                          child: const Icon(Iconsax.camera, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.fullName ?? 'Student Name',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Text(
                    user?.email ?? 'student@university.edu',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ).animate().fadeIn().scale(),

            const SizedBox(height: 32),

            // Academic Info
            _buildSection(
              context,
              title: 'Academic Information',
              children: [
                _buildInfoTile(context, Iconsax.book, 'Admission', user?.admissionNumber ?? 'N/A'),
                _buildInfoTile(context, Iconsax.teacher, 'Course', user?.course ?? 'N/A'),
                _buildInfoTile(context, Iconsax.building_3, 'Department', user?.department ?? 'N/A'),
                _buildInfoTile(context, Iconsax.calendar_1, 'Year of Study', '${user?.yearOfStudy ?? 0}'),
              ],
            ).animate().fadeIn(delay: 100.ms).moveY(begin: 20),

            const SizedBox(height: 24),

            // App Preferences
            _buildSection(
              context,
              title: 'App Preferences',
              children: [
                _buildToggleTile(
                  context,
                  Iconsax.moon,
                  'Dark Mode',
                  themeMode == ThemeMode.dark,
                  (val) => ref.read(themeProvider.notifier).toggleTheme(),
                ),
                _buildToggleTile(
                  context,
                  Iconsax.notification,
                  'Push Notifications',
                  true, // Mock value
                  (val) {},
                ),
                _buildActionTile(context, Iconsax.translate, 'Language', 'English', () {}),
              ],
            ).animate().fadeIn(delay: 200.ms).moveY(begin: 20),

            const SizedBox(height: 24),

            // Support & Feedback
            _buildSection(
              context,
              title: 'Support & Feedback',
              children: [
                _buildActionTile(context, Iconsax.message_question, 'Contact University Support', null, () {}),
                _buildActionTile(context, Iconsax.danger, 'Report a Bug', null, () {}),
                _buildActionTile(context, Iconsax.info_circle, 'Terms & Conditions', null, () {}),
              ],
            ).animate().fadeIn(delay: 300.ms).moveY(begin: 20),

            const SizedBox(height: 24),

            // Account Actions
            _buildSection(
              context,
              title: 'Account',
              children: [
                _buildActionTile(context, Iconsax.lock, 'Change Password', null, () {}),
                _buildActionTile(
                  context,
                  Iconsax.logout,
                  'Logout',
                  null,
                  () {
                    ref.read(authProvider.notifier).logout();
                    context.go('/login');
                  },
                  isDestructive: true,
                ),
              ],
            ).animate().fadeIn(delay: 400.ms).moveY(begin: 20),

            const SizedBox(height: 32),

            // Version Info
            Center(
              child: Column(
                children: [
                  Text('Smart Timetable v1.0.0', style: TextStyle(color: AppTheme.getTextSecondary(context), fontSize: 12)),
                  const SizedBox(height: 4),
                  Text('www.university.edu', style: TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ).animate().fadeIn(delay: 500.ms),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.getTextSecondary(context))),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.getSurface(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.getBorder(context)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoTile(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.getTextSecondary(context)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: AppTheme.getTextSecondary(context))),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTile(BuildContext context, IconData icon, String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.getTextSecondary(context)),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
          Switch.adaptive(value: value, onChanged: onChanged, activeThumbColor: AppTheme.primary),
        ],
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, IconData icon, String label, String? value, VoidCallback onTap, {bool isDestructive = false}) {
    final color = isDestructive ? AppTheme.error : AppTheme.getTextPrimary(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isDestructive ? color : AppTheme.getTextSecondary(context)),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color))),
            if (value != null) Text(value, style: TextStyle(fontSize: 14, color: AppTheme.getTextSecondary(context))),
            const SizedBox(width: 8),
            Icon(Iconsax.arrow_right_3, size: 14, color: AppTheme.getTextSecondary(context).withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}
