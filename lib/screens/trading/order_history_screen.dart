import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/angelone_order_api.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});
  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<dynamic> orders = [];
  bool loading = true;
  String? error;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadOrders();
    timer = Timer.periodic(const Duration(seconds: 10), (_) => loadOrders());
  }

  Future<void> loadOrders() async {
    try {
      final data = await AngelOneOrderApi.orders();
      if (mounted) setState(() { orders = data; loading = false; error = null; });
    } catch (e) {
      if (mounted) setState(() { loading = false; error = e.toString(); });
    }
  }

  String status(dynamic order) => (order is Map ? (order['status'] ?? order['orderstatus'] ?? 'UNKNOWN') : 'UNKNOWN').toString().toUpperCase();
  String value(dynamic order, String key, [String fallback = '-']) => order is Map && order[key] != null ? order[key].toString() : fallback;

  @override
  void dispose() { timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders'), actions: [IconButton(onPressed: loadOrders, icon: const Icon(Icons.refresh))]),
      body: RefreshIndicator(
        onRefresh: loadOrders,
        child: loading && orders.isEmpty
            ? const ListView(children: [SizedBox(height: 300), Center(child: CircularProgressIndicator())])
            : error != null && orders.isEmpty
                ? ListView(children: [const SizedBox(height: 220), Center(child: Text('Unable to load orders')), Center(child: Text('')), Center(child: Text('Pull to retry'))])
                : orders.isEmpty
                    ? ListView(children: const [SizedBox(height: 220), Center(child: Text('No orders yet'))])
                    : ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: orders.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) {
                          final o = orders[i];
                          final s = status(o);
                          final side = value(o, 'transactiontype', value(o, 'side', ''));
                          return Card(child: ListTile(
                            title: Text('${value(o, 'tradingsymbol', value(o, 'symbol'))}  •  $side'),
                            subtitle: Text('Qty ${value(o, 'quantity')}   Price ${value(o, 'price', value(o, 'averageprice'))}'),
                            trailing: Text(s, style: const TextStyle(fontWeight: FontWeight.w700)),
                          ));
                        },
                      ),
      ),
    );
  }
}
