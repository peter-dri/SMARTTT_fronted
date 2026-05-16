import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedDayIndex = 2; // Default to Wednesday (index 2)
  
  static const List<String> _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  
  static final List<List<Map<String, dynamic>>> _weeklySchedule = [
    // Monday
    [
      {'time': '9:00 AM', 'title': 'English Literature', 'instructor': 'Dr. Williams', 'code': 'ENG-304', 'color': Color(0xFFEAF1FB)},
      {'time': '10:30 AM', 'title': 'Data Structures', 'instructor': 'Prof. Martinez', 'code': 'CS-201', 'color': Color(0xFFF6F1FB)},
      {'time': '12:00 PM', 'title': 'Lunch Break', 'isBreak': true},
      {'time': '2:00 PM', 'title': 'Calculus II', 'instructor': 'Dr. Thompson', 'code': 'MATH-105', 'color': Color(0xFFF1FBF6)},
      {'time': '3:30 PM', 'title': 'Physics Lab', 'instructor': 'Prof. Anderson', 'code': 'SCI-B12', 'color': Color(0xFFFBF6EA)},
    ],
    // Tuesday
    [
      {'time': '8:00 AM', 'title': 'Mathematics', 'instructor': 'Dr. Smith', 'code': 'MATH-101', 'color': Color(0xFFEAF1FB)},
      {'time': '10:00 AM', 'title': 'Computer Science', 'instructor': 'Ms. Davis', 'code': 'CS-201', 'color': Color(0xFFF6F1FB)},
      {'time': '12:00 PM', 'title': 'Lunch Break', 'isBreak': true},
      {'time': '1:00 PM', 'title': 'History', 'instructor': 'Prof. Johnson', 'code': 'HIS-202', 'color': Color(0xFFF1FBF6)},
      {'time': '3:00 PM', 'title': 'Physics', 'instructor': 'Dr. Brown', 'code': 'PHY-101', 'color': Color(0xFFFBF6EA)},
    ],
    // Wednesday
    [
      {'time': '9:00 AM', 'title': 'English Literature', 'instructor': 'Dr. Williams', 'code': 'ENG-304', 'color': Color(0xFFEAF1FB)},
      {'time': '10:30 AM', 'title': 'Data Structures', 'instructor': 'Prof. Martinez', 'code': 'CS-201', 'color': Color(0xFFF6F1FB)},
      {'time': '12:00 PM', 'title': 'Lunch Break', 'isBreak': true},
      {'time': '2:00 PM', 'title': 'Calculus II', 'instructor': 'Dr. Thompson', 'code': 'MATH-105', 'color': Color(0xFFF1FBF6)},
      {'time': '3:30 PM', 'title': 'Physics Lab', 'instructor': 'Prof. Anderson', 'code': 'SCI-B12', 'color': Color(0xFFFBF6EA)},
    ],
    // Thursday
    [
      {'time': '8:00 AM', 'title': 'Mathematics', 'instructor': 'Dr. Smith', 'code': 'MATH-101', 'color': Color(0xFFEAF1FB)},
      {'time': '10:00 AM', 'title': 'Computer Science', 'instructor': 'Ms. Davis', 'code': 'CS-201', 'color': Color(0xFFF6F1FB)},
      {'time': '12:00 PM', 'title': 'Lunch Break', 'isBreak': true},
      {'time': '1:00 PM', 'title': 'History', 'instructor': 'Prof. Johnson', 'code': 'HIS-202', 'color': Color(0xFFF1FBF6)},
      {'time': '3:00 PM', 'title': 'Physics', 'instructor': 'Dr. Brown', 'code': 'PHY-101', 'color': Color(0xFFFBF6EA)},
    ],
    // Friday
    [
      {'time': '9:00 AM', 'title': 'English Literature', 'instructor': 'Dr. Williams', 'code': 'ENG-304', 'color': Color(0xFFEAF1FB)},
      {'time': '10:30 AM', 'title': 'Data Structures', 'instructor': 'Prof. Martinez', 'code': 'CS-201', 'color': Color(0xFFF6F1FB)},
      {'time': '12:00 PM', 'title': 'Lunch Break', 'isBreak': true},
      {'time': '2:00 PM', 'title': 'Calculus II', 'instructor': 'Dr. Thompson', 'code': 'MATH-105', 'color': Color(0xFFF1FBF6)},
      {'time': '3:30 PM', 'title': 'Physics Lab', 'instructor': 'Prof. Anderson', 'code': 'SCI-B12', 'color': Color(0xFFFBF6EA)},
    ],
    // Saturday
    [
      {'time': '10:00 AM', 'title': 'Study Group', 'instructor': 'Peer Session', 'code': 'GRP-01', 'color': Color(0xFFEAF1FB)},
      {'time': '12:00 PM', 'title': 'Sports', 'instructor': 'Coach Mike', 'code': 'SPT-01', 'color': Color(0xFFF6F1FB)},
      {'time': '2:00 PM', 'title': 'Project Work', 'instructor': 'Self Study', 'code': 'PRJ-01', 'color': Color(0xFFF1FBF6)},
    ],
    // Sunday
    [
      {'time': '11:00 AM', 'title': 'Reading Club', 'instructor': 'Ms. Sarah', 'code': 'CLUB-01', 'color': Color(0xFFEAF1FB)},
      {'time': '2:00 PM', 'title': 'Assignment', 'instructor': 'Self Study', 'code': 'ASG-01', 'color': Color(0xFFFBF6EA)},
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final horizontalPadding = screenWidth * 0.05; // 5% of screen width
    final maxContainerWidth = screenWidth < 400 ? screenWidth * 0.95 : 480.0;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(isSmallScreen ? 20.0 : 24.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(horizontalPadding, screenHeight * 0.025, horizontalPadding, 0),
                  child: Text(
                    'Class Schedule',
                    style: TextStyle(
                      fontSize: screenWidth < 340 ? 18 : (screenWidth < 360 ? 20 : 24),
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
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
                SizedBox(height: screenHeight * 0.01),
                Expanded(child: _ScheduleList(schedule: _weeklySchedule[_selectedDayIndex], padding: horizontalPadding, isSmallScreen: isSmallScreen)),
              ],
            ),
          ),
        ),
      ),
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
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: dayBoxSize,
                  height: dayBoxSize * 1.2,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(dayBoxRadius),
                  ),
                  child: Center(
                    child: Text(
                      days[i],
                      style: TextStyle(
                        fontSize: fontSize,
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _ScheduleList extends StatelessWidget {
  final List<Map<String, dynamic>> schedule;
  final double padding;
  final bool isSmallScreen;
  
  const _ScheduleList({
    required this.schedule,
    required this.padding,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    final timeWidth = isSmallScreen ? 50.0 : 60.0;
    final cardPadding = isSmallScreen ? 10.0 : 12.0;
    final cardRadius = isSmallScreen ? 10.0 : 12.0;
    final breakWidth = isSmallScreen ? 140.0 : 180.0;
    final breakHeight = isSmallScreen ? 32.0 : 36.0;
    final titleFontSize = isSmallScreen ? 13.0 : 14.0;
    final subtitleFontSize = isSmallScreen ? 11.0 : 12.0;
    final codeFontSize = isSmallScreen ? 10.0 : 11.0;
    
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 8),
      itemCount: schedule.length,
      itemBuilder: (context, i) {
        final item = schedule[i];
        if (item['isBreak'] == true) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Container(
                width: breakWidth,
                height: breakHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid, width: 1),
                  borderRadius: BorderRadius.circular(cardRadius),
                  color: Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    '${item['title'] ?? 'Break'}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: isSmallScreen ? 12.0 : 13.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 4.0 : 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: timeWidth,
                child: Text(
                  item['time'] as String,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: isSmallScreen ? 11.0 : 13.0,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(cardPadding),
                  decoration: BoxDecoration(
                    color: item['color'] as Color?,
                    borderRadius: BorderRadius.circular(cardRadius),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: titleFontSize,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item['instructor'] != null) ...[
                        SizedBox(height: isSmallScreen ? 2.0 : 3.0),
                        Text(
                          item['instructor'] as String,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: subtitleFontSize,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item['code'] as String,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: codeFontSize,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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
