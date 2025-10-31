import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const BCMApp());
}

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
      home: const PhoneLoginScreen(),
    );
  }
}

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});
  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final phoneCtrl = TextEditingController();
  final otpCtrl = TextEditingController();
  String? verificationId;
  bool sending = false;
  bool otpSent = false;

  Future<void> sendOtp() async {
    final phone = phoneCtrl.text.trim();
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid phone (include +91...)')),
      );
      return;
    }
    setState(() => sending = true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (cred) async {
        await FirebaseAuth.instance.signInWithCredential(cred);
        if (mounted) Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const HomeScreen()));
      },
      verificationFailed: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${e.message}')),
        );
        setState(() => sending = false);
      },
      codeSent: (verId, _) {
        setState(() {
          verificationId = verId;
          otpSent = true;
          sending = false;
        });
      },
      codeAutoRetrievalTimeout: (verId) {
        verificationId = verId;
      },
    );
  }

  Future<void> verifyOtp() async {
    final code = otpCtrl.text.trim();
    if (verificationId == null || code.length < 6) return;
    try {
      final cred = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: code);
      await FirebaseAuth.instance.signInWithCredential(cred);
      if (mounted) {
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid code: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BCM Services')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone (+91XXXXXXXXXX)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            if (otpSent)
              TextField(
                controller: otpCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter OTP',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: sending ? null : (otpSent ? verifyOtp : sendOtp),
              child: Text(sending
                  ? 'Please wait...'
                  : (otpSent ? 'Verify OTP' : 'Send OTP')),
            ),
          ],
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
      appBar: AppBar(
        title: const Text('BCM Services'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const PhoneLoginScreen()),
                  (_) => false,
                );
              }
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          )
        ],
      ),
      body: const Center(
        child: Text('Welcome to BCM Services',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
    );
  }
}