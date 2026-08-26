import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ApiService {
  final http.Client _client;
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final response = await _client.post(
      Uri.parse('${AppConfig.apiBaseUrl}$path'),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> get(String path) async {
    final response = await _client.get(
      Uri.parse('${AppConfig.apiBaseUrl}$path'),
      headers: {'Accept': 'application/json'},
    );
    return _decode(response);
  }

  Map<String, dynamic> _decode(http.Response response) {
    final dynamic data = jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(data is Map && data['message'] != null ? data['message'] : 'API request failed');
    }
    return Map<String, dynamic>.from(data as Map);
  }
}
