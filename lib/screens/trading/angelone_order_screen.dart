import 'package:flutter/material.dart';
import '../../services/angelone_order_api.dart';

class AngelOneOrderScreen extends StatefulWidget {
  final String tradingsymbol;
  final String symboltoken;
  final String exchange;
  const AngelOneOrderScreen({super.key, required this.tradingsymbol, required this.symboltoken, this.exchange = 'NSE'});

  @override State<AngelOneOrderScreen> createState() => _AngelOneOrderScreenState();
}

class _AngelOneOrderScreenState extends State<AngelOneOrderScreen> {
  final qty = TextEditingController(text: '1');
  final price = TextEditingController();
  final trigger = TextEditingController();
  String side = 'BUY';
  String orderType = 'MARKET';
  String productType = 'DELIVERY';
  bool loading = false;

  @override
  void dispose() { qty.dispose(); price.dispose(); trigger.dispose(); super.dispose(); }

  Future<void> submit() async {
    final quantity = int.tryParse(qty.text.trim());
    final limitPrice = double.tryParse(price.text.trim());
    final triggerPrice = double.tryParse(trigger.text.trim());
    if (quantity == null || quantity < 1) { _error('Enter a valid quantity'); return; }
    if ((orderType == 'LIMIT' || orderType == 'STOPLOSS_LIMIT') && (limitPrice == null || limitPrice <= 0)) { _error('Enter a valid limit price'); return; }
    if ((orderType == 'STOPLOSS_LIMIT' || orderType == 'STOPLOSS_MARKET') && (triggerPrice == null || triggerPrice <= 0)) { _error('Enter a valid trigger price'); return; }

    setState(() => loading = true);
    try {
      final result = await AngelOneOrderApi.placeOrder({
        'variety': 'NORMAL',
        'tradingsymbol': widget.tradingsymbol,
        'symboltoken': widget.symboltoken,
        'transactiontype': side,
        'exchange': widget.exchange,
        'ordertype': orderType,
        'producttype': productType,
        'duration': 'DAY',
        'price': limitPrice ?? 0,
        'triggerprice': triggerPrice ?? 0,
        'quantity': quantity,
      });
      if (!mounted) return;
      showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Order submitted'), content: Text(result['message']?.toString() ?? 'Order submitted to Angel One.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Done'))]));
    } catch (e) {
      _error(e.toString().replaceFirst('Exception: ', ''));
    } finally { if (mounted) setState(() => loading = false); }
  }

  void _error(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('${side == 'BUY' ? 'Buy' : 'Sell'} ${widget.tradingsymbol}')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      SegmentedButton<String>(segments: const [ButtonSegment(value: 'BUY', label: Text('BUY')), ButtonSegment(value: 'SELL', label: Text('SELL'))], selected: {side}, onSelectionChanged: (v) => setState(() => side = v.first)),
      const SizedBox(height: 20),
      DropdownButtonFormField<String>(value: orderType, decoration: const InputDecoration(labelText: 'Order type', border: OutlineInputBorder()), items: const [DropdownMenuItem(value: 'MARKET', child: Text('Market')), DropdownMenuItem(value: 'LIMIT', child: Text('Limit')), DropdownMenuItem(value: 'STOPLOSS_LIMIT', child: Text('Stop-Loss Limit')), DropdownMenuItem(value: 'STOPLOSS_MARKET', child: Text('Stop-Loss Market'))], onChanged: (v) => setState(() => orderType = v ?? 'MARKET')),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(value: productType, decoration: const InputDecoration(labelText: 'Product', border: OutlineInputBorder()), items: const [DropdownMenuItem(value: 'DELIVERY', child: Text('Delivery')), DropdownMenuItem(value: 'INTRADAY', child: Text('Intraday')), DropdownMenuItem(value: 'MARGIN', child: Text('Margin'))], onChanged: (v) => setState(() => productType = v ?? 'DELIVERY')),
      const SizedBox(height: 12),
      TextField(controller: qty, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder())),
      if (orderType != 'MARKET') ...[
        const SizedBox(height: 12), TextField(controller: price, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Price', prefixText: '₹ ', border: OutlineInputBorder())),
      ],
      if (orderType == 'STOPLOSS_LIMIT' || orderType == 'STOPLOSS_MARKET') ...[
        const SizedBox(height: 12), TextField(controller: trigger, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Trigger price', prefixText: '₹ ', border: OutlineInputBorder())),
      ],
      const SizedBox(height: 24),
      SizedBox(height: 52, child: FilledButton(onPressed: loading ? null : submit, child: loading ? const CircularProgressIndicator() : Text(side == 'BUY' ? 'Place Buy Order' : 'Place Sell Order'))),
    ]),
  );
}
