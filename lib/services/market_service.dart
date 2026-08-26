import '../models/stock.dart';
import 'api_service.dart';

class MarketService {
  final ApiService api;
  MarketService({ApiService? api}) : api = api ?? ApiService();

  Future<List<Stock>> search(String query) async {
    final data = await api.get('/market/search?q=${Uri.encodeQueryComponent(query)}');
    final items = (data['data'] ?? data['stocks'] ?? []) as List;
    return items.map((e) => Stock.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }
}
