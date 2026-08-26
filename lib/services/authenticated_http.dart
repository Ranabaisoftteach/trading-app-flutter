import 'package:http/http.dart' as http;
import 'auth_storage.dart';

class AuthenticatedHttp {
  static Future<Map<String, String>> headers() async {
    final token = await AuthStorage.getToken();
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> get(Uri uri) async => http.get(uri, headers: await headers());
  static Future<http.Response> post(Uri uri, {Object? body}) async => http.post(uri, headers: await headers(), body: body);
}
