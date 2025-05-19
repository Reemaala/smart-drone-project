import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'control_center.dart';
import 'drone_status.dart';
import 'real_time_monitoring.dart';
import 'alerts.dart';
import 'weather.dart';
import 'flight_logs.dart';
import 'media_library.dart';
import 'account.dart';
import 'main_page.dart';
import 'sign_in.dart';
import 'iphone_frame.dart';
import 'mock_camera_page.dart';

class AppMenu extends StatefulWidget {
  const AppMenu({super.key});

  @override
  State<AppMenu> createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  String _userName = "User Name";
  String _userEmail = "user@example.com";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('name') ?? "User Name";
      _userEmail = prefs.getString('email') ?? "user@example.com";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        children: [
          // 👤 User Info Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  _userEmail,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.grey),

          // 📋 Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(context, Icons.home, "Home", const MainPage()),
                _buildMenuItem(context, Icons.person, "Account", const AccountPage()),
                _buildMenuItem(context, Icons.grid_view, "Control Center", const ControlCenterPage()),
                _buildMenuItem(context, Icons.flight, "Drone Status", const DroneStatusPage()),
                _buildMenuItem(context, Icons.visibility, "Real-Time Monitoring", const RealTimeMonitoringPage()),
                _buildMenuItem(context, Icons.warning, "Alerts", const AlertsPage()),
                _buildMenuItem(context, Icons.cloud, "Weather", const WeatherPage()),
                _buildMenuItem(context, Icons.list, "Flight Logs", const FlightLogsPage()),
                _buildMenuItem(context, Icons.photo_library, "Media Library", const MediaLibraryPage()),
                _buildMenuItem(context, Icons.camera_alt, "Mock Camera", const MockCameraPage()),
              ],
            ),
          ),

          const Divider(color: Colors.grey),

          // 🚪 Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => iPhoneFrame(child: page)),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => iPhoneFrame(child: const SignInScreen()),
                  ),
                );
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}



