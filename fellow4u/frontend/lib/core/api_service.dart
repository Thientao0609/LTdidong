import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  // Web/Real device: 127.0.0.1, Android Emulator: 10.0.2.2
  static const String baseUrl = kIsWeb 
      ? 'http://127.0.0.1:3000/api' 
      : 'http://10.0.2.2:3000/api';

  // Helper common method to handle requests
  static Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) async {
    try {
      print('Calling API: $baseUrl$path with body: $body');
      final response = await http.post(
        Uri.parse('$baseUrl$path'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.body.isEmpty) {
        return {'success': false, 'message': 'Server returned empty response'};
      }

      return jsonDecode(response.body);
    } catch (e) {
      print('API Error: $e');
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  static Future<dynamic> _get(String path) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$path'));
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  // 1. Login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    return await _post('/login', {'email': email, 'password': password});
  }

  // 2. Register
  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    return await _post('/register', {'name': name, 'email': email, 'password': password});
  }

  // 3. Get All Tours
  static Future<List<dynamic>> getTours() async {
    final result = await _get('/tours');
    return result is List ? result as List : [];
  }

  // ... (các methods khác giữ nguyên logic nhưng có thể dùng _get)
  static Future<List<dynamic>> getFeaturedTours() async {
    final result = await _get('/tours/featured');
    return result is List ? result as List : [];
  }

  static Future<List<dynamic>> getGuides() async {
    final result = await _get('/guides');
    return result is List ? result as List : [];
  }

  static Future<List<dynamic>> getNotifications() async {
    final result = await _get('/notifications');
    return result is List ? result as List : [];
  }

  static Future<List<dynamic>> getTrips() async {
    final result = await _get('/trips');
    return result is List ? result as List : [];
  }

  static Future<Map<String, dynamic>> createTrip(String title, String date) async {
    return await _post('/trips', {'title': title, 'date': date});
  }

  static Future<List<dynamic>> getChats() async {
    final result = await _get('/chats');
    return result is List ? result as List : [];
  }
}
