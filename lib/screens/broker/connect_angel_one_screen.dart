import 'package:flutter/material.dart';
import '../../services/broker_connect_api.dart';

class ConnectAngelOneScreen extends StatefulWidget {
  const ConnectAngelOneScreen({super.key});
  @override State<ConnectAngelOneScreen> createState() => _ConnectAngelOneScreenState();
}

class _ConnectAngelOneScreenState extends State<ConnectAngelOneScreen> {
  final clientCode = TextEditingController();
  final pin = TextEditingController();
  final totp = TextEditingController();
  bool loading = false;
  bool connected = false;

  @override
  void dispose() { clientCode.dispose(); pin.dispose(); totp.dispose(); super.dispose(); }

  Future<void> connect() async {
    if (clientCode.text.trim().isEmpty || pin.text.trim().isEmpty || totp.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter client code, PIN and 6-digit TOTP')));
      return;
    }
    setState(() => loading = true);
    try {
      await BrokerConnectApi.connectAngelOne(clientCode: clientCode.text.trim(), pin: pin.text.trim(), totp: totp.text.trim());
      if (!mounted) return;
      setState(() => connected = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Angel One connected successfully')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    } finally { if (mounted) setState(() => loading = false); }
  }

  Future<void> disconnect() async {
    setState(() => loading = true);
    try { await BrokerConnectApi.disconnectAngelOne(); if (mounted) setState(() => connected = false); }
    catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); }
    finally { if (mounted) setState(() => loading = false); }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Connect Angel One')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Angel One SmartAPI', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      Text(connected ? 'Trading account connected' : 'Connect your Angel One trading account securely.'),
      const SizedBox(height: 24),
      TextField(controller: clientCode, decoration: const InputDecoration(labelText: 'Client code', border: OutlineInputBorder())),
      const SizedBox(height: 14),
      TextField(controller: pin, obscureText: true, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Trading PIN', border: OutlineInputBorder())),
      const SizedBox(height: 14),
      TextField(controller: totp, obscureText: true, keyboardType: TextInputType.number, maxLength: 6, decoration: const InputDecoration(labelText: 'TOTP', hintText: '6-digit code', border: OutlineInputBorder())),
      const SizedBox(height: 20),
      SizedBox(height: 54, child: FilledButton(onPressed: loading ? null : (connected ? disconnect : connect), child: loading ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator()) : Text(connected ? 'Disconnect Angel One' : 'Connect Angel One'))),
      const SizedBox(height: 16),
      const Text('Your Angel One PIN/TOTP is sent to your Laravel backend only for authentication. Do not store these credentials in Flutter storage or GitHub.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
    ]),
  );
}
