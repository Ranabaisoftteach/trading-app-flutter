class Stock {
  final String symbol;
  final String name;
  final double price;
  final double changePercent;

  const Stock({required this.symbol, required this.name, required this.price, required this.changePercent});

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
    symbol: json['symbol']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    price: (json['price'] as num?)?.toDouble() ?? 0,
    changePercent: (json['change_percent'] as num?)?.toDouble() ?? 0,
  );
}
