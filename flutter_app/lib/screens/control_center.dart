import 'package:flutter/material.dart';
import 'menu.dart'; 
import 'main_page.dart'; 
import 'alerts.dart'; 
import 'real_time_monitoring.dart'; 
import 'weather.dart'; 
import 'flight_logs.dart'; 
import 'drone_status.dart'; 
import 'media_library.dart'; 
import 'iphone_frame.dart';

class ControlCenterPage extends StatefulWidget {
  const ControlCenterPage({super.key});

  @override
  ControlCenterPageState createState() => ControlCenterPageState();
}

class ControlCenterPageState extends State<ControlCenterPage> {
  int selectedIndex = 1; 

  // 🔹 Navigation function
  void _onItemTapped(int index) {
    if (index != selectedIndex) {
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
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); 
              },
            ),
          ),
        ),
        drawer: const AppMenu(), 
        
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Control Center",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),

              _buildControlOption(context, "Real-Time Monitoring", const RealTimeMonitoringPage()),
              _buildControlOption(context, "Emergency Alerts", const AlertsPage()),
              _buildControlOption(context, "Weather", const WeatherPage()),  
            ],
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          currentIndex: selectedIndex, 
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

  // 🔹 Function to Build Each Option
  Widget _buildControlOption(BuildContext context, String title, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500)),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}
