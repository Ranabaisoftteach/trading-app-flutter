import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_storage.dart';

class AngelOneOrderApi {
  static const baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8000/api');

  static Future<Map<String, dynamic>> placeOrder(Map<String, dynamic> order) async {
    final token = await AuthStorage.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/broker/angelone/orders'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Idempotency-Key': DateTime.now().microsecondsSinceEpoch.toString(),
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(order),
    );
    final data = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) throw Exception(data['message'] ?? 'Order submission failed');
    return data;
  }

  static Future<Map<String, dynamic>> cancelOrder(String orderId) async {
    final token = await AuthStorage.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/broker/angelone/orders/$orderId/cancel'),
      headers: {'Accept': 'application/json', if (token != null) 'Authorization': 'Bearer $token'},
    );
    final data = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) throw Exception(data['message'] ?? 'Cancel failed');
    return data;
  }
}
