import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ProfileService {
  static Future<Map<String, dynamic>> getProfileData() async {
    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}/profile'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile data: ${response.statusCode}');
    }
  }
}
