import 'package:flutter/material.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Portfolio', style: TextStyle(fontWeight: FontWeight.w800))),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
        Text('Current value'), SizedBox(height: 6), Text('₹1,24,580.40', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)), SizedBox(height: 8), Text('Invested ₹1,20,330.00'), SizedBox(height: 4), Text('P&L +₹4,250.40 (+3.53%)', style: TextStyle(fontWeight: FontWeight.w800)),
      ]))),
      const SizedBox(height: 20),
      const Text('Holdings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      const _Holding(symbol: 'RELIANCE', qty: '12', value: '₹17,788.80', pnl: '+₹1,240.20'),
      const _Holding(symbol: 'TCS', qty: '5', value: '₹15,624.00', pnl: '+₹624.00'),
      const _Holding(symbol: 'INFY', qty: '8', value: '₹13,129.60', pnl: '-₹184.40'),
      const _Holding(symbol: 'HDFCBANK', qty: '10', value: '₹19,821.00', pnl: '+₹810.00'),
      const SizedBox(height: 20),
      const Text('Open positions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      const _Holding(symbol: 'NIFTY FUT', qty: '1', value: '₹24,850.00', pnl: '+₹450.00'),
    ]),
  );
}

class _Holding extends StatelessWidget {
  final String symbol, qty, value, pnl;
  const _Holding({required this.symbol, required this.qty, required this.value, required this.pnl});
  @override
  Widget build(BuildContext context) => Card(elevation: 0, child: ListTile(
    leading: CircleAvatar(child: Text(symbol.substring(0, 1))),
    title: Text(symbol, style: const TextStyle(fontWeight: FontWeight.w800)),
    subtitle: Text('Qty $qty'),
    trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [Text(value, style: const TextStyle(fontWeight: FontWeight.w800)), Text(pnl)]),
  ));
}
