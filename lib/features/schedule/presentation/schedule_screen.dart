import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/theme/app_theme.dart';
import 'providers/timetable_provider.dart';
import '../domain/models/timetable_session_model.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  int _selectedDayIndex = 0; // Default to Monday
  
  static const List<String> _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const List<String> _dayKeys = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  final List<Color> _cardColors = const [
    Color(0xFFEAF1FB), // Light Blue
    Color(0xFFF6F1FB), // Light Purple
    Color(0xFFF1FBF6), // Light Green
    Color(0xFFFBF6EA), // Light Orange
  ];

  @override
  void initState() {
    super.initState();
    // Proactively fetch active term & schedule if not loaded yet
    Future.microtask(() {
      final state = ref.read(timetableProvider);
      if (state.sessions.isEmpty && !state.isLoading) {
        ref.read(timetableProvider.notifier).fetchActiveTermAndSchedule();
      }
      
      // Auto-select current day of week
      final now = DateTime.now();
      // DateTime.monday = 1, so subtract 1 to get 0-index
      setState(() {
        _selectedDayIndex = now.weekday - 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final timetableState = ref.watch(timetableProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final horizontalPadding = screenWidth * 0.05;
    final maxContainerWidth = screenWidth < 400 ? screenWidth * 0.95 : 480.0;

    final selectedDayKey = _dayKeys[_selectedDayIndex];

    // Filter and sort today's classes
    final filteredSessions = timetableState.sessions
        .where((s) => s.dayOfWeek.toUpperCase() == selectedDayKey)
        .toList();

    filteredSessions.sort((a, b) {
      try {
        final aStart = a.timeRange.split('-')[0].trim().split(':');
        final bStart = b.timeRange.split('-')[0].trim().split(':');
        final aMin = int.parse(aStart[0]) * 60 + int.parse(aStart[1]);
        final bMin = int.parse(bStart[0]) * 60 + int.parse(bStart[1]);
        return aMin.compareTo(bMin);
      } catch (_) {
        return 0;
      }
    });

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
          'Class Schedule',
          style: TextStyle(
            color: AppTheme.getTextPrimary(context),
            fontWeight: FontWeight.bold,
            fontSize: screenWidth < 340 ? 18 : 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxWidth: maxContainerWidth,
              minHeight: screenHeight * 0.75,
            ),
            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
            padding: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: AppTheme.getSurface(context),
              borderRadius: BorderRadius.circular(isSmallScreen ? 20.0 : 24.0),
              border: Border.all(color: AppTheme.getBorder(context)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                
                // Day Selector
                _DaySelector(
                  days: _days,
                  selectedIndex: _selectedDayIndex,
                  onDaySelected: (index) {
                    setState(() {
                      _selectedDayIndex = index;
                    });
                  },
                  padding: horizontalPadding,
                  isSmallScreen: isSmallScreen,
                ),
                
                const SizedBox(height: 16),
                
                // Sessions list
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await ref.read(timetableProvider.notifier).fetchActiveTermAndSchedule();
                    },
                    child: _buildTimetableContent(
                      timetableState, 
                      filteredSessions, 
                      horizontalPadding, 
                      isSmallScreen
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimetableContent(
    TimetableState state, 
    List<TimetableSessionModel> sessions,
    double padding,
    bool isSmallScreen
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 40),
          child: Center(
            child: Column(
              children: [
                const Icon(Iconsax.danger, size: 48, color: AppTheme.error),
                const SizedBox(height: 16),
                Text(
                  'Failed to load timetable',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.getTextPrimary(context),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.getTextSecondary(context),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => ref.read(timetableProvider.notifier).fetchActiveTermAndSchedule(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (sessions.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 60),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Iconsax.calendar_1, 
                  size: 48, 
                  color: AppTheme.getTextSecondary(context).withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No classes today',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.getTextPrimary(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Enjoy your free day!',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.getTextSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return _ScheduleList(
      schedule: sessions, 
      colors: _cardColors,
      padding: padding, 
      isSmallScreen: isSmallScreen
    );
  }
}

class _DaySelector extends StatelessWidget {
  final List<String> days;
  final int selectedIndex;
  final ValueChanged<int> onDaySelected;
  final double padding;
  final bool isSmallScreen;
  
  const _DaySelector({
    required this.days,
    required this.selectedIndex,
    required this.onDaySelected,
    required this.padding,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    final dayBoxSize = isSmallScreen ? 32.0 : 40.0;
    final dayBoxRadius = isSmallScreen ? 8.0 : 12.0;
    final fontSize = isSmallScreen ? 11.0 : 14.0;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(days.length, (i) {
          final isSelected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onDaySelected(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: dayBoxSize,
              height: dayBoxSize * 1.2,
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.getSurface(context),
                borderRadius: BorderRadius.circular(dayBoxRadius),
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.getBorder(context),
                ),
              ),
              child: Center(
                child: Text(
                  days[i],
                  style: TextStyle(
                    fontSize: fontSize,
                    color: isSelected ? Colors.white : AppTheme.getTextPrimary(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ScheduleList extends StatelessWidget {
  final List<TimetableSessionModel> schedule;
  final List<Color> colors;
  final double padding;
  final bool isSmallScreen;
  
  const _ScheduleList({
    required this.schedule,
    required this.colors,
    required this.padding,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    final timeWidth = isSmallScreen ? 65.0 : 75.0;
    final cardPadding = isSmallScreen ? 10.0 : 12.0;
    final cardRadius = isSmallScreen ? 10.0 : 12.0;
    final titleFontSize = isSmallScreen ? 13.0 : 14.0;
    final subtitleFontSize = isSmallScreen ? 11.0 : 12.0;
    final codeFontSize = isSmallScreen ? 10.0 : 11.0;
    
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 8),
      itemCount: schedule.length,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        final item = schedule[i];
        final cardColor = colors[i % colors.length];

        return Padding(
          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 6.0 : 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time Label
              SizedBox(
                width: timeWidth,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    item.timeRange,
                    style: TextStyle(
                      color: AppTheme.getTextSecondary(context),
                      fontWeight: FontWeight.w600,
                      fontSize: isSmallScreen ? 10.0 : 11.0,
                    ),
                  ),
                ),
              ),
              
              // Course Detail Card
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(cardPadding),
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.15 : 0.9),
                    borderRadius: BorderRadius.circular(cardRadius),
                    border: Border.all(
                      color: cardColor.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.unitTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: titleFontSize,
                          color: AppTheme.getTextPrimary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.person, size: 14, color: AppTheme.getTextSecondary(context)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.lecturerName ?? 'No lecturer assigned',
                              style: TextStyle(
                                color: AppTheme.getTextPrimary(context).withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                                fontSize: subtitleFontSize,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 14, color: AppTheme.getTextSecondary(context)),
                              const SizedBox(width: 4),
                              Text(
                                item.roomCode ?? 'TBA',
                                style: TextStyle(
                                  color: AppTheme.getTextSecondary(context),
                                  fontWeight: FontWeight.w400,
                                  fontSize: codeFontSize,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            item.unitCode,
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: codeFontSize,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
