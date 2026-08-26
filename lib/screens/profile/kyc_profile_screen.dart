import 'package:flutter/material.dart';
import '../../services/kyc_service.dart';

class KycProfileScreen extends StatefulWidget {
  const KycProfileScreen({super.key});
  @override State<KycProfileScreen> createState() => _KycProfileScreenState();
}

class _KycProfileScreenState extends State<KycProfileScreen> {
  final name = TextEditingController();
  final dob = TextEditingController();
  final pan = TextEditingController();
  final account = TextEditingController();
  final ifsc = TextEditingController();
  final kyc = KycService();
  String status = 'Not verified';
  bool loading = false;

  @override
  void initState() { super.initState(); _loadStatus(); }
  @override
  void dispose() { name.dispose(); dob.dispose(); pan.dispose(); account.dispose(); ifsc.dispose(); super.dispose(); }

  Future<void> _loadStatus() async {
    try { final result = await kyc.status(); if (!mounted) return; setState(() => status = result.state.name); }
    catch (_) {}
  }

  Future<void> submit() async {
    if ([name, dob, pan, account, ifsc].any((c) => c.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all KYC details'))); return;
    }
    setState(() => loading = true);
    try {
      final result = await kyc.submit(name: name.text.trim(), dob: dob.text.trim(), pan: pan.text.trim().toUpperCase(), accountNumber: account.text.trim(), ifsc: ifsc.text.trim().toUpperCase());
      if (!mounted) return;
      setState(() => status = result['status']?.toString() ?? 'under_review');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('KYC submitted for verification')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    } finally { if (mounted) setState(() => loading = false); }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Profile & KYC', style: TextStyle(fontWeight: FontWeight.w800))),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(elevation: 0, child: ListTile(leading: const CircleAvatar(radius: 26, child: Icon(Icons.person)), title: Text(name.text.isEmpty ? 'Your profile' : name.text, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text(status))),
      const SizedBox(height: 20),
      _section('Personal details', [TextField(controller: name, onChanged: (_) => setState(() {}), decoration: const InputDecoration(labelText: 'Full name', border: OutlineInputBorder())), const SizedBox(height: 12), TextField(controller: dob, decoration: const InputDecoration(labelText: 'Date of birth (YYYY-MM-DD)', border: OutlineInputBorder()))]),
      const SizedBox(height: 20),
      _section('PAN verification', [TextField(controller: pan, textCapitalization: TextCapitalization.characters, maxLength: 10, decoration: const InputDecoration(labelText: 'PAN number', hintText: 'ABCDE1234F', border: OutlineInputBorder()))]),
      const SizedBox(height: 20),
      _section('Bank account', [TextField(controller: account, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Account number', border: OutlineInputBorder())), const SizedBox(height: 12), TextField(controller: ifsc, textCapitalization: TextCapitalization.characters, decoration: const InputDecoration(labelText: 'IFSC code', hintText: 'ABCD0123456', border: OutlineInputBorder()))]),
      const SizedBox(height: 20),
      Card(elevation: 0, child: ListTile(leading: const Icon(Icons.verified_outlined), title: const Text('KYC status', style: TextStyle(fontWeight: FontWeight.w800)), subtitle: Text(status))),
      const SizedBox(height: 20),
      SizedBox(height: 52, child: FilledButton(onPressed: loading ? null : submit, child: loading ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator()) : const Text('Submit for verification'))),
    ]),
  );

  Widget _section(String title, List<Widget> children) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), const SizedBox(height: 12), ...children]);
}
