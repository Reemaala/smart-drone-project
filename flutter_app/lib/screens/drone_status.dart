import 'package:flutter/material.dart';
import 'menu.dart'; 
import 'weather.dart';
import 'control_center.dart';
import 'main_page.dart';
import 'flight_logs.dart';
import 'media_library.dart'; 
import 'iphone_frame.dart';

class DroneStatusPage extends StatefulWidget {
  const DroneStatusPage({super.key});

  @override
  DroneStatusPageState createState() => DroneStatusPageState();
}

class DroneStatusPageState extends State<DroneStatusPage> {
  int selectedIndex = 2; 

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
          // Title removed
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

        // 🔹 BODY CONTENT
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
     
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.wifi, color: Colors.green, size: 22),
                            SizedBox(width: 6),
                            Text("Connected", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text("26", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                        Text("MINS FLYING LEFT", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: Image.asset("assets/drone_icon.png", fit: BoxFit.cover),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              
              _buildCard(
                title: "Battery Status",
                content: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("39.8°C", style: TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.bold)),
                        Text("11 Mins Ago", style: TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(width: 15),
                    Expanded(child: _buildBatteryGraph()),
                  ],
                ),
              ),

              const SizedBox(height: 15),

           
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _buildCard(
                        title: "Current Location",
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Around 50 Aziziyah, Makkah", style: TextStyle(color: Colors.grey, fontSize: 14)),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset("assets/map_image.png", height: 150, width: double.infinity, fit: BoxFit.cover),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                
                    Expanded(
                      child: _buildCard(
                        title: "Altitude Limited",
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("58 m", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                            Slider(
                              value: 58,
                              min: 0,
                              max: 120,
                              activeColor: Colors.blue,
                              inactiveColor: Colors.grey,
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 🔹 UPDATED BOTTOM NAVIGATION BAR (Weather, Control, Drone, Home)
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


  Widget _buildBatteryGraph() {
    return Container(
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Image.asset("assets/battery_graph.png", width: double.infinity, height: 100, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "BATTERY LEVEL",
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCard({required String title, required Widget content}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }
}



