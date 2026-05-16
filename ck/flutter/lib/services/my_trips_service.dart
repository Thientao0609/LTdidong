import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class MyTripsService {
  static Future<List<dynamic>> getCurrentTrips() async {
    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}/my-trips/current'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load current trips');
  }

  static Future<Map<String, dynamic>> getTripDetail(dynamic id) async {
    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}/my-trips/detail/$id'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load trip detail');
  }
}