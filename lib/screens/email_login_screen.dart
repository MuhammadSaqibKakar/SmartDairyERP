import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/gradient_button.dart';
import 'dashboard_screen.dart';

class EmailLoginScreen extends StatefulWidget {
  final bool isEnglish;
  final ValueChanged<bool>? onLanguageToggle; // updated

  const EmailLoginScreen({
    super.key,
    required this.isEnglish,
    this.onLanguageToggle,
  });

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _passwordCtl = TextEditingController();
  bool loading = false;
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
    _emailCtl.dispose();
    _passwordCtl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;

    setState(() => loading = true);

    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtl.text.trim(),
        password: _passwordCtl.text,
      );

      if (cred.user != null && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardScreen(
              isEnglish: isEnglish,
              onLanguageToggle: (lang) {
                setState(() {
                  isEnglish = lang;
                });
                if (widget.onLanguageToggle != null) {
                  widget.onLanguageToggle!(lang);
                }
              },
            ),
          ),
          (_) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    } finally {
      if (!mounted) return;
      setState(() => loading = false);
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
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    isEnglish ? 'Login with Email' : 'ای میل سے لاگ ان کریں',
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailCtl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: isEnglish ? 'Email' : 'ای میل',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return isEnglish ? 'Enter email' : 'ای میل درج کریں';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordCtl,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: isEnglish ? 'Password' : 'پاس ورڈ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return isEnglish ? 'Enter password' : 'پاس ورڈ درج کریں';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  loading
                      ? const CircularProgressIndicator()
                      : GradientButton(
                          text: isEnglish ? 'Login' : 'لاگ ان',
                          onPressed: _login,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
