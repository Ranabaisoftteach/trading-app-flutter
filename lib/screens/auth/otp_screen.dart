import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;
  const OtpScreen({super.key, required this.mobile});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpController = TextEditingController();
  bool loading = false;

  Future<void> verify() async {
    if (otpController.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter the 6-digit OTP')));
      return;
    }
    setState(() => loading = true);
    try {
      final result = await AuthService().verifyOtp(widget.mobile, otpController.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message']?.toString() ?? 'OTP verified')));
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Verify mobile')),
    body: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 24),
      const Text('Enter OTP', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      Text('We sent a 6-digit code to +91 ${widget.mobile}.'),
      const SizedBox(height: 28),
      TextField(controller: otpController, keyboardType: TextInputType.number, maxLength: 6, autofocus: true,
        decoration: const InputDecoration(labelText: 'OTP', border: OutlineInputBorder())),
      const SizedBox(height: 16),
      SizedBox(width: double.infinity, height: 52, child: FilledButton(onPressed: loading ? null : verify,
        child: loading ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator()) : const Text('Verify'))),
    ])),
  );
}
