import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_page.dart';
import 'sign_in.dart';
import 'iphone_frame.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _taglineController;
  late Animation<double> _taglineFade;

  String displayedTitle = '';
  final String fullTitle = 'آمِن';
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTitleAnimation();
    _setupTaglineAnimation();
    _navigateNext();
  }

  void _startTitleAnimation() {
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (_charIndex < fullTitle.length) {
        setState(() {
          displayedTitle += fullTitle[_charIndex];
          _charIndex++;
        });
      } else {
        timer.cancel();
        _titleController.forward();
      }
    });
  }

  void _setupTaglineAnimation() {
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _taglineFade = CurvedAnimation(parent: _taglineController, curve: Curves.easeIn);
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 4));
    _taglineController.forward();

    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final nextPage = isLoggedIn ? const MainPage() : const SignInScreen();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => iPhoneFrame(child: nextPage)),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full background
          Image.asset('assets/makkah_bg.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.7)),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 600),
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 20, color: Colors.blueAccent)],
                  ),
                  child: Text(displayedTitle),
                ),
                const SizedBox(height: 12),
                FadeTransition(
                  opacity: _taglineFade,
                  child: const Text(
                    "Protect. Detect. Respond.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



