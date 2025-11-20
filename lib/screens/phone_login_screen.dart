import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/gradient_button.dart';
import 'dashboard_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  final bool isEnglish;
  final ValueChanged<bool>? onLanguageToggle; // updated

  const PhoneLoginScreen({
    super.key,
    required this.isEnglish,
    this.onLanguageToggle,
  });

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneCtl = TextEditingController();
  final _otpCtl = TextEditingController();
  String? _verificationId;
  bool sending = false;
  bool verifying = false;
  late bool isEnglish;

  @override
  void initState() {
    super.initState();
    isEnglish = widget.isEnglish;
  }

  void toggleLanguage() {
    if (!mounted) return;
    setState(() => isEnglish = !isEnglish);
    if (widget.onLanguageToggle != null) {
      widget.onLanguageToggle!(isEnglish);
    }
  }

  @override
  void dispose() {
    _phoneCtl.dispose();
    _otpCtl.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final phone = _phoneCtl.text.trim();
    if (phone.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEnglish ? 'Enter phone' : 'فون درج کریں')),
      );
      return;
    }

    if (!mounted) return;
    setState(() => sending = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone.startsWith('+') ? phone : '+$phone',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => DashboardScreen(
                isEnglish: isEnglish,
                onLanguageToggle: (lang) {
                  setState(() => isEnglish = lang);
                  if (widget.onLanguageToggle != null) {
                    widget.onLanguageToggle!(lang);
                  }
                },
              ),
            ),
            (_) => false,
          );
        } catch (_) {}
      },
      verificationFailed: (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Verification failed')),
        );
        setState(() => sending = false);
      },
      codeSent: (verificationId, resendToken) {
        if (!mounted) return;
        setState(() {
          _verificationId = verificationId;
          sending = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEnglish ? 'OTP sent' : 'او ٹی پی بھیجا گیا')),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> _verifyOtp() async {
    final otp = _otpCtl.text.trim();
    if (otp.isEmpty || _verificationId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEnglish ? 'Enter OTP' : 'او ٹی پی درج کریں')),
      );
      return;
    }

    if (!mounted) return;
    setState(() => verifying = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => DashboardScreen(
            isEnglish: isEnglish,
            onLanguageToggle: (lang) {
              setState(() => isEnglish = lang);
              if (widget.onLanguageToggle != null) {
                widget.onLanguageToggle!(lang);
              }
            },
          ),
        ),
        (_) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Verification failed')),
      );
    } finally {
      if (!mounted) return;
      setState(() => verifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: toggleLanguage,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                isEnglish ? 'Phone Login' : 'فون لاگ ان',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _phoneCtl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: isEnglish
                      ? 'Phone (with country code)'
                      : 'فون (کنٹری کوڈ کے ساتھ)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  hintText: '+92xxxxxxxxxx',
                ),
              ),
              const SizedBox(height: 12),
              sending
                  ? const CircularProgressIndicator()
                  : GradientButton(
                      text: isEnglish ? 'Send OTP' : 'او ٹی پی بھیجیں',
                      onPressed: _sendCode,
                    ),
              const SizedBox(height: 20),
              TextField(
                controller: _otpCtl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: isEnglish ? 'Enter OTP' : 'او ٹی پی درج کریں',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              verifying
                  ? const CircularProgressIndicator()
                  : GradientButton(
                      text: isEnglish ? 'Verify OTP' : 'او ٹی پی کی تصدیق کریں',
                      onPressed: _verifyOtp,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
