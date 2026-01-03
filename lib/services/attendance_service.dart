import '../models/attendance.dart';

class AttendanceService {
  static final List<Attendance> _attendanceRecords = [];

  static Future<void> markAttendance(String studentId, String doctorId) async {
    final record = Attendance(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      studentId: studentId,
      doctorId: doctorId,
      timestamp: DateTime.now(),
    );
    _attendanceRecords.add(record);
    // print("Attendance marked for student $studentId by doctor $doctorId");
  }

  static List<Attendance> getRecords() {
    return _attendanceRecords;
  }
  
  // Helper to check if student is present today (optional utility)
  static bool isPresentToday(String studentId) {
    final now = DateTime.now();
    return _attendanceRecords.any((a) => 
      a.studentId == studentId && 
      a.timestamp.year == now.year &&
      a.timestamp.month == now.month &&
      a.timestamp.day == now.day
    );
  }
}
