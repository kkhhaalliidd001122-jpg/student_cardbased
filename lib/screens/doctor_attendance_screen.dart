import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/mock_data.dart';
import '../services/attendance_service.dart';
import '../models/student.dart';

class DoctorAttendanceScreen extends StatefulWidget {
  const DoctorAttendanceScreen({super.key});

  @override
  State<DoctorAttendanceScreen> createState() => _DoctorAttendanceScreenState();
}

class _DoctorAttendanceScreenState extends State<DoctorAttendanceScreen> {
  final _codeController = TextEditingController();
  bool _isScanning = false;
  String _message = '';
  bool _isSuccess = false;

  void _markAttendance(String code) async {
    setState(() {
      _message = '';
      _isSuccess = false;
    });

    try {
      final student = MockData.students.firstWhere(
        (s) => s.code == code,
      );
      
      // Mark attendance
      await AttendanceService.markAttendance(
        student.id, 
        'doctor_current', // Ideally from auth context
      );
      
      if (!mounted) return;

      setState(() {
        _message = 'Attendance Marked: ${student.name}';
        _isSuccess = true;
        _isScanning = false;
        _codeController.clear();
      });

      // Auto hide success after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
           setState(() {
             _message = '';
             _isSuccess = false;
           });
           // Optionally restart scanner?
           // setState(() => _isScanning = true);
        }
      });

    } catch (e) {
      if (!mounted) return;
      setState(() {
        _message = 'Student not found: $code';
        _isSuccess = false;
      });
    }
  }

  void _onScanDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        _markAttendance(barcode.rawValue!);
        break; 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mark Attendance')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Scanner
             if (_isScanning)
              SizedBox(
                height: 350,
                child: Stack(
                  children: [
                    MobileScanner(
                      onDetect: _onScanDetect,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () => setState(() => _isScanning = false),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                          child: const Text('Stop Scanner'),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                 height: 250,
                 width: double.infinity,
                 color: Colors.grey.shade100,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     const Icon(Icons.qr_code_scanner, size: 80, color: Colors.indigo),
                     const SizedBox(height: 10),
                     ElevatedButton(
                       onPressed: () => setState(() => _isScanning = true),
                       child: const Text('Open Camera Scanner'),
                     ),
                   ],
                 ),
              ),

             const SizedBox(height: 20),
             
             // Manual
             Padding(
               padding: const EdgeInsets.all(16.0),
               child: Row(
                 children: [
                   Expanded(
                     child: TextField(
                       controller: _codeController,
                       decoration: const InputDecoration(
                         labelText: 'Enter Student 6-Digit Code',
                         border: OutlineInputBorder(),
                       ),
                       keyboardType: TextInputType.number,
                     ),
                   ),
                   const SizedBox(width: 10),
                   ElevatedButton(
                     onPressed: () => _markAttendance(_codeController.text),
                     style: ElevatedButton.styleFrom(
                       minimumSize: const Size(50, 50),
                       padding: const EdgeInsets.symmetric(horizontal: 10),
                     ),
                     child: const Icon(Icons.check),
                   ),
                 ],
               ),
             ),
             
             const Divider(),

             // Feedback
             if (_message.isNotEmpty)
               Container(
                 margin: const EdgeInsets.all(16),
                 padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(
                   color: _isSuccess ? Colors.green.shade100 : Colors.red.shade100,
                   borderRadius: BorderRadius.circular(10),
                   border: Border.all(color: _isSuccess ? Colors.green : Colors.red),
                 ),
                 child: Row(
                   children: [
                     Icon(
                       _isSuccess ? Icons.check_circle : Icons.error,
                       color: _isSuccess ? Colors.green : Colors.red,
                     ),
                     const SizedBox(width: 10),
                     Expanded(
                       child: Text(
                         _message,
                         style: TextStyle(
                           color: _isSuccess ? Colors.green.shade900 : Colors.red.shade900,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
          ],
        ),
      ),
    );
  }
}
