import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/angelone_market_data_api.dart';

class AngelOneWatchlistScreen extends StatefulWidget {
  const AngelOneWatchlistScreen({super.key});
  @override
  State<AngelOneWatchlistScreen> createState() => _AngelOneWatchlistScreenState();
}

class _AngelOneWatchlistScreenState extends State<AngelOneWatchlistScreen> {
  final symbols = <Map<String, String>>[
    {'exchange':'NSE','tradingsymbol':'RELIANCE-EQ','symboltoken':'2885'},
    {'exchange':'NSE','tradingsymbol':'TCS-EQ','symboltoken':'11536'},
    {'exchange':'NSE','tradingsymbol':'INFY-EQ','symboltoken':'1594'},
  ];
  final prices = <String, Map<String, dynamic>>{};
  Timer? timer;
  bool loading = false;

  @override
  void initState() { super.initState(); refresh(); timer = Timer.periodic(const Duration(seconds: 5), (_) => refresh()); }

  Future<void> refresh() async {
    if (loading) return;
    loading = true;
    try {
      for (final s in symbols) {
        final data = await AngelOneMarketDataApi.ltp(s['exchange']!, s['tradingsymbol']!, s['symboltoken']!);
        if (mounted) prices[s['tradingsymbol']!] = data;
      }
      if (mounted) setState(() {});
    } finally { loading = false; }
  }

  @override
  void dispose() { timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Angel One Watchlist'), actions: [IconButton(onPressed: refresh, icon: const Icon(Icons.refresh))]),
    body: RefreshIndicator(
      onRefresh: refresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(12), itemCount: symbols.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final s = symbols[i]; final d = prices[s['tradingsymbol']!];
          final data = d?['data'] is Map ? d!['data'] as Map : d;
          final ltp = data?['ltp'] ?? '-';
          final close = double.tryParse('${data?['close'] ?? ''}');
          final current = double.tryParse('$ltp');
          final change = close != null && current != null && close != 0 ? ((current-close)/close)*100 : null;
          return Card(child: ListTile(
            title: Text(s['tradingsymbol']!.replaceAll('-EQ',''), style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(s['exchange']!),
            trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('$ltp', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              Text(change == null ? '-' : '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%'),
            ]),
          ));
        },
      ),
    ),
  );
}
