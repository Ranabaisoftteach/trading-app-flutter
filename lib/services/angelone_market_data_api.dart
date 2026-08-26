import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_storage.dart';

class AngelOneMarketDataApi {
  static const baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8000/api');

  static Future<Map<String, dynamic>> ltp(String exchange, String tradingsymbol, String symboltoken) async {
    final token = await AuthStorage.getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/broker/angelone/quote'),
      headers: {'Accept':'application/json','Content-Type':'application/json', if (token != null) 'Authorization':'Bearer $token'},
      body: jsonEncode({'exchange':exchange,'tradingsymbol':tradingsymbol,'symboltoken':symboltoken}),
    );
    final data = response.body.isEmpty ? <String,dynamic>{} : jsonDecode(response.body) as Map<String,dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) throw Exception(data['message'] ?? 'Market data request failed');
    return data;
  }
}
