import 'package:flutter/material.dart';

class FundsScreen extends StatelessWidget {
  const FundsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Funds', style: TextStyle(fontWeight: FontWeight.w800))),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
        Text('Available balance'), SizedBox(height: 6), Text('Rs 25,430.50', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)), SizedBox(height: 6), Text('Used margin  Rs 4,250.00'),
      ]))),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(child: FilledButton.icon(onPressed: () => _showMoney(context, 'Add money', 'Continue'), icon: const Icon(Icons.add), label: const Text('Add money'))),
        const SizedBox(width: 12),
        Expanded(child: OutlinedButton.icon(onPressed: () => _showMoney(context, 'Withdraw money', 'Withdraw'), icon: const Icon(Icons.arrow_upward), label: const Text('Withdraw'))),
      ]),
      const SizedBox(height: 28),
      const Text('Transactions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      const _Transaction(title: 'Funds added', subtitle: 'UPI - Today, 10:42 AM', amount: '+Rs 10,000'),
      const _Transaction(title: 'Order margin', subtitle: 'RELIANCE - Today, 10:30 AM', amount: '-Rs 4,250'),
      const _Transaction(title: 'Funds added', subtitle: 'Bank transfer - Yesterday', amount: '+Rs 20,000'),
    ]),
  );

  static void _showMoney(BuildContext context, String title, String action) => showModalBottomSheet(context: context, showDragHandle: true, builder: (_) => _MoneySheet(title: title, action: action));
}

class _MoneySheet extends StatelessWidget {
  final String title, action;
  const _MoneySheet({required this.title, required this.action});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 30), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)), const SizedBox(height: 16),
    const TextField(keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Amount', prefixText: 'Rs ', border: OutlineInputBorder())), const SizedBox(height: 16),
    SizedBox(width: double.infinity, height: 50, child: FilledButton(onPressed: () => Navigator.pop(context), child: Text(action))),
  ]));
}

class _Transaction extends StatelessWidget {
  final String title, subtitle, amount;
  const _Transaction({required this.title, required this.subtitle, required this.amount});
  @override
  Widget build(BuildContext context) => Card(elevation: 0, child: ListTile(leading: const CircleAvatar(child: Icon(Icons.account_balance_wallet_outlined)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text(subtitle), trailing: Text(amount, style: const TextStyle(fontWeight: FontWeight.w800))));
}
