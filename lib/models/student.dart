class Student {
  final String id;
  final String code; // 6-digit unique code
  final String name;
  final String majorId;
  final bool isTuitionPaid;

  Student({
    required this.id,
    required this.code,
    required this.name,
    required this.majorId,
    required this.isTuitionPaid,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'].toString(),
      code: json['student_code'] ?? '',
      name: json['name'] ?? '',
      majorId: json['major_id'].toString(),
      isTuitionPaid: (json['fees_paid'] == 1 || json['fees_paid'] == true),
    );
  }
}
