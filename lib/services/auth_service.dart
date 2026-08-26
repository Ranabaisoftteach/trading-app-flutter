import 'api_service.dart';

class AuthService {
  final ApiService api;
  AuthService({ApiService? api}) : api = api ?? ApiService();

  Future<Map<String, dynamic>> sendOtp(String mobile) {
    return api.post('/auth/send-otp', {'mobile': mobile});
  }

  Future<Map<String, dynamic>> verifyOtp(String mobile, String otp) {
    return api.post('/auth/verify-otp', {'mobile': mobile, 'otp': otp});
  }
}
