import 'dart:convert';
import 'package:http/http.dart' as http;

class AngelOneInstrumentApi {
  static const baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8000/api');

  static Future<List<dynamic>> search(String query, {String? token}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/broker/angelone/instruments/search?q=${Uri.encodeQueryComponent(query)}'),
      headers: {'Accept': 'application/json', if (token != null) 'Authorization': 'Bearer $token'},
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) throw Exception(data['message'] ?? 'Search failed');
    return (data['data'] ?? []) as List<dynamic>;
  }
}
