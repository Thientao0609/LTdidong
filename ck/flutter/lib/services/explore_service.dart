import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ExploreService {
  static Future<Map<String, dynamic>> getExploreData() async {
    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}/explore'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load explore data: ${response.statusCode}');
    }
  }

  static Future<void> toggleLikeTour(dynamic id) async {
    final response = await http.patch(
      Uri.parse('${ApiService.baseUrl}/tours/$id/like'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle like');
    }
  }

  static Future<void> toggleSaveTour(dynamic id) async {
    final response = await http.patch(
      Uri.parse('${ApiService.baseUrl}/tours/$id/save'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle save');
    }
  }
}