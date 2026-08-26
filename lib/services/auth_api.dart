import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_storage.dart';

class AuthApi {
  static const String baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8000/api');

  static Future<Map<String, dynamic>> register({required String name, required String email, required String password, required String passwordConfirmation}) async {
    final response = await http.post(Uri.parse('$baseUrl/auth/register'), headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}, body: jsonEncode({'name': name, 'email': email, 'password': password, 'password_confirmation': passwordConfirmation}));
    return _handle(response);
  }

  static Future<Map<String, dynamic>> login({required String email, required String password}) async {
    final response = await http.post(Uri.parse('$baseUrl/auth/login'), headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}, body: jsonEncode({'email': email, 'password': password}));
    final data = _handle(response);
    final token = data['token']?.toString();
    if (token != null && token.isNotEmpty) await AuthStorage.saveToken(token);
    return data;
  }

  static Future<void> logout() async {
    final token = await AuthStorage.getToken();
    if (token != null) {
      await http.post(Uri.parse('$baseUrl/auth/logout'), headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'});
    }
    await AuthStorage.clear();
  }

  static Map<String, dynamic> _handle(http.Response response) {
    final data = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(data['message']?.toString() ?? 'Authentication request failed');
    }
    return data;
  }
}
