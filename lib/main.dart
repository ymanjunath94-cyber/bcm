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
      ),
      home: const LoginPhoneScreen(),
    );
  }
}

/* --------------------------- LOGIN (Demo OTP) --------------------------- */
// Demo flow (no backend yet):
// 1) Enter phone -> Send OTP
// 2) Use OTP: 123456
// Replace later with Firebase PhoneAuth.
class LoginPhoneScreen extends StatefulWidget {
  const LoginPhoneScreen({super.key});
  @override
  State<LoginPhoneScreen> createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  bool _sent = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BCM Services'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Login with Phone / ಫೋನ್ ಮೂಲಕ ಲಾಗಿನ್',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone (+91XXXXXXXXXX)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter phone number';
                    final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
                    if (digits.length < 10) return 'Enter valid 10-digit number';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                if (_sent)
                  TextFormField(
                    controller: _otpCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Enter OTP',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (!_sent) return null;
                      if (v == null || v.isEmpty) return 'Enter OTP';
                      return null;
                    },
                  ),
                const SizedBox(height: 12),
                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _sent ? _verifyOtp : _sendOtp,
                        child: Text(_sent ? 'Verify OTP / ದೃಢೀಕರಿಸಿ' : 'Send OTP / OTP ಕಳುಹಿಸಿ'),
                      ),
                const SizedBox(height: 8),
                if (_sent)
                  const Text(
                    'Demo OTP: 123456',
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _sent = true;
      _loading = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent (demo). Use 123456')),
      );
    }
  }

  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (_otpCtrl.text.trim() == '123456') {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } else {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wrong OTP (demo). Use 123456')),
        );
      }
    }
  }
}

/* ----------------------------- HOME (Cards) ----------------------------- */

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = <_ServiceCard>[
      _ServiceCard(
        titleEn: 'RTC Land Records',
        titleKn: 'RTC ಭೂ ದಾಖಲೆಗಳು',
        icon: Icons.description_outlined,
        onTap: () => _open(context, const RTCScreen()),
      ),
      _ServiceCard(
        titleEn: 'Village / Land Map',
        titleKn: 'ಗ್ರಾಮ / ಭೂ ನಕ್ಷೆ',
        icon: Icons.map_outlined,
        onTap: () => _open(context, const LandMapScreen()),
      ),
      _ServiceCard(
        titleEn: 'News & Notices',
        titleKn: 'ಸುದ್ದಿ & ಸೂಚನೆ',
        icon: Icons.newspaper,
        onTap: () => _open(context, const NewsScreen()),
      ),
      _ServiceCard(
        titleEn: 'Loan Assistance',
        titleKn: 'ಸಾಲ ಸಹಾಯ',
        icon: Icons.account_balance,
        onTap: () => _open(context, const LoansScreen()),
      ),
      _ServiceCard(
        titleEn: 'Police / Case Help',
        titleKn: 'ಪೊಲೀಸ್ / ಪ್ರಕರಣ ಸಹಾಯ',
        icon: Icons.local_police_outlined,
        onTap: () => _open(context, const PoliceHelpScreen()),
      ),
      _ServiceCard(
        titleEn: 'Govt Schemes',
        titleKn: 'ಸರ್ಕಾರಿ ಯೋಜನೆಗಳು',
        icon: Icons.account_balance_wallet_outlined,
        onTap: () => _open(context, const SchemesScreen()),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('BCM Services'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Logout / ಲಾಗ್ ಔಟ್',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPhoneScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: cards.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (_, i) => _ServiceTile(card: cards[i]),
        ),
      ),
    );
  }

  static void _open(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _ServiceCard {
  final String titleEn;
  final String titleKn;
  final IconData icon;
  final VoidCallback onTap;
  _ServiceCard({required this.titleEn, required this.titleKn, required this.icon, required this.onTap});
}

class _ServiceTile extends StatelessWidget {
  final _ServiceCard card;
  const _ServiceTile({required this.card});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: card.onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [BoxShadow(blurRadius: 8, color: Color(0x22000000), offset: Offset(0, 4))],
          border: Border.fromBorderSide(BorderSide(color: Colors.green, width: 1)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(card.icon, size: 36, color: Colors.green.shade700),
              const SizedBox(height: 12),
              Text(
                card.titleEn,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                card.titleKn,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ----------------------- Placeholder feature screens -------------------- */

class RTCScreen extends StatelessWidget {
  const RTCScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return _scaffold(
      context,
      title: 'RTC / RTC ಭೂ ದಾಖಲೆಗಳು',
      body: const Text('Add: Survey No, Owner, Village, Taluk, Year.\n(Next step: connect to API)'),
    );
  }
}

class LandMapScreen extends StatelessWidget {
  const LandMapScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return _scaffold(
      context,
      title: 'Maps / ನಕ್ಷೆ',
      body: const Text('Google Map & Survey overlay coming next.'),
    );
  }
}

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return _scaffold(
      context,
      title: 'News / ಸುದ್ದಿ',
      body: const Text('Feed with govt notices, agri updates (demo).'),
    );
  }
}

class LoansScreen extends StatelessWidget {
  const LoansScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return _scaffold(
      context,
      title: 'Loans / ಸಾಲ',
      body: const Text('Bank loan help & document checklist.'),
    );
  }
}

class PoliceHelpScreen extends StatelessWidget {
  const PoliceHelpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return _scaffold(
      context,
      title: 'Police Help / ಪೊಲೀಸ್ ಸಹಾಯ',
      body: const Text('FIR guidance, case status follow-up (demo).'),
    );
  }
}

class SchemesScreen extends StatelessWidget {
  const SchemesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return _scaffold(
      context,
      title: 'Govt Schemes / ಸರ್ಕಾರಿ ಯೋಜನೆಗಳು',
      body: const Text('Yojana list & eligibility (demo).'),
    );
  }
}

/* ------------------------------ Helpers -------------------------------- */

Scaffold _scaffold(BuildContext context, {required String title, required Widget body}) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: body,
      ),
    ),
  );
}