import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final mobileController = TextEditingController();
  bool loading = false;

  Future<void> sendOtp() async {
    final mobile = mobileController.text.trim();
    if (mobile.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid 10-digit mobile number')));
      return;
    }
    setState(() => loading = true);
    try {
      await AuthService().sendOtp(mobile);
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (_) => OtpScreen(mobile: mobile)));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Spacer(),
        const Text('Welcome back', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        const Text('Login securely with your mobile number.'),
        const SizedBox(height: 32),
        TextField(controller: mobileController, keyboardType: TextInputType.phone, maxLength: 10,
          decoration: const InputDecoration(labelText: 'Mobile number', prefixText: '+91 ', border: OutlineInputBorder())),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, height: 52, child: FilledButton(
          onPressed: loading ? null : sendOtp,
          child: loading ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator()) : const Text('Continue'),
        )),
        const SizedBox(height: 16),
        const Text('By continuing, you agree to the app terms and privacy policy.', textAlign: TextAlign.center),
        const Spacer(),
      ]),
    )),
  );
}
