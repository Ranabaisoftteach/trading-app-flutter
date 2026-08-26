import 'package:flutter/material.dart';
import '../../models/stock.dart';

class StockDetailScreen extends StatelessWidget {
  final Stock stock;
  const StockDetailScreen({super.key, required this.stock});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(stock.symbol), actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.star_border))]),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Text(stock.name, style: const TextStyle(fontSize: 16)),
      const SizedBox(height: 8),
      Text('₹${stock.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
      Text('${stock.changePercent >= 0 ? '+' : ''}${stock.changePercent.toStringAsFixed(2)}%', style: const TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: 24),
      Container(height: 280, decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(20)), child: CustomPaint(painter: _ChartPainter())),
      const SizedBox(height: 20),
      const Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Text('1D'), Text('1W'), Text('1M'), Text('1Y'), Text('5Y')]),
      const SizedBox(height: 28),
      Row(children: [
        Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Sell'))),
        const SizedBox(width: 12),
        Expanded(child: FilledButton(onPressed: () {}, child: const Text('Buy'))),
      ]),
    ]),
  );
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 3;
    final path = Path();
    final points = [0.62, 0.57, 0.64, 0.48, 0.52, 0.44, 0.55, 0.39, 0.46, 0.34, 0.41, 0.27, 0.32, 0.22];
    for (var i = 0; i < points.length; i++) {
      final x = i * size.width / (points.length - 1);
      final y = points[i] * size.height;
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
