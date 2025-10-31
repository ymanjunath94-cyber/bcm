import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
                Text('Login with Phone / ಫೋನ್ ಮೂಲಕ ಲಾಗಿನ್',
                    style: Theme.of(context).textTheme.titleMedium),
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
                    final d = v.replaceAll(RegExp(r'[^0-9]'), '');
                    if (d.length < 10) return 'Enter valid 10-digit number';
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
                        child: Text(_sent ? 'Verify OTP / ದೃಢೀಕರಿಸಿ'
                                         : 'Send OTP / OTP ಕಳುಹಿಸಿ'),
                      ),
                const SizedBox(height: 8),
                if (_sent)
                  const Text('Demo OTP: 123456', textAlign: TextAlign.center),
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
    setState(() { _sent = true; _loading = false; });
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
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
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

  static const _whatsAppNumber = '917760394741'; // your number with country code
  static const _callNumber = '7760394741';

  @override
  Widget build(BuildContext context) {
    final cards = <_ServiceCard>[
      _ServiceCard(
        titleEn: 'RTC Land Records',
        titleKn: 'RTC ಭೂ ದಾಖಲೆಗಳು',
        icon: Icons.description_outlined,
        onTap: () => _openWeb(
          'https://bhoomionline.karnataka.gov.in/'),
      ),
      _ServiceCard(
        titleEn: 'Village / Land Map',
        titleKn: 'ಗ್ರಾಮ / ಭೂ ನಕ್ಷೆ',
        icon: Icons.map_outlined,
        onTap: () => _openWeb(
          'https://bhoomipublic.karnataka.gov.in/landrecords'),
      ),
      _ServiceCard(
        titleEn: 'News & Notices',
        titleKn: 'ಸುದ್ದಿ & ಸೂಚನೆ',
        icon: Icons.newspaper,
        onTap: () => _openWeb('https://www.karnataka.gov.in'),
      ),
      _ServiceCard(
        titleEn: 'Loan Assistance',
        titleKn: 'ಸಾಲ ಸಹಾಯ',
        icon: Icons.account_balance,
        onTap: () => _open(context, const RequestFormScreen(topic: 'Loan Assistance / ಸಾಲ ಸಹಾಯ')),
      ),
      _ServiceCard(
        titleEn: 'Police / Case Help',
        titleKn: 'ಪೊಲೀಸ್ / ಪ್ರಕರಣ ಸಹಾಯ',
        icon: Icons.local_police_outlined,
        onTap: () => _open(context, const RequestFormScreen(topic: 'Police / Case Help / ಪೊಲೀಸ್ ಸಹಾಯ')),
      ),
      _ServiceCard(
        titleEn: 'Govt Schemes',
        titleKn: 'ಸರ್ಕಾರಿ ಯೋಜನೆಗಳು',
        icon: Icons.account_balance_wallet_outlined,
        onTap: () => _open(context, const RequestFormScreen(topic: 'Govt Schemes / ಸರ್ಕಾರಿ ಯೋಜನೆಗಳು')),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('BCM Services'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'WhatsApp',
            icon: const Icon(Icons.chat),
            onPressed: () => _openWeb('https://wa.me/$_whatsAppNumber?text=Hello%20BCM'),
          ),
          IconButton(
            tooltip: 'Call',
            icon: const Icon(Icons.call),
            onPressed: () => _openWeb('tel:$_callNumber'),
          ),
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
            crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.1),
          itemBuilder: (_, i) => _ServiceTile(card: cards[i]),
        ),
      ),
    );
  }

  static void _open(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  static Future<void> _openWeb(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // try in-app if external failed
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
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
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(card.icon, size: 36, color: Colors.green.shade700),
            const SizedBox(height: 12),
            Text(card.titleEn, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(card.titleKn, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ]),
        ),
      ),
    );
  }
}

/* ---------------------- Simple Request Form (inside app) ---------------- */

class RequestFormScreen extends StatefulWidget {
  final String topic;
  const RequestFormScreen({super.key, required this.topic});
  @override
  State<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _village = TextEditingController();
  final _details = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Name / ಹೆಸರು', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone / ಫೋನ್', border: OutlineInputBorder()),
                validator: (v) => v == null || v.length < 10 ? 'Enter valid phone' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _village,
                decoration: const InputDecoration(labelText: 'Village / ಗ್ರಾಮ', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _details,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Details / ವಿವರ', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: _submit,
                child: const Text('Submit Request / ವಿನಂತಿ ಕಳುಹಿಸಿ'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {
                  final text =
                      'BCM Service Request:\nTopic: ${widget.topic}\nName: ${_name.text}\nPhone: ${_phone.text}\nVillage: ${_village.text}\nDetails: ${_details.text}';
                  HomeScreen._openWeb('https://wa.me/917760394741?text=${Uri.encodeComponent(text)}');
                },
                icon: const Icon(Icons.chat),
                label: const Text('Send via WhatsApp'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Submitted (local). We will connect to backend next.')),
    );
    Navigator.pop(context);
  }
}