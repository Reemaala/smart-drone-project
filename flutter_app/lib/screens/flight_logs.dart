import 'package:flutter/material.dart';
import 'flight_logs.dart'; 
import 'menu.dart'; 
import 'account.dart';
import 'weather.dart';
import 'real_time_monitoring.dart';
import 'control_center.dart';
import 'main_page.dart';
import 'alerts.dart';
import 'media_library.dart';
import 'drone_status.dart';
import 'iphone_frame.dart'; 

class FlightLogsPage extends StatefulWidget {
  const FlightLogsPage({super.key});

  @override
  FlightLogsPageState createState() => FlightLogsPageState();
}

class FlightLogsPageState extends State<FlightLogsPage> {
  int selectedIndex = 0; 
  String searchQuery = ""; 

 
  final List<Map<String, String>> flightLogs = [
    {"date": "Feb 20, 2024", "location": "Makkah, Saudi Arabia", "duration": "8 hrs", "battery": "25%", "altitude": "60m"},
    {"date": "Feb 18, 2024", "location": "Mina, Saudi Arabia", "duration": "5 hrs", "battery": "45%", "altitude": "60m"},
    {"date": "Feb 15, 2024", "location": "Arafat, Saudi Arabia", "duration": "6 hrs", "battery": "40%", "altitude": "60m"},
    {"date": "Feb 10, 2024", "location": "Muzdalifah, Saudi Arabia", "duration": "7 hrs", "battery": "35%", "altitude": "60m"},
  ];

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

        body: Column(
          children: [
            
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search by location or date",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[900],
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),

            Expanded(
              child: ListView(
                children: flightLogs
                    .where((log) =>
                        log["date"]!.toLowerCase().contains(searchQuery) ||
                        log["location"]!.toLowerCase().contains(searchQuery))
                    .map((log) => _buildFlightLog(log))
                    .toList(),
              ),
            ),
          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          currentIndex: selectedIndex, 
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Flight Logs"), 
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Control Center"),
            BottomNavigationBarItem(icon: Icon(Icons.airplanemode_active), label: "Drone"), 
            BottomNavigationBarItem(icon: Icon(Icons.photo_library), label: "Media"), 
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"), 
          ],
        ),
      ),
    );
  }

  Widget _buildFlightLog(Map<String, String> log) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.flight_takeoff, color: Colors.blueAccent),
        title: Text(log["location"]!, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text("${log["date"]} • ${log["duration"]}", style: const TextStyle(color: Colors.grey, fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        onTap: () {
          _showFlightDetails(log);
        },
      ),
    );
  }

  void _showFlightDetails(Map<String, String> log) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          content: SizedBox(
            width: 250, 
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Date: ${log["date"]}", style: const TextStyle(color: Colors.grey)),
                Text("Duration: ${log["duration"]}", style: const TextStyle(color: Colors.grey)),
                Text("Battery: ${log["battery"]}", style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/flight_path.png", 
                    fit: BoxFit.cover,
                    height: 200, 
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close", style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }
}