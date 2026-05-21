class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String? admissionNumber;
  final String? course;
  final String? department;
  final int? yearOfStudy;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.admissionNumber,
    this.course,
    this.department,
    this.yearOfStudy,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      admissionNumber: json['admission_number']?.toString(),
      course: json['course']?.toString(),
      department: json['department']?.toString(),
      yearOfStudy: json['year_of_study'] is int
          ? json['year_of_study'] as int
          : int.tryParse(json['year_of_study']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'admission_number': admissionNumber,
      'course': course,
      'department': department,
      'year_of_study': yearOfStudy,
    };
  }
}
