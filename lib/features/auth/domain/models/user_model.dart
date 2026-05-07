class UserModel {
  final int id;
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
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      admissionNumber: json['admission_number'],
      course: json['course'],
      department: json['department'],
      yearOfStudy: json['year_of_study'],
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
