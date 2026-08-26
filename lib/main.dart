import 'package:flutter/material.dart';

void main() {
  runApp(const TradingApp());
}

class TradingApp extends StatelessWidget {
  const TradingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trading App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B2EFF)),
        scaffoldBackgroundColor: const Color(0xFFF7F7FA),
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Good morning 👋', style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(radius: 18, child: Icon(Icons.person_outline)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search stocks, ETFs, companies...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 20),
          _PortfolioCard(),
          const SizedBox(height: 24),
          const Text('Market today', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(child: _IndexCard(title: 'NIFTY 50', value: '25,078.30', change: '+0.62%')),
              SizedBox(width: 12),
              Expanded(child: _IndexCard(title: 'SENSEX', value: '81,857.12', change: '+0.48%')),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Watchlist', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              TextButton(onPressed: () {}, child: const Text('View all')),
            ],
          ),
          const _StockTile(symbol: 'RELIANCE', name: 'Reliance Industries', price: '₹1,482.40', change: '+1.24%'),
          const _StockTile(symbol: 'TCS', name: 'Tata Consultancy Services', price: '₹3,124.80', change: '+0.72%'),
          const _StockTile(symbol: 'INFY', name: 'Infosys', price: '₹1,641.20', change: '-0.31%'),
          const _StockTile(symbol: 'HDFCBANK', name: 'HDFC Bank', price: '₹1,982.10', change: '+0.55%'),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Explore'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Orders'),
          NavigationDestination(icon: Icon(Icons.pie_chart_outline), selectedIcon: Icon(Icons.pie_chart), label: 'Portfolio'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF5B2EFF), Color(0xFF7C4DFF)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Total portfolio', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        const Text('₹1,24,580.40', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        const Text('+₹4,250.40  (+3.53%)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        const SizedBox(height: 18),
        FilledButton.tonal(onPressed: () {}, child: const Text('Add money')),
      ]),
    );
  }
}

class _IndexCard extends StatelessWidget {
  final String title, value, change;
  const _IndexCard({required this.title, required this.value, required this.change});

  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(change, style: const TextStyle(fontWeight: FontWeight.w700)),
          ]),
        ),
      );
}

class _StockTile extends StatelessWidget {
  final String symbol, name, price, change;
  const _StockTile({required this.symbol, required this.name, required this.price, required this.change});

  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: CircleAvatar(child: Text(symbol.substring(0, 1))),
          title: Text(symbol, style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Text(name),
          trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(price, style: const TextStyle(fontWeight: FontWeight.w800)),
            Text(change),
          ]),
        ),
      );
}
