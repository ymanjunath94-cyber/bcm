import 'package:flutter/material.dart';

void main() {
  runApp(const BCMApp());
}

class BCMApp extends StatelessWidget {
  const BCMApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BCM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FilledButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          ),
          child: const Text("Login (Demo)"),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BCM")),
      body: const Center(child: Text("Welcome to BCM App")),
    );
  }
}
