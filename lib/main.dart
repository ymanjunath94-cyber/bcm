import 'package:flutter/material.dart';

void main() => runApp(const BCMApp());

class BCMApp extends StatelessWidget {
  const BCMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BCM Services',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
    );
  }
}

// --- LOGIN SCREEN ---
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FilledButton(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            backgroundColor: Colors.green,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          },
          child: const Text(
            "Login (Demo) / ಲಾಗಿನ್",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

// --- HOME SCREEN WITH KN + EN TABS ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "BCM Services",
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: "Home"),
            Tab(text: "ಮುಖಪುಟ"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          EnglishHome(),
          KannadaHome(),
        ],
      ),
    );
  }
}

// English tab
class EnglishHome extends StatelessWidget {
  const EnglishHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Welcome to BCM Services",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Kannada tab
class KannadaHome extends StatelessWidget {
  const KannadaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "BCM ಸೇವೆಗಳಿಗೆ ಸ್ವಾಗತ",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}