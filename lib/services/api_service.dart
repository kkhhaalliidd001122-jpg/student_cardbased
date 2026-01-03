import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/major.dart';
import '../models/student.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) {
      return 'http://localhost:3000/api';
    }
    return 'http://10.0.2.2:3000/api';
  } 

  static Future<List<Major>> getMajors() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/majors'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((e) => Major.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print('Error fetching majors: $e');
    }
    return [];
  }

  static Future<List<Student>> getStudents() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/students'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
            final List<dynamic> data = jsonResponse['data'];
            return data.map((e) => Student.fromJson(e)).toList();
        }
      }
    } catch (e) {
        print('Error fetching students: $e');
    }
    return [];
  }
}
