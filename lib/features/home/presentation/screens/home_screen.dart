import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/timetable_card.dart';
import '../widgets/stats_card.dart';
import '../../../schedule/presentation/schedule_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = [
    _HomeTab(),
    ScheduleScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
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
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              color: AppTheme.primary.withOpacity(0.1),
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
              onPressed: null,
              icon: const Icon(Iconsax.notification, color: AppTheme.textSecondary),
            ),
            IconButton(
              onPressed: null,
              icon: const Icon(Iconsax.profile_circle, color: AppTheme.textSecondary),
            ),
            // Debug: direct link to login (visible only in dev mode)
            if (kDebugMode)
              IconButton(
                onPressed: () => context.go('/login'),
                icon: const Icon(Iconsax.lock, color: Colors.red, size: 20),
                tooltip: 'Go to Login (Dev)',
              ),
          ],
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
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    icon: Iconsax.book,
                    label: 'Today\'s Classes',
                    value: '4',
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatsCard(
                    icon: Iconsax.box_tick,
                    label: 'Completed',
                    value: '2',
                    color: const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatsCard(
                    icon: Iconsax.clock,
                    label: 'Remaining',
                    value: '2',
                    color: AppTheme.secondary,
                  ),
                ),
              ],
            ).animate().fadeIn().moveY(begin: 20),

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
            Column(
              children: [
                TimetableCard(
                  time: '08:00 AM',
                  subject: 'Mathematics',
                  instructor: 'Dr. Smith',
                  location: 'Block A, Room 201',
                  color: AppTheme.primary,
                  isCompleted: true,
                ),
                TimetableCard(
                  time: '10:00 AM',
                  subject: 'Physics Lab',
                  instructor: 'Prof. Johnson',
                  location: 'Science Block, Lab 3',
                  color: const Color(0xFF10B981),
                  isCompleted: false,
                  isCurrent: true,
                ),
                TimetableCard(
                  time: '12:00 PM',
                  subject: 'Lunch Break',
                  instructor: '-',
                  location: 'Cafeteria',
                  color: AppTheme.secondary,
                  isCompleted: false,
                  isBreak: true,
                ),
                TimetableCard(
                  time: '02:00 PM',
                  subject: 'Computer Science',
                  instructor: 'Ms. Davis',
                  location: 'IT Block, Room 105',
                  color: AppTheme.accent,
                  isCompleted: false,
                ),
                TimetableCard(
                  time: '04:00 PM',
                  subject: 'Study Group',
                  instructor: 'Peer Session',
                  location: 'Library, Zone B',
                  color: const Color(0xFFF59E0B),
                  isCompleted: false,
                ),
              ],
            ).animate().fadeIn(delay: 200.ms).moveY(begin: 20),

            const SizedBox(height: 32),


          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: AppTheme.textSecondary,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.notification),
            label: 'Alerts',
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
        currentIndex: 0,
        onTap: (index) {
          if (index == 3) {
            context.pushNamed('profile');
          }
        },
      ),
      // floatingActionButton removed as requested
    );
  }
}
