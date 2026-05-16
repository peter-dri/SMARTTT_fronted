import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/timetable_card.dart';
import '../widgets/stats_card.dart';
import '../../../schedule/presentation/schedule_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../timetable/presentation/providers/timetable_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return _HomeTab();
      case 1:
        return const ScheduleScreen();
      case 2:
        return const ProfileScreen();
      default:
        return _HomeTab();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.textSecondary,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.calendar),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.profile_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This widget is kept for backward compatibility; the actual home tab is
    // built by _HomeTabConsumer.
    return const _HomeTabConsumer();
  }
}

class _HomeTabConsumer extends ConsumerWidget {
  const _HomeTabConsumer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTime = DateTime.now();
    String greeting = 'Good morning';
    if (currentTime.hour >= 12 && currentTime.hour < 16) {
      greeting = 'Good afternoon';
    } else if (currentTime.hour >= 16) {
      greeting = 'Good evening';
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.calendar_tick,
              color: AppTheme.primary,
              size: 24,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'My Timetable',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        actions: [
           IconButton(
             onPressed: () {},
             icon: const Icon(Iconsax.notification, color: AppTheme.textPrimary),
           ),
           IconButton(
             onPressed: () {
               ref.read(authProvider.notifier).logout();
               context.go('/login');
             },
             icon: const Icon(Iconsax.logout, color: AppTheme.textPrimary),
             tooltip: 'Logout',
           ),
           // Debug: direct link to login (visible only in dev mode)
           if (kDebugMode)
             IconButton(
               onPressed: () => context.go('/login'),
               icon: const Icon(Iconsax.lock, color: Colors.red, size: 20),
               tooltip: 'Go to Login (Dev)',
             ),
         ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Stats Row
            Consumer(
              builder: (context, ref, child) {
                final authState = ref.watch(authProvider);
                
                // Check if user is authenticated
                if (authState.user == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        const Icon(Iconsax.login, size: 64, color: AppTheme.primary),
                        const SizedBox(height: 24),
                        const Text(
                          'Please Login',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'You need to login to view your timetable',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () => GoRouter.of(context).go('/login'),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            child: Text('Go to Login'),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                final timetableAsync = ref.watch(timetableProvider);
                
                return timetableAsync.when(
                  data: (timetableSlots) {
                    final today = DateTime.now();
                    final weekday = today.weekday; // 1 = Monday, 7 = Sunday
                    final dayNames = ['', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
                    final todayDay = dayNames[weekday];
                    
                    // Calculate stats based on today's timetable
                    final todaysClasses = timetableSlots.where((slot) => 
                      slot.dayOfWeek.toLowerCase() == todayDay && !slot.isBreak
                    ).length;
                    
                    final completedClasses = timetableSlots.where((slot) => 
                      slot.dayOfWeek.toLowerCase() == todayDay && slot.isCompleted
                    ).length;
                    
                    final remainingClasses = timetableSlots.where((slot) => 
                      slot.dayOfWeek.toLowerCase() == todayDay && !slot.isCompleted && !slot.isBreak
                    ).length;
                    
                    return Row(
                      children: [
                        Expanded(
                          child: StatsCard(
                            icon: Iconsax.book,
                            label: 'Today\'s Classes',
                            value: todaysClasses.toString(),
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: StatsCard(
                            icon: Iconsax.box_tick,
                            label: 'Completed',
                            value: completedClasses.toString(),
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: StatsCard(
                            icon: Iconsax.clock,
                            label: 'Remaining',
                            value: remainingClasses.toString(),
                            color: AppTheme.secondary,
                          ),
                        ),
                      ],
                    ).animate().fadeIn().moveY(begin: 20);
                  },
                  loading: () => Row(
                    children: [
                      Expanded(
                        child: StatsCard(
                          icon: Iconsax.book,
                          label: 'Today\'s Classes',
                          value: '--',
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatsCard(
                          icon: Iconsax.box_tick,
                          label: 'Completed',
                          value: '--',
                          color: const Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatsCard(
                          icon: Iconsax.clock,
                          label: 'Remaining',
                          value: '--',
                          color: AppTheme.secondary,
                        ),
                      ),
                    ],
                  ).animate().fadeIn().moveY(begin: 20),
                  error: (e, stack) => Row(
                    children: [
                      Expanded(
                        child: StatsCard(
                          icon: Iconsax.book,
                          label: 'Today\'s Classes',
                          value: 'Error',
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatsCard(
                          icon: Iconsax.box_tick,
                          label: 'Completed',
                          value: 'Error',
                          color: const Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatsCard(
                          icon: Iconsax.clock,
                          label: 'Remaining',
                          value: 'Error',
                          color: AppTheme.secondary,
                        ),
                      ),
                    ],
                  ).animate().fadeIn().moveY(begin: 20),
                );
              },
            ),

            const SizedBox(height: 32),

            // Today's Schedule Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Schedule",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 100.ms).moveY(begin: 20),

            const SizedBox(height: 16),

            // Timetable Cards
            Consumer(
              builder: (context, ref, child) {
                final timetableAsync = ref.watch(timetableProvider);
                
                return timetableAsync.when(
                  data: (timetableSlots) {
                    if (timetableSlots.isEmpty) {
                      return Center(
                        child: Text(
                          'No timetable data available',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    }
                    
                    return Column(
                      children: timetableSlots.map((slot) {
                        // Parse time strings to extract hour/minute for display
                        final startTime = slot.startTime.isNotEmpty 
                            ? slot.startTime 
                            : '00:00';
                        
                        return TimetableCard(
                          time: startTime,
                          subject: slot.subject,
                          instructor: slot.instructor,
                          location: slot.location,
                          color: Color(int.parse(slot.color.replaceFirst('#', '0xFF'))),
                          isCompleted: slot.isCompleted,
                          isCurrent: slot.isCurrent,
                          isBreak: slot.isBreak,
                        );
                      }).toList(),
                    ).animate().fadeIn(delay: 200.ms).moveY(begin: 20);
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ).animate().fadeIn(delay: 200.ms).moveY(begin: 20),
                  error: (e, stack) => Center(
                    child: Text(
                      'Error loading timetable: $e',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red),
                    ),
                  ).animate().fadeIn(delay: 200.ms).moveY(begin: 20),
                );
              },
            ),

            const SizedBox(height: 32),


          ],
        ),
      ),
      // Bottom nav is handled by the parent HomeScreen.
    );
  }
}
