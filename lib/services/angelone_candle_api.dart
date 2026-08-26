import 'dart:convert';
import 'package:http/http.dart' as http;

class AngelOneCandleApi {
  static const baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8000/api');

  static Future<List<List<dynamic>>> candles(String exchange, String token, String interval, DateTime from, DateTime to, {String? authToken}) async {
    final uri = Uri.parse('$baseUrl/broker/angelone/candles').replace(queryParameters: {
      'exchange': exchange,
      'symboltoken': token,
      'interval': interval,
      'fromdate': _format(from),
      'todate': _format(to),
    });
    final response = await http.get(uri, headers: {'Accept': 'application/json', if (authToken != null) 'Authorization': 'Bearer $authToken'});
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) throw Exception(body['message'] ?? 'Candle request failed');
    final data = body['data'];
    if (data is! List) return [];
    return data.map<List<dynamic>>((e) => List<dynamic>.from(e as List)).toList();
  }

  static String _format(DateTime d) => '${d.year.toString().padLeft(4,'0')}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')} ${d.hour.toString().padLeft(2,'0')}:${d.minute.toString().padLeft(2,'0')}';
}
