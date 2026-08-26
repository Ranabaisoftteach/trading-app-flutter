import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_storage.dart';

class AngelOneDataApi {
  static const baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8000/api');

  static Future<Map<String, dynamic>> _get(String path) async {
    final token = await AuthStorage.getToken();
    final response = await http.get(Uri.parse('$baseUrl$path'), headers: {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });
    final data = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) throw Exception(data['message'] ?? 'Angel One request failed');
    return data;
  }

  static Future<Map<String, dynamic>> profile() => _get('/broker/angelone/profile');
  static Future<Map<String, dynamic>> funds() => _get('/broker/angelone/funds');
  static Future<Map<String, dynamic>> holdings() => _get('/broker/angelone/holdings');
  static Future<Map<String, dynamic>> positions() => _get('/broker/angelone/positions');
  static Future<Map<String, dynamic>> orders() => _get('/broker/angelone/orders');
  static Future<Map<String, dynamic>> trades() => _get('/broker/angelone/trades');
}
