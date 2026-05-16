import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class PastTripsService {
  static Future<List<dynamic>> getPastTrips() async {
    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}/past-trips'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load past trips');
  }
}