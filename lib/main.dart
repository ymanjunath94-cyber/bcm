import 'package:flutter/material.dart';

void main() => runApp(const BCMApp());

class BCMApp extends StatelessWidget {
  const BCMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BCM Services',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      home: const Scaffold(
        appBar: AppBar(title: Text('BCM Services')),
        body: Center(child: Text('Hello, BCM!', style: TextStyle(fontSize: 24))),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
