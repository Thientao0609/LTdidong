import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class AuthService {
  static Future<void> sendFirebaseToken(String token) async {
    final response = await http.post(
      Uri.parse('${ApiService.baseUrl}/auth/firebase'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"token": token}),
    );

    if (response.statusCode != 200) {
      throw Exception("Backend auth failed");
    }
  }
}