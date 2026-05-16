import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class TourMoreService {
  static Future<Map<String, dynamic>> getTourMoreData({String query = ''}) async {
    final uri = Uri.parse('${ApiService.baseUrl}/tourMore')
        .replace(queryParameters: query.isNotEmpty ? {'q': query} : null);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load tour more data');
    }
  }

  static Future<void> toggleFavorite(dynamic id) async {
    final response = await http.patch(
      Uri.parse('${ApiService.baseUrl}/tourMore/tours/$id/favorite'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle favorite');
    }
  }
}