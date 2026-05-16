import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class NextTripsService {

  /// 🔥 LẤY LIST NEXT TRIPS
  static Future<List<dynamic>> getNextTrips() async {
    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}/next-trips'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to load next trips");
  }

  static Future<Map<String, dynamic>> getNextTripDetail(dynamic id) async {
    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}/next-trips/detail/$id'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to load next trip detail");
  }
}