import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class WishListService {
  static Future<List<dynamic>> getWishListTrips() async {
    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}/wish-list'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load wish list');
  }

  static Future<void> toggleWishListLike(dynamic id) async {
    final response = await http.patch(
      Uri.parse('${ApiService.baseUrl}/wish-list/$id/like'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle wish list like');
    }
  }
}