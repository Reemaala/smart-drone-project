import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../local_database.dart';
import 'main_page.dart';
import 'iphone_frame.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<Map<String, String>> allowedAccounts = [
    {'email': 'reham@gmail.com', 'password': '123456'},
    {'email': 'reema@gmail.com', 'password': '123456'},
    {'email': 'nareman@gmail.com', 'password': '123456'},
  ];

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final match = allowedAccounts.firstWhere(
        (account) => account['email'] == email && account['password'] == password,
        orElse: () => {},
      );

      if (match.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email or password is incorrect")),
        );
        return;
      }

      final name = email.split('@')[0];
      final capitalizedName = name[0].toUpperCase() + name.substring(1);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('email', email);
      await prefs.setString('name', capitalizedName);

      await LocalDatabase.insertEmail(email);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return iPhoneFrame(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/makkah_bg.jpg', fit: BoxFit.cover),
            Container(color: Colors.black.withOpacity(0.7)),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("آمِن", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    const Text("Amin", style: TextStyle(fontSize: 20, color: Colors.white)),
                    const SizedBox(height: 10),
                    const Text("(رب اجعل هذا بلداً آمناً)", style: TextStyle(fontSize: 14, color: Colors.white)),
                    const SizedBox(height: 30),

                    const Text("Welcome", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    const Text("Enter your email to sign in", style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 30),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration("Email"),
                            validator: (value) {
                              if (value == null || !value.contains('@')) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration("Password"),
                            validator: (value) {
                              if (value == null || value.length < 4) {
                                return 'Enter a valid password';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Continue"),
                    ),
                    const SizedBox(height: 20),
                    _socialButton("Continue with Google", Colors.white, Colors.black, Icons.g_mobiledata),
                    const SizedBox(height: 12),
                    _socialButton("Continue with Apple", Colors.white, Colors.black, Icons.apple),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.grey[850],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _socialButton(String text, Color bgColor, Color textColor, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: textColor),
      label: Text(text, style: TextStyle(color: textColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

