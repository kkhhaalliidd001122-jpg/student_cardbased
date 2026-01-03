import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/student_profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/gatekeeper_scan_screen.dart';
import 'screens/doctor_majors_screen.dart';
import 'screens/student_list_screen.dart';
import 'screens/doctor_attendance_screen.dart';

void main() {
  runApp(const UniversityApp());
}

class UniversityApp extends StatelessWidget {
  const UniversityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.cairoTextTheme(Theme.of(context).textTheme),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/student/profile': (context) => const StudentProfileScreen(),
        '/login': (context) => const LoginScreen(),
        '/gatekeeper/scan': (context) => const GatekeeperScanScreen(),
        '/doctor/majors': (context) => const DoctorMajorsScreen(),
        // These routes might need arguments, so generic routes or onGenerateRoute might be better, 
        // but for simple app, mapped routes + extracting arguments in build is okay.
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/doctor/students') {
          final majorId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => StudentListScreen(majorId: majorId),
          );
        }
        if (settings.name == '/doctor/attendance') {
           // We might pass an object or just nothing to open the scanner
           return MaterialPageRoute(
             builder: (context) => const DoctorAttendanceScreen(),
           );
        }
        return null;
      },
    );
  }
}
