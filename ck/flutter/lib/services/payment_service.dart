import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class PaymentService {
  static Future<Map<String, dynamic>> getCheckoutPreview() async {
    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}/payment/preview'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load checkout preview: ${response.statusCode}');
    }
  }

  static Future<bool> processPayment(Map<String, dynamic> paymentDetails) async {
    final response = await http.post(
      Uri.parse('${ApiService.baseUrl}/payment/process'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(paymentDetails),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Payment failed: ${response.statusCode}');
    }
  }
}
