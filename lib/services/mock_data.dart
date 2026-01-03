import '../models/student.dart';
import '../models/major.dart';

class MockData {
  static final List<Major> majors = [
    Major(id: 'CS', name: 'Computer Science'),
    Major(id: 'ENG', name: 'Engineering'),
    Major(id: 'MED', name: 'Medicine'),
    Major(id: 'BUS', name: 'Business Administration'),
  ];

  static final List<Student> students = [
    Student(id: '1', code: '123456', name: 'Khalid Al-Faleh', majorId: 'CS', isTuitionPaid: true),
    Student(id: '2', code: '654321', name: 'Ahmed Ali', majorId: 'ENG', isTuitionPaid: false),
    Student(id: '3', code: '112233', name: 'Sarah Smith', majorId: 'MED', isTuitionPaid: true),
    Student(id: '4', code: '998877', name: 'John Doe', majorId: 'CS', isTuitionPaid: true),
    Student(id: '5', code: '445566', name: 'Jane Doe', majorId: 'BUS', isTuitionPaid: false),
  ];

  // Username: Password
  static const Map<String, String> gatekeepers = {
    'gatekeeper': '1234',
    'security': 'admin',
  };

  static const Map<String, String> doctors = {
    'doctor': '1234',
    'prof': 'admin',
  };
}
