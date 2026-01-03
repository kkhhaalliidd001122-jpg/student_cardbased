import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/mock_data.dart';
import '../models/student.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get student data from arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    // Handle case where args might be null (e.g. direct navigation, though unlikely in this flow) or Map
    
    // If no args (e.g. dev/test), fallback to mock. 
    // In real app, we might redirect to login.
    Student student;
    if (args is Map<String, dynamic>) {
      // Map DB fields to Student model
      // DB: id, name, major_id, fees_paid, student_code
      student = Student(
        id: args['id'].toString(),
        name: args['name'],
        majorId: args['major_id'].toString(), // Convert int to string
        code: args['student_code'],
        isTuitionPaid: args['fees_paid'] == 1, // TinyInt to bool
      );
    } else {
      student = MockData.students[0]; 
    } 

    return Scaffold(
      appBar: AppBar(title: const Text('Student Profile (طالب)')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
              const SizedBox(height: 20),
              Text(
                student.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Major: ${student.majorId}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: student.isTuitionPaid ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: student.isTuitionPaid ? Colors.green : Colors.red),
                ),
                child: Text(
                  student.isTuitionPaid ? 'Tuition Paid' : 'Tuition Not Paid',
                  style: TextStyle(
                    color: student.isTuitionPaid ? Colors.green.shade900 : Colors.red.shade900,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              QrImageView(
                data: student.code,
                version: QrVersions.auto,
                size: 250.0,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                'Student Code: ${student.code}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
