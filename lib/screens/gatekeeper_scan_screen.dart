import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/mock_data.dart';
import '../models/student.dart';

class GatekeeperScanScreen extends StatefulWidget {
  const GatekeeperScanScreen({super.key});

  @override
  State<GatekeeperScanScreen> createState() => _GatekeeperScanScreenState();
}

class _GatekeeperScanScreenState extends State<GatekeeperScanScreen> {
  final _codeController = TextEditingController();
  Student? _foundStudent;
  bool _isScanning = false;
  String _message = '';

  void _searchStudent(String code) {
    setState(() {
      _foundStudent = null;
      _message = '';
    });

    try {
      final student = MockData.students.firstWhere(
        (s) => s.code == code,
      );
      setState(() {
        _foundStudent = student;
        _isScanning = false; // Stop scanning if success
      });
    } catch (e) {
      setState(() {
        _message = 'Student not found with code: $code';
        _isScanning = false;
      });
    }
  }

  void _onScanDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        debugPrint('Barcode found! ${barcode.rawValue}');
        _searchStudent(barcode.rawValue!);
        break; 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gatekeeper Check')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Scanner Section
            if (_isScanning)
              SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    MobileScanner(
                      onDetect: _onScanDetect,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () => setState(() => _isScanning = false),
                          child: const Text('Stop Scanning'),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                 height: 200,
                 color: Colors.grey.shade200,
                 child: Center(
                   child: ElevatedButton.icon(
                     onPressed: () => setState(() => _isScanning = true),
                     icon: const Icon(Icons.qr_code_scanner, size: 40),
                     label: const Text('Scan QR Code'),
                   ),
                 ),
              ),

             const Divider(),

             // Manual Entry Section
             Padding(
               padding: const EdgeInsets.all(16.0),
               child: Row(
                 children: [
                   Expanded(
                     child: TextField(
                       controller: _codeController,
                       decoration: const InputDecoration(
                         labelText: 'Enter 6-digit Code',
                         border: OutlineInputBorder(),
                       ),
                       keyboardType: TextInputType.number,
                     ),
                   ),
                   const SizedBox(width: 10),
                   IconButton.filled(
                     onPressed: () => _searchStudent(_codeController.text),
                     icon: const Icon(Icons.search),
                   ),
                 ],
               ),
             ),

             const Divider(),

             // Results Section
             if (_message.isNotEmpty)
               Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: Text(_message, style: const TextStyle(color: Colors.red, fontSize: 16)),
               ),

             if (_foundStudent != null)
               Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: Card(
                   elevation: 4,
                   child: Padding(
                     padding: const EdgeInsets.all(16.0),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.stretch,
                       children: [
                         Text(
                           _foundStudent!.name,
                           style: Theme.of(context).textTheme.headlineSmall,
                           textAlign: TextAlign.center,
                         ),
                         const SizedBox(height: 10),
                         Text('Major: ${_foundStudent!.majorId}', textAlign: TextAlign.center),
                         const SizedBox(height: 20),
                         Container(
                          padding: const EdgeInsets.all(10),
                          color: _foundStudent!.isTuitionPaid ? Colors.green : Colors.red,
                          child: Text(
                            _foundStudent!.isTuitionPaid ? 'PAID' : 'NOT PAID',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                         ),
                       ],
                     ),
                   ),
                 ),
               ),
          ],
        ),
      ),
    );
  }
}
