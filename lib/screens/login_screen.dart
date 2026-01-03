import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login(String roleArg) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      UserRole role;
      if (roleArg == 'gatekeeper') {
        role = UserRole.gatekeeper;
      } else if (roleArg == 'doctor') {
        role = UserRole.doctor;
      } else {
        role = UserRole.student;
      }
      final userData = await AuthService.login(
        _usernameController.text,
        _passwordController.text,
        role,
      );

      if (!mounted) return;

      if (userData != null) {
        if (role == UserRole.gatekeeper) {
          Navigator.pushReplacementNamed(context, '/gatekeeper/scan', arguments: userData);
        } else if (role == UserRole.doctor) {
          Navigator.pushReplacementNamed(context, '/doctor/majors', arguments: userData);
        } else {
          Navigator.pushReplacementNamed(context, '/student/profile', arguments: userData);
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid credentials (User not found)';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleArg = ModalRoute.of(context)!.settings.arguments as String;
    final isTeacher = roleArg == 'doctor';
    final roleTitle = roleArg == 'gatekeeper' 
        ? 'Gatekeeper' 
        : isTeacher 
            ? 'Teacher' 
            : 'Student';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isTeacher ? Icons.supervisor_account_outlined : Icons.lock_outline,
                          size: 60,
                          color: const Color(0xFF1A237E),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '$roleTitle Login',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: roleArg == 'student' ? 'Student Code' : 'Username',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.key),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 10),
                        if (_errorMessage.isNotEmpty)
                          Text(_errorMessage, style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 30),
                        if (_isLoading)
                          const CircularProgressIndicator()
                        else
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A237E),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => _login(roleArg),
                              child: const Text('Login', style: TextStyle(fontSize: 18)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

