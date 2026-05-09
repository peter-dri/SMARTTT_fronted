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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Widget> get _screens => [
    _HomeTab(
      onViewSchedule: () => _onItemTapped(1),
    ),
    const ScheduleScreen(),
    const ProfileScreen(),
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
          BottomNavigationBarItem(
            icon: Icon(Iconsax.profile_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends ConsumerWidget {
  final VoidCallback onViewSchedule;

  const _HomeTab({super.key, required this.onViewSchedule});

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
              onPressed: () {
                context.pushNamed('alerts');
              },
              icon: const Icon(Iconsax.notification, color: AppTheme.textPrimary),
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
                  onPressed: onViewSchedule,
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
    );
  }
}
