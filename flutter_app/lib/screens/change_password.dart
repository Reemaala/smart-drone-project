import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Change Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField("Current Password", Icons.lock_outline, obscureText: true),
            const SizedBox(height: 15),
            _buildTextField("New Password", Icons.lock, obscureText: true),
            const SizedBox(height: 15),
            _buildTextField("Confirm New Password", Icons.lock, obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement change password functionality
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: const Text("Update Password", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Helper Function for Text Fields
  Widget _buildTextField(String hintText, IconData icon, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[900],
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white54),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }
}
