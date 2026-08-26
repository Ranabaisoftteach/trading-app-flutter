import '../models/kyc_status.dart';
import 'api_service.dart';

class KycService {
  final ApiService api;
  KycService({ApiService? api}) : api = api ?? ApiService();

  Future<KycStatus> status() async => KycStatus.fromJson(await api.get('/kyc/status'));

  Future<Map<String, dynamic>> submit({required String name, required String dob, required String pan, required String accountNumber, required String ifsc}) {
    return api.post('/kyc/submit', {
      'name': name,
      'dob': dob,
      'pan': pan,
      'account_number': accountNumber,
      'ifsc': ifsc,
    });
  }
}
