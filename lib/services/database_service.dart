import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  // Get Base URL from ApiService
  String get _baseUrl => ApiService.baseUrl;

  Future<Map<String, dynamic>?> login(String username, String password, String role) async {
    final url = Uri.parse('$_baseUrl/login');
    
    try {
      final response = await http.post(
        url,
        body: {
          'username': username,
          'password': password,
          'role': role,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data is Map<String, dynamic>) {
            if (data.containsKey('error')) {
               throw data['error'];
            }
            if (data.containsKey('success') && data['success'] == true) {
                return data['data'];
            }
        }
        throw "Unknown response format";
      } else {
        throw "Server error: ${response.statusCode}";
      }
    } catch (e) {
      print('API Error: $e');
      rethrow;
    }
  }

  Future<List<dynamic>> getStudents() async {
    final url = Uri.parse('$_baseUrl/students');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data['success'] == true) {
          return data['data'];
        }
        throw "Failed to load students";
      } else {
        throw "Server error: ${response.statusCode}";
      }
    } catch (e) {
      print('API Error: $e');
      rethrow;
    }
  }
}
