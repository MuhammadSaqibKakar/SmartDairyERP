import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/gradient_button.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  final bool isEnglish;
  const RegisterScreen({super.key, required this.isEnglish});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailCtl = TextEditingController();
  final _passwordCtl = TextEditingController();
  final _confirmPasswordCtl = TextEditingController();

  bool loading = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  void dispose() {
    _emailCtl.dispose();
    _passwordCtl.dispose();
    _confirmPasswordCtl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailCtl.text.trim(),
        password: _passwordCtl.text,
      );

      if (cred.user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(isEnglish: widget.isEnglish),
          ),
          (_) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      final msg = e.message ?? "Registration failed";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.isEnglish;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t ? 'Create Account' : 'اکاؤنٹ بنائیں',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Email Field
                  TextFormField(
                    controller: _emailCtl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: t ? 'Email' : 'ای میل',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return t ? 'Enter email' : 'ای میل درج کریں';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                        return t ? 'Enter valid email' : 'درست ای میل درج کریں';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Password Field
                  TextFormField(
                    controller: _passwordCtl,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      labelText: t ? 'Password' : 'پاس ورڈ',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          setState(() => hidePassword = !hidePassword);
                        },
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return t ? 'Enter password' : 'پاس ورڈ درج کریں';
                      }
                      if (v.length < 6) {
                        return t
                            ? 'Minimum 6 characters'
                            : 'کم از کم 6 حروف ہونا ضروری ہے';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Confirm Password Field
                  TextFormField(
                    controller: _confirmPasswordCtl,
                    obscureText: hideConfirmPassword,
                    decoration: InputDecoration(
                      labelText: t ? 'Confirm Password' : 'پاس ورڈ دوبارہ درج کریں',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          hideConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          setState(() =>
                              hideConfirmPassword = !hideConfirmPassword);
                        },
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return t
                            ? 'Confirm your password'
                            : 'پاس ورڈ دوبارہ درج کریں';
                      }
                      if (v != _passwordCtl.text) {
                        return t
                            ? 'Passwords do not match'
                            : 'پاس ورڈ ایک جیسے نہیں ہیں';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 22),

                  // Register Button
                  loading
                      ? const Center(child: CircularProgressIndicator())
                      : GradientButton(
                          text: t ? 'Register' : 'رجسٹر کریں',
                          onPressed: _register,
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
