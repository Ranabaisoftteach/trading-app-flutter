import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/stock.dart';
import '../../services/market_service.dart';

class StockSearchScreen extends StatefulWidget {
  const StockSearchScreen({super.key});
  @override State<StockSearchScreen> createState() => _StockSearchScreenState();
}

class _StockSearchScreenState extends State<StockSearchScreen> {
  final controller = TextEditingController();
  final service = MarketService();
  Timer? timer;
  List<Stock> stocks = [];
  bool loading = false;

  void search(String value) {
    timer?.cancel();
    if (value.trim().length < 2) { setState(() => stocks = []); return; }
    timer = Timer(const Duration(milliseconds: 350), () async {
      setState(() => loading = true);
      try { stocks = await service.search(value.trim()); } catch (_) {}
      if (mounted) setState(() => loading = false);
    });
  }

  @override
  void dispose() { timer?.cancel(); controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Search stocks', style: TextStyle(fontWeight: FontWeight.w800))),
    body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
      TextField(controller: controller, autofocus: true, onChanged: search,
        decoration: InputDecoration(hintText: 'Search company or symbol', prefixIcon: const Icon(Icons.search), suffixIcon: loading ? const Padding(padding: EdgeInsets.all(14), child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))) : null, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)))),
      const SizedBox(height: 16),
      Expanded(child: stocks.isEmpty ? const Center(child: Text('Search for a stock to get started')) : ListView.builder(itemCount: stocks.length, itemBuilder: (_, i) {
        final s = stocks[i];
        return ListTile(leading: CircleAvatar(child: Text(s.symbol.isEmpty ? '?' : s.symbol[0])), title: Text(s.symbol, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text(s.name), trailing: Text('₹${s.price.toStringAsFixed(2)}'));
      }))
    ])),
  );
}
