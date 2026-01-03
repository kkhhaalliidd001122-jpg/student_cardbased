import 'database_service.dart';

enum UserRole { doctor, gatekeeper, student }

class AuthService {
  static Future<Map<String, dynamic>?> login(String username, String password, UserRole role) async {
    final db = DatabaseService();
    String roleStr;

    switch (role) {
      case UserRole.doctor:
        roleStr = 'doctor';
        break;
      case UserRole.gatekeeper:
        roleStr = 'gatekeeper';
        break;
      case UserRole.student:
        roleStr = 'student';
        break;
    }

    try {
      return await db.login(username, password, roleStr);
    } catch (e) {
      print('AuthService Error: $e');
      throw e.toString();
    }
  }
}
