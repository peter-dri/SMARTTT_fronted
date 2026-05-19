class TimetableSessionModel {
  final int id;
  final String unitCode;
  final String unitTitle;
  final int unitCreditHours;
  final String dayDisplay;
  final String dayOfWeek;
  final String timeRange;
  final String? roomCode;
  final String? roomName;
  final String? roomBuilding;
  final String? lecturerName;
  final String? lecturerId;
  final String sessionType;
  final String sessionTypeDisplay;
  final String deliveryMode;
  final String studentGroup;
  final int maxStudents;
  final int currentEnrollment;

  TimetableSessionModel({
    required this.id,
    required this.unitCode,
    required this.unitTitle,
    required this.unitCreditHours,
    required this.dayDisplay,
    required this.dayOfWeek,
    required this.timeRange,
    this.roomCode,
    this.roomName,
    this.roomBuilding,
    this.lecturerName,
    this.lecturerId,
    required this.sessionType,
    required this.sessionTypeDisplay,
    required this.deliveryMode,
    required this.studentGroup,
    required this.maxStudents,
    required this.currentEnrollment,
  });

  factory TimetableSessionModel.fromJson(Map<String, dynamic> json) {
    return TimetableSessionModel(
      id: json['id'],
      unitCode: json['unit_code'] ?? '',
      unitTitle: json['unit_title'] ?? '',
      unitCreditHours: json['unit_credit_hours'] ?? 0,
      dayDisplay: json['day_display'] ?? '',
      dayOfWeek: json['day_of_week'] ?? '',
      timeRange: json['time_range'] ?? '',
      roomCode: json['room_code'],
      roomName: json['room_name'],
      roomBuilding: json['room_building'],
      lecturerName: json['lecturer_name'],
      lecturerId: json['lecturer_id'],
      sessionType: json['session_type'] ?? '',
      sessionTypeDisplay: json['session_type_display'] ?? '',
      deliveryMode: json['delivery_mode'] ?? '',
      studentGroup: json['student_group'] ?? '',
      maxStudents: json['max_students'] ?? 0,
      currentEnrollment: json['current_enrollment'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unit_code': unitCode,
      'unit_title': unitTitle,
      'unit_credit_hours': unitCreditHours,
      'day_display': dayDisplay,
      'day_of_week': dayOfWeek,
      'time_range': timeRange,
      'room_code': roomCode,
      'room_name': roomName,
      'room_building': roomBuilding,
      'lecturer_name': lecturerName,
      'lecturer_id': lecturerId,
      'session_type': sessionType,
      'session_type_display': sessionTypeDisplay,
      'delivery_mode': deliveryMode,
      'student_group': studentGroup,
      'max_students': maxStudents,
      'current_enrollment': currentEnrollment,
    };
  }
}
