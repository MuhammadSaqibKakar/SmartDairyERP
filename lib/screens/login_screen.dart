import 'package:flutter/material.dart';
import '../widgets/gradient_button.dart';
import 'email_login_screen.dart';
import 'phone_login_screen.dart';
import 'register_screen.dart';


class LoginScreen extends StatelessWidget {
  final bool isEnglish;
  final VoidCallback toggleLanguage;

  const LoginScreen({
    super.key,
    required this.isEnglish,
    required this.toggleLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.language),
                  onPressed: toggleLanguage,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/baby_cow.png', height: 150),
                    Text(
                      isEnglish ? 'Welcome' : 'خوش آمدید',
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isEnglish ? 'Please sign in' : 'براہ کرم لاگ ان کریں',
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),
                    GradientButton(
                      text: isEnglish
                          ? 'Login with Email'
                          : 'ای میل سے لاگ ان کریں',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EmailLoginScreen(isEnglish: isEnglish),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    GradientButton(
                      text: isEnglish
                          ? 'Login with Phone'
                          : 'فون نمبر سے لاگ ان کریں',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PhoneLoginScreen(isEnglish: isEnglish),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RegisterScreen(isEnglish: isEnglish),
                          ),
                        );
                      },
                      child: Text(
                        isEnglish ? 'Create new account' : 'نیا اکاؤنٹ بنائیں',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
