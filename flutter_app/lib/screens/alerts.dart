import 'package:flutter/material.dart';
import 'menu.dart'; 
import 'main_page.dart'; 
import 'control_center.dart'; 
import 'drone_status.dart'; 
import 'media_library.dart'; 
import 'flight_logs.dart';
import 'iphone_frame.dart'; 

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  int _selectedIndex = 1; 
  // 🔹 Navigation function
  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      Widget nextPage;
      switch (index) {
        case 0:
          nextPage = const FlightLogsPage(); 
          break;
        case 1:
          nextPage = const ControlCenterPage();
          break;
        case 2:
          nextPage = const DroneStatusPage();
          break;
        case 3:
          nextPage = const MediaLibraryPage(); 
          break;
        case 4:
          nextPage = const MainPage(); 
          break;
        default:
          return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextPage),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return iPhoneFrame(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ControlCenterPage()),
              );
            },
          ),
        ),
        drawer: const AppMenu(),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Totally Active Alerts",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 10),

            
              _buildAlertCard(color: Colors.red, title: "Critical Alerts", icon: Icons.flash_on, count: "100,000 Alerts"),
              _buildAlertCard(color: Colors.orange, title: "Moderate Alerts", icon: Icons.flash_on, count: "60,000 Alerts"),
              _buildAlertCard(color: Colors.amber, title: "Advisory Alerts", icon: Icons.flash_on, count: "45,000 Alerts"),
              
              const SizedBox(height: 20),

        
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset("assets/makka_alerts.png", width: double.infinity, fit: BoxFit.cover),
              ),
            ],
          ),
        ),

        
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Flight Logs"), 
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Control"), 
            BottomNavigationBarItem(icon: Icon(Icons.airplanemode_active), label: "Drone"),
            BottomNavigationBarItem(icon: Icon(Icons.photo_library), label: "Media"), 
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          ],
        ),
      ),
    );
  }

 
  Widget _buildAlertCard({required Color color, required String title, required IconData icon, required String count}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.white, size: 18),
                  const SizedBox(width: 5),
                  const Text("Full Alerts", style: TextStyle(fontSize: 14, color: Colors.white)),
                ],
              ),
              Text(count, style: const TextStyle(fontSize: 14, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}





