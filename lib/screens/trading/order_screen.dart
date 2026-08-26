import 'package:flutter/material.dart';
import '../../models/stock.dart';

class OrderScreen extends StatefulWidget {
  final Stock stock;
  final bool isBuy;
  const OrderScreen({super.key, required this.stock, required this.isBuy});
  @override State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final quantity = TextEditingController(text: '1');
  final price = TextEditingController();
  String orderType = 'Market';

  double get qty => double.tryParse(quantity.text) ?? 0;
  double get enteredPrice => double.tryParse(price.text) ?? widget.stock.price;
  double get estimate => qty * enteredPrice;

  @override
  void initState() { super.initState(); price.text = widget.stock.price.toStringAsFixed(2); }
  @override
  void dispose() { quantity.dispose(); price.dispose(); super.dispose(); }

  void confirm() {
    showModalBottomSheet(context: context, showDragHandle: true, builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(widget.isBuy ? 'Confirm Buy' : 'Confirm Sell', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        Text('${widget.stock.symbol} • ${qty.toStringAsFixed(0)} shares • $orderType'),
        const SizedBox(height: 8),
        Text('Estimated value: ₹${estimate.toStringAsFixed(2)}'),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, height: 50, child: FilledButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('Confirm order'))),
      ]),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.isBuy ? 'Buy ${widget.stock.symbol}' : 'Sell ${widget.stock.symbol}')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      Text(widget.stock.name, style: const TextStyle(fontSize: 16)),
      const SizedBox(height: 6),
      Text('₹${widget.stock.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
      const SizedBox(height: 24),
      const Text('Order type', style: TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      SegmentedButton<String>(segments: const [ButtonSegment(value: 'Market', label: Text('Market')), ButtonSegment(value: 'Limit', label: Text('Limit'))], selected: {orderType}, onSelectionChanged: (v) => setState(() => orderType = v.first)),
      const SizedBox(height: 20),
      TextField(controller: quantity, keyboardType: TextInputType.number, onChanged: (_) => setState(() {}), decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder())),
      if (orderType == 'Limit') ...[
        const SizedBox(height: 16),
        TextField(controller: price, keyboardType: const TextInputType.numberWithOptions(decimal: true), onChanged: (_) => setState(() {}), decoration: const InputDecoration(labelText: 'Limit price', prefixText: '₹ ', border: OutlineInputBorder())),
      ],
      const SizedBox(height: 24),
      Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        _row('Price', '₹${enteredPrice.toStringAsFixed(2)}'),
        _row('Quantity', qty.toStringAsFixed(0)),
        const Divider(),
        _row('Estimated amount', '₹${estimate.toStringAsFixed(2)}', bold: true),
      ]))),
      const SizedBox(height: 24),
      SizedBox(height: 54, child: FilledButton(onPressed: qty > 0 ? confirm : null, child: Text(widget.isBuy ? 'Place Buy Order' : 'Place Sell Order'))),
    ]),
  );

  Widget _row(String a, String b, {bool bold = false}) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(a), Text(b, style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w600))]));
}
