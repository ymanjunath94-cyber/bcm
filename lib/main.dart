import 'package:flutter/material.dart';

void main() {
  runApp(const BCMApp());
}

class BCMApp extends StatelessWidget {
  const BCMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BCM Services',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const BCMHomePage(),
    );
  }
}

class BCMHomePage extends StatelessWidget {
  const BCMHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BCM Services"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          children: [
            serviceButton("Land Records"),
            serviceButton("RTC"),
            serviceButton("News Feed"),
            serviceButton("Land Map"),
            serviceButton("Police Help"),
            serviceButton("Loan Help"),
          ],
        ),
      ),
    );
  }

  Widget serviceButton(String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
