import 'package:flutter/material.dart';
import '../../services/angelone_data_api.dart';

class AngelOneDashboardScreen extends StatefulWidget {
  const AngelOneDashboardScreen({super.key});
  @override State<AngelOneDashboardScreen> createState() => _AngelOneDashboardScreenState();
}

class _AngelOneDashboardScreenState extends State<AngelOneDashboardScreen> {
  bool loading = true;
  String error = '';
  Map<String, dynamic> funds = {};
  Map<String, dynamic> holdings = {};
  Map<String, dynamic> positions = {};
  Map<String, dynamic> orders = {};
  Map<String, dynamic> trades = {};

  @override
  void initState() { super.initState(); load(); }

  Future<void> load() async {
    setState(() { loading = true; error = ''; });
    try {
      final results = await Future.wait([
        AngelOneDataApi.funds(),
        AngelOneDataApi.holdings(),
        AngelOneDataApi.positions(),
        AngelOneDataApi.orders(),
        AngelOneDataApi.trades(),
      ]);
      if (!mounted) return;
      setState(() {
        funds = results[0]; holdings = results[1]; positions = results[2]; orders = results[3]; trades = results[4]; loading = false;
      });
    } catch (e) {
      if (mounted) setState(() { loading = false; error = e.toString().replaceFirst('Exception: ', ''); });
    }
  }

  dynamic dataValue(Map<String, dynamic> response, String key) => response['data'] is Map ? response['data'][key] : response[key];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Angel One Dashboard', style: TextStyle(fontWeight: FontWeight.w800)), actions: [IconButton(onPressed: load, icon: const Icon(Icons.refresh))]),
    body: loading ? const Center(child: CircularProgressIndicator()) : error.isNotEmpty ? Center(child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [Text(error, textAlign: TextAlign.center), const SizedBox(height: 12), FilledButton(onPressed: load, child: const Text('Retry'))])) : RefreshIndicator(onRefresh: load, child: ListView(padding: const EdgeInsets.all(16), children: [
      _summary('Available funds', dataValue(funds, 'availablecash') ?? dataValue(funds, 'net') ?? '-'),
      const SizedBox(height: 12),
      Row(children: [Expanded(child: _countCard('Holdings', _count(holdings))), const SizedBox(width: 10), Expanded(child: _countCard('Positions', _count(positions)))]),
      const SizedBox(height: 10),
      Row(children: [Expanded(child: _countCard('Orders', _count(orders))), const SizedBox(width: 10), Expanded(child: _countCard('Trades', _count(trades)))]),
      const SizedBox(height: 24),
      const Text('Broker account data', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
      const SizedBox(height: 10),
      _dataCard('Funds', funds),
      _dataCard('Holdings', holdings),
      _dataCard('Positions', positions),
      _dataCard('Orders', orders),
      _dataCard('Trades', trades),
    ])),
  );

  int _count(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is List) return data.length;
    if (data is Map) return (data['data'] is List) ? (data['data'] as List).length : data.length;
    return 0;
  }

  Widget _summary(String title, dynamic value) => Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title), const SizedBox(height: 6), Text('$value', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800))])));
  Widget _countCard(String title, int count) => Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [Text('$count', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text(title)])));
  Widget _dataCard(String title, Map<String, dynamic> data) => Card(elevation: 0, child: ExpansionTile(title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), children: [Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), child: SelectableText(data.toString()))]));
}
