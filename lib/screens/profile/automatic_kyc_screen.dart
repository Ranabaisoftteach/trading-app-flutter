import 'package:flutter/material.dart';
import '../../services/automatic_kyc_api.dart';

class AutomaticKycScreen extends StatefulWidget {
  const AutomaticKycScreen({super.key});
  @override State<AutomaticKycScreen> createState() => _AutomaticKycScreenState();
}

class _AutomaticKycScreenState extends State<AutomaticKycScreen> {
  final pan = TextEditingController();
  final name = TextEditingController();
  final dob = TextEditingController();
  bool loading = false;
  String panStatus = 'Not verified';
  String aadhaarStatus = 'Not started';

  @override
  void dispose() { pan.dispose(); name.dispose(); dob.dispose(); super.dispose(); }

  Future<void> verifyPan() async {
    final value = pan.text.trim().toUpperCase();
    if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(value)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid PAN number'))); return;
    }
    setState(() => loading = true);
    try {
      final result = await AutomaticKycApi.verifyPan(value);
      final data = result['data'] is Map ? Map<String, dynamic>.from(result['data']) : result;
      setState(() {
        panStatus = result['status']?.toString() ?? 'verified';
        name.text = (data['name'] ?? data['full_name'] ?? data['pan_name'] ?? '').toString();
        dob.text = (data['dob'] ?? data['date_of_birth'] ?? '').toString();
      });
    } catch (e) {
      setState(() => panStatus = 'Failed');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    } finally { if (mounted) setState(() => loading = false); }
  }

  Future<void> startAadhaar() async {
    try {
      final result = await AutomaticKycApi.startAadhaarVerification();
      setState(() => aadhaarStatus = result['status']?.toString() ?? 'pending');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Automatic KYC')),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      const Text('Verify your identity', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      const Text('Verify PAN automatically. Aadhaar uses an authorized consent-based flow.'),
      const SizedBox(height: 24),
      TextField(controller: pan, textCapitalization: TextCapitalization.characters, maxLength: 10, decoration: const InputDecoration(labelText: 'PAN number', hintText: 'ABCDE1234F', border: OutlineInputBorder())),
      const SizedBox(height: 8),
      SizedBox(height: 50, child: FilledButton(onPressed: loading ? null : verifyPan, child: loading ? const CircularProgressIndicator() : const Text('Verify PAN'))),
      ListTile(leading: const Icon(Icons.verified), title: const Text('PAN status'), trailing: Text(panStatus)),
      const SizedBox(height: 12),
      TextField(controller: name, readOnly: true, decoration: const InputDecoration(labelText: 'Verified name', border: OutlineInputBorder())),
      const SizedBox(height: 12),
      TextField(controller: dob, readOnly: true, decoration: const InputDecoration(labelText: 'Verified date of birth', border: OutlineInputBorder())),
      const SizedBox(height: 24),
      Card(child: ListTile(leading: const Icon(Icons.account_balance_wallet_outlined), title: const Text('Aadhaar / DigiLocker'), subtitle: Text(aadhaarStatus), trailing: FilledButton(onPressed: startAadhaar, child: const Text('Start')))),
    ]),
  );
}
