import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/major.dart';

class DoctorMajorsScreen extends StatefulWidget {
  const DoctorMajorsScreen({super.key});

  @override
  State<DoctorMajorsScreen> createState() => _DoctorMajorsScreenState();
}

class _DoctorMajorsScreenState extends State<DoctorMajorsScreen> {
  List<Major> majors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMajors();
  }

  Future<void> _fetchMajors() async {
    final data = await ApiService.getMajors();
    setState(() {
      majors = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Major (تخصص)'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
         color: const Color(0xFFE8EAF6),
         child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : majors.isEmpty
              ? const Center(child: Text('No majors found', style: TextStyle(fontSize: 18, color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: majors.length,
                  itemBuilder: (context, index) {
                    final major = majors[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/doctor/students',
                            arguments: major.id,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3949AB).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.school, size: 32, color: Color(0xFF3949AB)),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  major.name,
                                  style: const TextStyle(
                                    fontSize: 20, 
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A237E),
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/doctor/attendance');
        },
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan Attendance'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
    );
  }
}
