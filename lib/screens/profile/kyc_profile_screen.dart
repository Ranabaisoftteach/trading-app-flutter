import 'package:flutter/material.dart';

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
  String status = 'Not verified';

  @override
  void dispose() { name.dispose(); dob.dispose(); pan.dispose(); account.dispose(); ifsc.dispose(); super.dispose(); }

  void submit() {
    if (name.text.trim().isEmpty || dob.text.trim().isEmpty || pan.text.trim().isEmpty || account.text.trim().isEmpty || ifsc.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please complete all KYC details'))); return;
    }
    setState(() => status = 'Verification pending');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('KYC submitted for verification')));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Profile & KYC', style: TextStyle(fontWeight: FontWeight.w800))),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(elevation: 0, child: ListTile(leading: const CircleAvatar(radius: 26, child: Icon(Icons.person)), title: Text(name.text.isEmpty ? 'Your profile' : name.text, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text(status))),
      const SizedBox(height: 20),
      _section('Personal details', [
        TextField(controller: name, onChanged: (_) => setState(() {}), decoration: const InputDecoration(labelText: 'Full name', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: dob, decoration: const InputDecoration(labelText: 'Date of birth (DD/MM/YYYY)', border: OutlineInputBorder())),
      ]),
      const SizedBox(height: 20),
      _section('PAN verification', [
        TextField(controller: pan, textCapitalization: TextCapitalization.characters, maxLength: 10, decoration: const InputDecoration(labelText: 'PAN number', hintText: 'ABCDE1234F', border: OutlineInputBorder())),
        const Text('PAN is required for securities account verification.', style: TextStyle(fontSize: 12)),
      ]),
      const SizedBox(height: 20),
      _section('Bank account', [
        TextField(controller: account, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Account number', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: ifsc, textCapitalization: TextCapitalization.characters, decoration: const InputDecoration(labelText: 'IFSC code', hintText: 'ABCD0123456', border: OutlineInputBorder())),
      ]),
      const SizedBox(height: 20),
      Card(elevation: 0, child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [const Icon(Icons.verified_outlined), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('KYC status', style: TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text(status)]))]))),
      const SizedBox(height: 20),
      SizedBox(height: 52, child: FilledButton(onPressed: status == 'Verification pending' ? null : submit, child: Text(status == 'Verification pending' ? 'Verification pending' : 'Submit for verification'))),
      const SizedBox(height: 16),
      const Text('Production: transmit sensitive KYC data only over authenticated HTTPS APIs and protect it on the backend.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
    ]),
  );

  Widget _section(String title, List<Widget> children) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), const SizedBox(height: 12), ...children]);
}
