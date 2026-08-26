import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_storage.dart';

class BrokerConnectApi {
  static const baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8000/api');

  static Future<Map<String, dynamic>> connectAngelOne({required String clientCode, required String pin, required String totp}) async {
    final token = await AuthStorage.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/broker/angelone/connect'),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json', if (token != null) 'Authorization': 'Bearer $token'},
      body: jsonEncode({'client_code': clientCode, 'pin': pin, 'totp': totp}),
    );
    final data = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) throw Exception(data['message'] ?? 'Broker connection failed');
    return data;
  }

  static Future<void> disconnectAngelOne() async {
    final token = await AuthStorage.getToken();
    await http.post(Uri.parse('$baseUrl/broker/angelone/disconnect'), headers: {'Accept': 'application/json', if (token != null) 'Authorization': 'Bearer $token'});
  }
}
