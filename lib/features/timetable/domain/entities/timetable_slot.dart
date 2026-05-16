class TimetableSlot {
  final String id;
  final String subject;
  final String instructor;
  final String location;
  final String startTime;
  final String endTime;
  final String dayOfWeek;
  final bool isCompleted;
  final bool isCurrent;
  final bool isBreak;
  final String color; // We'll store as hex string and convert to Color in the UI

  const TimetableSlot({
    required this.id,
    required this.subject,
    required this.instructor,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.dayOfWeek,
    this.isCompleted = false,
    this.isCurrent = false,
    this.isBreak = false,
    required this.color,
  });

  factory TimetableSlot.fromJson(Map<String, dynamic> json) {
    return TimetableSlot(
      id: json['id'] ?? '',
      subject: json['subject'] ?? json['curriculum_unit_display'] ?? '',
      instructor: json['instructor'] ?? json['lecturer_display'] ?? '',
      location: json['location'] ?? json['room_display'] ?? '',
      startTime: json['start_time'] ?? json['startTime'] ?? '',
      endTime: json['end_time'] ?? json['endTime'] ?? '',
      dayOfWeek: json['day_of_week'] ?? json['dayOfWeek'] ?? '',
      isCompleted: json['is_completed'] ?? json['isCompleted'] ?? false,
      isCurrent: json['is_current'] ?? json['isCurrent'] ?? false,
      isBreak: json['is_break'] ?? json['isBreak'] ?? false,
      color: json['color'] ?? '#000000',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'instructor': instructor,
      'location': location,
      'start_time': startTime,
      'end_time': endTime,
      'day_of_week': dayOfWeek,
      'is_completed': isCompleted,
      'is_current': isCurrent,
      'is_break': isBreak,
      'color': color,
    };
  }
}