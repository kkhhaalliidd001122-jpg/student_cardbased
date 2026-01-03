import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/student.dart';
import '../services/attendance_service.dart';

class StudentListScreen extends StatefulWidget {
  final String majorId;
  const StudentListScreen({super.key, required this.majorId});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Student> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    final allStudents = await ApiService.getStudents();
    setState(() {
      // Filter by majorId
      students = allStudents.where((s) => s.majorId == widget.majorId).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students: ${widget.majorId}'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: const Color(0xFFE8EAF6),
        child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty
              ? const Center(child: Text('No students found', style: TextStyle(fontSize: 18, color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    final isPresent = AttendanceService.isPresentToday(student.id);

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isPresent ? Colors.green.shade100 : Colors.grey.shade200,
                            radius: 25,
                            child: Icon(
                              Icons.person,
                              color: isPresent ? Colors.green : Colors.grey,
                              size: 30,
                            ),
                          ),
                          title: Text(
                            student.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.badge_outlined, size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text('ID: ${student.code}', style: const TextStyle(color: Colors.grey)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: student.isTuitionPaid ? Colors.green.shade50 : Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: student.isTuitionPaid ? Colors.green.shade200 : Colors.red.shade200),
                                  ),
                                  child: Text(
                                    student.isTuitionPaid ? 'Fees Paid' : 'Fees Pending',
                                    style: TextStyle(
                                      color: student.isTuitionPaid ? Colors.green : Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: isPresent
                              ? const Tooltip(
                                  message: 'Present',
                                  child: Icon(Icons.check_circle, color: Colors.green, size: 28),
                                )
                              : const Tooltip(
                                  message: 'Absent',
                                  child: Icon(Icons.cancel, color: Colors.redAccent, size: 28),
                                ),
                        ),
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Go to scanner, then refresh list when back
          await Navigator.pushNamed(context, '/doctor/attendance');
          setState(() {}); // Refresh list to show new attendance
        },
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
