import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/sign_in.dart';
import 'screens/main_page.dart';
import 'screens/saved_emails_screen.dart';
import 'screens/splash_screen.dart'; // 👈 Splash screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp(isLoggedIn: false));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required bool isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hajj App',
      theme: ThemeData.dark(),
      home: const SplashScreen(), // 👈 Start with splash screen
      routes: {
        '/main': (context) => const MainPage(),
        '/signin': (context) => const SignInScreen(),
        '/savedEmails': (context) => const SavedEmailsScreen(),
      },
    );
  }
}


