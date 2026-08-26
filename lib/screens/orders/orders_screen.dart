import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Orders', style: TextStyle(fontWeight: FontWeight.w800)),
        bottom: const TabBar(tabs: [Tab(text: 'All'), Tab(text: 'Open'), Tab(text: 'Completed')]),
      ),
      body: const TabBarView(children: [
        _OrderList(items: [
          _OrderData('RELIANCE', 'BUY', '12 qty - Market', 'Rs 17,788.80', 'Executed'),
          _OrderData('TCS', 'BUY', '5 qty - Limit Rs 3,100', 'Rs 15,500.00', 'Pending'),
          _OrderData('INFY', 'SELL', '2 qty - Market', 'Rs 3,282.40', 'Executed'),
          _OrderData('HDFCBANK', 'BUY', '10 qty - Limit Rs 1,950', 'Rs 19,500.00', 'Rejected'),
        ]),
        _OrderList(items: [
          _OrderData('TCS', 'BUY', '5 qty - Limit Rs 3,100', 'Rs 15,500.00', 'Pending'),
        ]),
        _OrderList(items: [
          _OrderData('RELIANCE', 'BUY', '12 qty - Market', 'Rs 17,788.80', 'Executed'),
          _OrderData('INFY', 'SELL', '2 qty - Market', 'Rs 3,282.40', 'Executed'),
        ]),
      ]),
    ),
  );
}

class _OrderData {
  final String symbol, side, detail, amount, status;
  const _OrderData(this.symbol, this.side, this.detail, this.amount, this.status);
}

class _OrderList extends StatelessWidget {
  final List<_OrderData> items;
  const _OrderList({required this.items});

  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: const EdgeInsets.all(16),
    itemCount: items.length,
    separatorBuilder: (_, __) => const SizedBox(height: 8),
    itemBuilder: (_, i) {
      final o = items[i];
      return Card(elevation: 0, child: ListTile(
        leading: CircleAvatar(child: Text(o.symbol.substring(0, 1))),
        title: Row(children: [Text(o.symbol, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(width: 8), Text(o.side, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))]),
        subtitle: Text(o.detail),
        trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [Text(o.amount, style: const TextStyle(fontWeight: FontWeight.w800)), Text(o.status)]),
      ));
    },
  );
}
