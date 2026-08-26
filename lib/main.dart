import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';

void main() => runApp(const TradingApp());

class TradingApp extends StatelessWidget {
  const TradingApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Trading App',
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B2EFF)),
      scaffoldBackgroundColor: const Color(0xFFF7F7FA),
    ),
    home: const LoginScreen(),
  );
}
