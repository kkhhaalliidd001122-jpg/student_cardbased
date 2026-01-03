import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A237E), Color(0xFF3949AB)], // Deep Indigo gradient
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.school_rounded,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              const Text(
                'University System',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    _buildRoleButton(
                      context,
                      'Student (طالب)',
                      Icons.person_outline, // Student icon
                      Colors.white,
                      const Color(0xFF1E88E5), // Blue
                      () => Navigator.pushNamed(context, '/login', arguments: 'student'),
                    ),
                    const SizedBox(height: 20),
                    _buildRoleButton(
                      context,
                      'Gatekeeper (بواب)',
                      Icons.local_police_outlined, // Gatekeeper icon
                      Colors.white,
                      const Color(0xFF43A047), // Green
                      () => Navigator.pushNamed(context, '/login', arguments: 'gatekeeper'),
                    ),
                    const SizedBox(height: 20),
                    _buildRoleButton(
                      context,
                      'Teacher (دكتور)',
                      Icons.supervisor_account_outlined, // Teacher icon
                      Colors.white,
                      const Color(0xFFE53935), // Red
                      () => Navigator.pushNamed(context, '/login', arguments: 'doctor'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(
    BuildContext context,
    String label,
    IconData icon,
    Color textColor,
    Color bgIconColor, // Not used in this style directly
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1A237E),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A237E).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF1A237E), size: 24),
            ),
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
