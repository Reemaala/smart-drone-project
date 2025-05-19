import 'package:flutter/material.dart';

class iPhoneFrame extends StatelessWidget {
  final Widget child;
  const iPhoneFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(child: child),
      ),
    );
  }
}
