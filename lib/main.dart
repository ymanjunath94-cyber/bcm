import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BCMApp());
}

class BCMApp extends StatelessWidget {
  const BCMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BCM',
      debugShowCheckedModeBanner: false, // hides the DEBUG ribbon
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
      appBar: AppBar(title: const Text('BCM • Public Service Assistant')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Welcome to BCM!\nYour public-service assistant app.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
